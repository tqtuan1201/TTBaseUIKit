//
//  DebugBridgeStatusView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-30.
//  SwiftUI floating diagnostic overlay for iOS apps integrating TTDebugBridge
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Debug Bridge Status View (iOS 14+)
/// A floating pill/badge that shows TTDebugBridge connection status.
/// Tap to expand into a full diagnostics panel.
///
/// Usage:
/// ```swift
/// #if DEBUG
/// TTDebugBridge.shared.start()
/// TTDebugBridge.shared.showDiagnosticOverlay()
/// #endif
/// ```
@available(iOS 14.0, *)
public struct DebugBridgeStatusView: View {
    
    @State private var isExpanded: Bool = false
    @State private var bridgeState: TTDebugBridge.BridgeState = .idle
    @State private var snapshot: ConnectionDiagnostics.Snapshot?
    @State private var refreshTimer: Timer?
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            HStack {
                Spacer()
                
                if isExpanded {
                    expandedPanel
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.5, anchor: .bottomTrailing).combined(with: .opacity),
                            removal: .scale(scale: 0.8, anchor: .bottomTrailing).combined(with: .opacity)
                        ))
                } else {
                    floatingPill
                        .transition(.scale(scale: 0.5).combined(with: .opacity))
                }
            }
            .padding(.trailing, 16)
            .padding(.bottom, 16)
        }
        .onAppear {
            bridgeState = TTDebugBridge.shared.state
            TTDebugBridge.shared.onStateChange = { newState in
                withAnimation(.easeInOut(duration: 0.3)) {
                    bridgeState = newState
                }
                if isExpanded { refreshSnapshot() }
            }
        }
        .onDisappear {
            refreshTimer?.invalidate()
            refreshTimer = nil
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }
    
    // MARK: - Floating Pill
    
    private var floatingPill: some View {
        Button(action: {
            isExpanded = true
            refreshSnapshot()
            startAutoRefresh()
        }) {
            HStack(spacing: 6) {
                Circle()
                    .fill(colorForState(bridgeState))
                    .frame(width: 8, height: 8)
                    .overlay(
                        Circle()
                            .fill(colorForState(bridgeState))
                            .frame(width: 8, height: 8)
                            .blur(radius: bridgeState == .connected ? 4 : 0)
                            .opacity(bridgeState == .connected ? 0.6 : 0)
                    )
                
                Text(labelForState(bridgeState))
                    .font(.system(size: 11, weight: .semibold, design: .monospaced))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(Color.black.opacity(0.75))
                    .overlay(
                        Capsule()
                            .stroke(colorForState(bridgeState).opacity(0.5), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // MARK: - Expanded Panel
    
    private var expandedPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(colorForState(bridgeState))
                
                Text("TTDebugBridge")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // Refresh button
                Button(action: refreshSnapshot) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.6))
                }
                .buttonStyle(PlainButtonStyle())
                
                // Close button
                Button(action: {
                    isExpanded = false
                    refreshTimer?.invalidate()
                    refreshTimer = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white.opacity(0.4))
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            
            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(height: 1)
            
            // State
            VStack(alignment: .leading, spacing: 8) {
                diagnosticRow(
                    icon: iconForState(bridgeState),
                    label: "Status",
                    value: bridgeState.rawValue.uppercased(),
                    valueColor: colorForState(bridgeState)
                )
                
                if let s = snapshot {
                    // Duration
                    diagnosticRow(
                        icon: "⏱",
                        label: "Duration",
                        value: String(format: "%.0fs in this state", s.stateDuration)
                    )
                    
                    // Network
                    diagnosticRow(
                        icon: s.wifiConnected ? "📡" : "📡",
                        label: "Wi-Fi",
                        value: s.wifiConnected ? (s.localIP ?? "Connected") : "Not connected",
                        valueColor: s.wifiConnected ? .green : .red
                    )
                    
                    if let prefix = s.networkPrefix {
                        diagnosticRow(icon: "🔍", label: "Subnet", value: prefix)
                    }
                    
                    if s.vpnActive {
                        diagnosticRow(
                            icon: "🛡",
                            label: "VPN",
                            value: "Active ⚠️",
                            valueColor: .orange
                        )
                    }
                    
                    // Bonjour
                    diagnosticRow(
                        icon: "🔎",
                        label: "Services",
                        value: "\(s.browseResultCount) found"
                    )
                    
                    if s.reconnectAttempt > 0 {
                        diagnosticRow(
                            icon: "🔄",
                            label: "Reconnect",
                            value: "Attempt #\(s.reconnectAttempt)"
                        )
                    }
                    
                    // Hints
                    let hints = diagnosticHints(s)
                    if !hints.isEmpty {
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 1)
                            .padding(.vertical, 4)
                        
                        ForEach(Array(hints.enumerated()), id: \.offset) { _, hint in
                            Text(hint)
                                .font(.system(size: 10, weight: .regular))
                                .foregroundColor(.orange)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
                
                // Full report button
                Button(action: {
                    TTDebugBridge.shared.printDiagnosticReport()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "doc.text")
                            .font(.system(size: 10))
                        Text("Print Full Report")
                            .font(.system(size: 10, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .padding(.top, 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .frame(width: 280)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.4), radius: 16, y: 8)
    }
    
    // MARK: - Diagnostic Row
    
    private func diagnosticRow(
        icon: String,
        label: String,
        value: String,
        valueColor: Color = .white.opacity(0.8)
    ) -> some View {
        HStack(spacing: 6) {
            Text(icon)
                .font(.system(size: 12))
                .frame(width: 18, alignment: .center)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
                .frame(width: 60, alignment: .leading)
            
            Text(value)
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .foregroundColor(valueColor)
                .lineLimit(1)
            
            Spacer()
        }
    }
    
    // MARK: - Helpers
    
    private func refreshSnapshot() {
        snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
    }
    
    private func startAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            refreshSnapshot()
        }
    }
    
    private func colorForState(_ state: TTDebugBridge.BridgeState) -> Color {
        switch state {
        case .idle: return .gray
        case .browsing: return .blue
        case .connecting: return .orange
        case .connected: return .green
        case .disconnected: return .red
        }
    }
    
    private func iconForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle: return "⏸"
        case .browsing: return "🔍"
        case .connecting: return "🔄"
        case .connected: return "✅"
        case .disconnected: return "❌"
        }
    }
    
    private func labelForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle: return "IDLE"
        case .browsing: return "SCANNING"
        case .connecting: return "CONNECTING"
        case .connected: return "CONNECTED"
        case .disconnected: return "OFFLINE"
        }
    }
    
    private func diagnosticHints(_ s: ConnectionDiagnostics.Snapshot) -> [String] {
        var hints: [String] = []
        
        if !s.wifiConnected {
            hints.append("💡 Connect to Wi-Fi to enable debug bridge")
        }
        if s.vpnActive {
            hints.append("💡 VPN may block mDNS — try disabling")
        }
        if s.bridgeState == .browsing && s.browseResultCount == 0 && s.stateDuration > 15 {
            hints.append("💡 No macOS found — is TTBDebugPlus running?")
            hints.append("💡 Check both devices on same Wi-Fi")
        }
        
        return hints
    }
}

