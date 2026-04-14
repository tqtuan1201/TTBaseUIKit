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
/// Supports drag-to-reposition and pass-through touch so the app remains usable.
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
    @State private var showFullReport: Bool = false
    @State private var fullReportText: String = ""
    @State private var isResetting: Bool = false
    
    /// Drag offset for repositioning — starts at top-right
    @State private var offset: CGSize = .zero
    @State private var lastDragOffset: CGSize = .zero
    @State private var isDragging: Bool = false
    
    public init() {}
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .topTrailing) {
                // Transparent — no Color.clear fill so touches pass through
                
                Group {
                    if isExpanded {
                        expandedPanel
                            .transition(.asymmetric(
                                insertion: .scale(scale: 0.5, anchor: .topTrailing).combined(with: .opacity),
                                removal: .scale(scale: 0.8, anchor: .topTrailing).combined(with: .opacity)
                            ))
                    } else {
                        floatingPill
                            .opacity(isDragging ? 0.8 : 0.4)
                            .scaleEffect(isDragging ? 1.1 : 1.0)
                            .transition(.scale(scale: 0.5).combined(with: .opacity))
                    }
                }
                .offset(x: offset.width, y: offset.height)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let distance = sqrt(
                                value.translation.width * value.translation.width +
                                value.translation.height * value.translation.height
                            )
                            // Once moved >5pt, mark as dragging
                            if distance > 5 {
                                isDragging = true
                            }
                            if isDragging {
                                offset = CGSize(
                                    width: lastDragOffset.width + value.translation.width,
                                    height: lastDragOffset.height + value.translation.height
                                )
                            }
                        }
                        .onEnded { value in
                            if isDragging {
                                // Was a drag — save position
                                lastDragOffset = offset
                            } else {
                                // Was a tap — toggle expand
                                if !isExpanded {
                                    isExpanded = true
                                    refreshSnapshot()
                                    startAutoRefresh()
                                }
                            }
                            isDragging = false
                        }
                )
                .animation(.easeInOut(duration: 0.15), value: isDragging)
                .padding(.trailing, 12)
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .onAppear {
            bridgeState = TTDebugBridge.shared.state
            // Use NotificationCenter to avoid overwriting onStateChange
            NotificationCenter.default.addObserver(
                forName: .ttDebugBridgeStateDidChange,
                object: nil,
                queue: .main
            ) { notification in
                if let newState = notification.userInfo?["state"] as? String,
                   let state = TTDebugBridge.BridgeState(rawValue: newState) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        bridgeState = state
                    }
                    if isExpanded { refreshSnapshot() }
                }
            }
        }
        .onDisappear {
            refreshTimer?.invalidate()
            refreshTimer = nil
            NotificationCenter.default.removeObserver(self, name: .ttDebugBridgeStateDidChange, object: nil)
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
        .sheet(isPresented: $showFullReport) {
            fullReportSheet
        }
    }
    
    // MARK: - Floating Pill
    
    private var floatingPill: some View {
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
        .contentShape(Capsule())
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
                
                // Action buttons row
                Rectangle()
                    .fill(Color.white.opacity(0.06))
                    .frame(height: 1)
                    .padding(.vertical, 4)
                
                HStack(spacing: 12) {
                    // Full report button — opens in-app sheet
                    Button(action: {
                        let snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
                        fullReportText = ConnectionDiagnostics.formatReport(snapshot)
                        // Also print to console
                        TTDebugBridge.shared.printDiagnosticReport()
                        showFullReport = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.text")
                                .font(.system(size: 10))
                            Text("Full Report")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.blue)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // Reset / Reconnect button
                    Button(action: {
                        performReset()
                    }) {
                        HStack(spacing: 4) {
                            if isResetting {
                                ProgressView()
                                    .scaleEffect(0.5)
                                    .frame(width: 10, height: 10)
                            } else {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                    .font(.system(size: 10))
                            }
                            Text("Reset")
                                .font(.system(size: 10, weight: .medium))
                        }
                        .foregroundColor(.orange)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .disabled(isResetting)
                    .opacity(isResetting ? 0.5 : 1.0)
                    
                    Spacer()
                }
                .padding(.top, 2)
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
    
    // MARK: - Full Report Sheet
    
    private var fullReportSheet: some View {
        NavigationView {
            ScrollView {
                Text(fullReportText)
                    .font(.system(size: 12, weight: .regular, design: .monospaced))
                    .foregroundColor(.primary)
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("Diagnostic Report", displayMode: .inline)
            .navigationBarItems(
                leading: Button(action: {
                    // Refresh report
                    let snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
                    fullReportText = ConnectionDiagnostics.formatReport(snapshot)
                }) {
                    Image(systemName: "arrow.clockwise")
                },
                trailing: HStack(spacing: 12) {
                    // Copy to clipboard
                    Button(action: {
                        UIPasteboard.general.string = fullReportText
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    // Close
                    Button("Done") {
                        showFullReport = false
                    }
                }
            )
        }
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
    
    // MARK: - Actions
    
    private func performReset() {
        isResetting = true
        
        // Stop everything, then restart from scratch after a brief delay
        TTDebugBridge.shared.stop()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            TTDebugBridge.shared.start()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isResetting = false
                refreshSnapshot()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func refreshSnapshot() {
        snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
        // Also sync state from bridge
        withAnimation(.easeInOut(duration: 0.2)) {
            bridgeState = TTDebugBridge.shared.state
        }
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

// MARK: - Notification Name for State Changes
public extension Notification.Name {
    /// Posted by TTDebugBridge when its state changes.
    /// `userInfo["state"]` contains the `BridgeState.rawValue` string.
    static let ttDebugBridgeStateDidChange = Notification.Name("TTDebugBridge.stateDidChange")
}

// MARK: - Pass-Through Window for Overlay
/// A UIWindow subclass that only intercepts touches on its visible subviews,
/// allowing touches to pass through to the app's main window underneath.
@available(iOS 14.0, *)
private class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let hitView = super.hitTest(point, with: event) else { return nil }
        // If the hit view is the root hosting view's background (the clear hosting view),
        // return nil so touches pass through to the app window beneath.
        if hitView === self.rootViewController?.view {
            return nil
        }
        return hitView
    }
}

// MARK: - UIKit Integration — Window Overlay

@available(iOS 14.0, *)
extension TTDebugBridge {
    
    /// Shows a floating diagnostic overlay pill on the app's key window.
    /// Uses a pass-through window so the app remains fully interactive.
    /// Only works in SwiftUI-compatible iOS 14+ apps.
    public func showDiagnosticOverlay() {
        #if canImport(UIKit)
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first else { return }
            
            // Don't create duplicate overlays
            if let existing = objc_getAssociatedObject(self, &AssociatedKeys.overlayWindow) as? UIWindow,
               !existing.isHidden {
                return
            }
            
            let overlayWindow = PassThroughWindow(windowScene: windowScene)
            overlayWindow.windowLevel = .statusBar + 1
            overlayWindow.backgroundColor = .clear
            overlayWindow.isUserInteractionEnabled = true
            
            let hostingController = UIHostingController(rootView:
                DebugBridgeStatusView()
                    .edgesIgnoringSafeArea(.all)
            )
            hostingController.view.backgroundColor = .clear
            hostingController.view.isUserInteractionEnabled = true
            overlayWindow.rootViewController = hostingController
            overlayWindow.isHidden = false
            // Do NOT call makeKeyAndVisible — it steals first responder from the app
            
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
