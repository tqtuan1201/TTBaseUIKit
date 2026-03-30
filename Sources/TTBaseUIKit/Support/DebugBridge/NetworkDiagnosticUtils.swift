//
//  NetworkDiagnosticUtils.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-30.
//  Network diagnostics: IP, subnet, VPN detection, Wi-Fi reachability
//

import Foundation
import Network

// MARK: - Network Diagnostic Utilities
/// Thread-safe utility enum for querying local network state.
/// Used by `ConnectionDiagnostics` to provide context when debugging connection issues.
public enum NetworkDiagnosticUtils {
    
    // MARK: - Local IP Address
    
    /// Returns the device's local IPv4 address on the Wi-Fi interface (en0).
    /// Falls back to any non-loopback IPv4 address if en0 is unavailable.
    public static func getLocalIPAddress() -> String? {
        var address: String?
        var fallback: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let sa = ptr.pointee.ifa_addr.pointee
            guard sa.sa_family == UInt8(AF_INET) else { continue }
            
            let name = String(cString: ptr.pointee.ifa_name)
            
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(ptr.pointee.ifa_addr, socklen_t(sa.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, 0, NI_NUMERICHOST)
            let ip = String(cString: hostname)
            
            if name == "en0" {
                address = ip
                break
            } else if name != "lo0" && fallback == nil {
                fallback = ip
            }
        }
        
        return address ?? fallback
    }
    
    // MARK: - Subnet Mask
    
    /// Returns the subnet mask for the Wi-Fi interface (en0).
    public static func getSubnetMask() -> String? {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return nil }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let sa = ptr.pointee.ifa_addr.pointee
            guard sa.sa_family == UInt8(AF_INET) else { continue }
            
            let name = String(cString: ptr.pointee.ifa_name)
            guard name == "en0" else { continue }
            
            guard let netmask = ptr.pointee.ifa_netmask else { continue }
            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            getnameinfo(netmask, socklen_t(netmask.pointee.sa_len),
                        &hostname, socklen_t(hostname.count),
                        nil, 0, NI_NUMERICHOST)
            return String(cString: hostname)
        }
        return nil
    }
    
    // MARK: - Network Prefix (for same-network comparison)
    
    /// Computes the network prefix (e.g. `192.168.1.0`) from IP and subnet mask.
    /// Two devices with the same prefix are on the same subnet.
    public static func getNetworkPrefix() -> String? {
        guard let ip = getLocalIPAddress(),
              let mask = getSubnetMask() else { return nil }
        return computeNetworkPrefix(ip: ip, mask: mask)
    }
    
    /// Pure function: given an IP and mask, returns the network prefix string.
    public static func computeNetworkPrefix(ip: String, mask: String) -> String? {
        guard let ipInt = ipToUInt32(ip),
              let maskInt = ipToUInt32(mask) else { return nil }
        let prefix = ipInt & maskInt
        return uint32ToIP(prefix)
    }
    
    // MARK: - VPN Detection
    
    /// Returns `true` if a VPN tunnel interface (utunN or ipsecN) is active.
    public static func isVPNActive() -> Bool {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0, let firstAddr = ifaddr else { return false }
        defer { freeifaddrs(ifaddr) }
        
        for ptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let name = String(cString: ptr.pointee.ifa_name)
            let flags = Int32(ptr.pointee.ifa_flags)
            let isUp = (flags & IFF_UP) != 0 && (flags & IFF_RUNNING) != 0
            
            if isUp && (name.hasPrefix("utun") || name.hasPrefix("ipsec") || name.hasPrefix("ppp")) {
                return true
            }
        }
        return false
    }
    
    // MARK: - Wi-Fi Check
    
    /// Returns `true` if the Wi-Fi interface (en0) has an active IPv4 address.
    public static func isWiFiConnected() -> Bool {
        return getLocalIPAddress() != nil
    }
    
    // MARK: - IP ↔ UInt32 Conversion
    
    private static func ipToUInt32(_ ip: String) -> UInt32? {
        let parts = ip.split(separator: ".").compactMap { UInt32($0) }
        guard parts.count == 4 else { return nil }
        return (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8) | parts[3]
    }
    
    private static func uint32ToIP(_ value: UInt32) -> String {
        let a = (value >> 24) & 0xFF
        let b = (value >> 16) & 0xFF
        let c = (value >> 8) & 0xFF
        let d = value & 0xFF
        return "\(a).\(b).\(c).\(d)"
    }
}