// MARK: - UIKit Integration — Window Overlay

@available(iOS 14.0, *)
extension TTDebugBridge {
    
    /// Shows a floating diagnostic overlay pill on the app's key window.
    /// Only works in SwiftUI-compatible iOS 14+ apps.
    public func showDiagnosticOverlay() {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first else { return }
            
            let overlayWindow = UIWindow(windowScene: windowScene)
            overlayWindow.windowLevel = .statusBar + 1
            overlayWindow.backgroundColor = .clear
            overlayWindow.isUserInteractionEnabled = true
            
            let hostingController = UIHostingController(rootView:
                DebugBridgeStatusView()
                    .edgesIgnoringSafeArea(.all)
            )
            hostingController.view.backgroundColor = .clear
            overlayWindow.rootViewController = hostingController
            overlayWindow.makeKeyAndVisible()
            
            // Store reference to prevent deallocation
            objc_setAssociatedObject(
                self,
                &AssociatedKeys.overlayWindow,
                overlayWindow,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
        #endif
    }
    
    /// Hides the diagnostic overlay.
    public func hideDiagnosticOverlay() {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            if let window = objc_getAssociatedObject(self, &AssociatedKeys.overlayWindow) as? UIWindow {
                window.isHidden = true
                objc_setAssociatedObject(self, &AssociatedKeys.overlayWindow, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
        #endif
    }
}

private enum AssociatedKeys {
    static var overlayWindow = "TTDebugBridge.overlayWindow"
}

#endif
