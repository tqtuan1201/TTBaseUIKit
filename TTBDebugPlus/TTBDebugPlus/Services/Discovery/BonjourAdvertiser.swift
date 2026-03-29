//
//  BonjourAdvertiser.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Advertises the macOS debug service via Bonjour for iOS device discovery
//

import Foundation
import Network

// MARK: - Bonjour Advertiser
/// Advertises `_ttbdebug._tcp` on the local network using NWListener.
/// iOS devices running TTBaseUIKit will discover this service via NWBrowser.
final class BonjourAdvertiser {
    
    static let serviceType = "_ttbdebug._tcp"
    static let serviceDomain = "local"
    
    private var listener: NWListener?
    private let queue = DispatchQueue(label: "com.ttbdebug.advertiser", qos: .userInitiated)
    
    // Callbacks
    var onNewConnection: ((NWConnection) -> Void)?
    var onStateChange: ((NWListener.State) -> Void)?
    
    /// The port the service is actually listening on (assigned after start)
    private(set) var port: NWEndpoint.Port?
    
    // MARK: - Start
    /// Start advertising the Bonjour service and listening for WebSocket connections
    func start(port requestedPort: UInt16 = 0) throws {
        // Configure plain TCP (no WebSocket — uses length-prefixed framing)
        let parameters = NWParameters.tcp
        
        // Allow local network
        parameters.requiredInterfaceType = .wifi
        parameters.includePeerToPeer = true
        
        // Create listener
        let portValue: NWEndpoint.Port = requestedPort > 0 ? NWEndpoint.Port(rawValue: requestedPort)! : .any
        let newListener = try NWListener(using: parameters, on: portValue)
        
        // Advertise via Bonjour
        newListener.service = NWListener.Service(
            name: "TTBDebugPlus",
            type: Self.serviceType,
            domain: Self.serviceDomain
        )
        
        // State handler
        newListener.stateUpdateHandler = { [weak self] state in
            switch state {
            case .ready:
                if let port = newListener.port {
                    self?.port = port
                    print("[TTBDebug] ✅ Bonjour advertiser ready on port \(port)")
                }
            case .failed(let error):
                print("[TTBDebug] ❌ Bonjour advertiser failed: \(error)")
            case .cancelled:
                print("[TTBDebug] ⏹ Bonjour advertiser cancelled")
            case .waiting(let error):
                print("[TTBDebug] ⏳ Bonjour advertiser waiting: \(error)")
            default:
                break
            }
            self?.onStateChange?(state)
        }
        
        // New connection handler
        newListener.newConnectionHandler = { [weak self] connection in
            print("[TTBDebug] 📱 New connection from: \(connection.endpoint)")
            self?.onNewConnection?(connection)
        }
        
        newListener.start(queue: queue)
        self.listener = newListener
        
        print("[TTBDebug] 🔍 Advertising '\(Self.serviceType)' on local network...")
    }
    
    // MARK: - Stop
    func stop() {
        listener?.cancel()
        listener = nil
        port = nil
        print("[TTBDebug] Bonjour advertiser stopped")
    }
    
    deinit {
        stop()
    }
}
