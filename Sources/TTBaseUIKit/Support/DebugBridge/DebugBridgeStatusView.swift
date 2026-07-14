//
//  DebugBridgeStatusView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 2026-03-30.
//  Full-screen diagnostic panel for TTDebugBridge connection status
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Debug Bridge Status View (iOS 14+)
/// A full-screen diagnostics panel for TTDebugBridge connection status.
/// Accessible via "Debug Bridge" menu item in TTBaseDebugKit.
///
/// Usage:
/// ```swift
/// #if DEBUG
/// TTDebugBridge.shared.start()
/// // Access via TTBaseDebugKit menu → Debug Bridge
/// #endif
/// ```
@available(iOS 14.0, *)
public struct DebugBridgeStatusView: View {
    
    @State private var bridgeState: TTDebugBridge.BridgeState = .idle
    @State private var snapshot: ConnectionDiagnostics.Snapshot?
    @State private var refreshTimer: Timer?
    @State private var showFullReport: Bool = false
    @State private var fullReportText: String = ""
    @State private var isResetting: Bool = false
    @State private var pulseAnimation: Bool = false
    @State private var showEventLog: Bool = false
    @State private var stateChangeObserverToken: NSObjectProtocol?
    @State private var showManualConnect: Bool = false
    @State private var showQRScanner: Bool = false
    @State private var manualHost: String = ""
    @State private var manualPort: String = ""
    @State private var hasEverConnected: Bool = true
    @State private var infoPlistConfigured: Bool = true
    @State private var qrFeedback: String? = nil

    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if let qrFeedback {
                    qrFeedbackBanner(qrFeedback)
                }

                // Hero connection status card
                connectionStatusCard

                if bridgeState == .permissionDenied {
                    permissionDeniedBanner
                } else if !hasEverConnected {
                    firstRunChecklistSection
                }

                // Network info section
                if let s = snapshot {
                    networkInfoSection(s)
                    
                    // Bonjour discovery section
                    discoverySection(s)
                    
                    // Diagnostic hints
                    let hints = diagnosticHints(s)
                    if !hints.isEmpty {
                        hintsSection(hints)
                    }
                    
                    // Event log (collapsible)
                    if !s.recentEvents.isEmpty {
                        eventLogSection(s.recentEvents)
                    }
                }
                
                // Action buttons
                actionButtonsSection
                
                // SDK info footer
                sdkInfoFooter
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .onAppear {
            bridgeState = TTDebugBridge.shared.state
            refreshSnapshot()
            startAutoRefresh()
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                pulseAnimation = true
            }
            // Block-based observers are keyed by the token they return, NOT by `self`
            // (removeObserver(self, ...) below was a no-op for this registration —
            // every appearance of this view leaked a stacked observer). Guard against
            // double-registration too, in case onAppear fires again before onDisappear.
            if let existing = stateChangeObserverToken {
                NotificationCenter.default.removeObserver(existing)
            }
            stateChangeObserverToken = NotificationCenter.default.addObserver(
                forName: .ttDebugBridgeStateDidChange,
                object: nil,
                queue: .main
            ) { notification in
                if let newState = notification.userInfo?["state"] as? String,
                   let state = TTDebugBridge.BridgeState(rawValue: newState) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        bridgeState = state
                    }
                    refreshSnapshot()
                }
            }
        }
        .onDisappear {
            refreshTimer?.invalidate()
            refreshTimer = nil
            if let token = stateChangeObserverToken {
                NotificationCenter.default.removeObserver(token)
                stateChangeObserverToken = nil
            }
        }
        .sheet(isPresented: $showFullReport) {
            fullReportSheet
        }
        .sheet(isPresented: $showManualConnect) {
            manualConnectSheet
        }
        .fullScreenCover(isPresented: $showQRScanner) {
            QRScannerView { code in
                handleScannedCode(code)
            }
        }
    }
    
    // MARK: - Connection Status Card
    
    private var connectionStatusCard: some View {
        VStack(spacing: 16) {
            // Animated status icon
            ZStack {
                // Outer pulse ring
                Circle()
                    .stroke(colorForState(bridgeState).opacity(0.2), lineWidth: 3)
                    .frame(width: 80, height: 80)
                    .scaleEffect(pulseAnimation && bridgeState != .connected ? 1.2 : 1.0)
                    .opacity(pulseAnimation && bridgeState != .connected ? 0.0 : 0.3)
                
                // Inner circle
                Circle()
                    .fill(colorForState(bridgeState).opacity(0.15))
                    .frame(width: 72, height: 72)
                
                Image(systemName: sfSymbolForState(bridgeState))
                    .font(.system(size: 30, weight: .medium))
                    .foregroundColor(colorForState(bridgeState))
            }
            .padding(.top, 8)
            
            // Status text
            VStack(spacing: 4) {
                Text(labelForState(bridgeState))
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                
                Text(descriptionForState(bridgeState))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            
            // Duration badge
            if let s = snapshot, s.stateDuration > 1 {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 10))
                    Text(formatDuration(s.stateDuration))
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                }
                .foregroundColor(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color(.tertiarySystemGroupedBackground))
                )
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
    
    // MARK: - QR Feedback Banner

    /// Confirms a relay-config QR (Phase 8) was recognized and persisted — scanning a QR that
    /// silently changes future-launch behavior with no visible confirmation would be confusing.
    private func qrFeedbackBanner(_ message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
            Text(message)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.primary)
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.green.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.green.opacity(0.2), lineWidth: 1)
        )
        .transition(.opacity)
    }

    // MARK: - Permission Denied Banner

    private var permissionDeniedBanner: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
                Text("Local Network Access Denied")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
            }
            Text("iOS is blocking TTDebugBridge from finding TTBDebugPlus on your Mac. Grant \"Local Network\" access in Settings, then come back and tap Reset Connection.")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Button(action: openSystemSettings) {
                HStack {
                    Image(systemName: "gear")
                        .font(.system(size: 14, weight: .medium))
                    Text("Open Settings")
                        .font(.system(size: 14, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.red)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.tertiarySystemGroupedBackground))
                )
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.red.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.red.opacity(0.25), lineWidth: 1)
        )
    }

    private func openSystemSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    // MARK: - First-Run Checklist

    /// Shown instead of the usual diagnostics until this app has connected to TTBDebugPlus at
    /// least once (`TTDebugBridge.hasEverConnected`, persisted across launches) — a blank
    /// status card gives a first-time integrator nothing to act on, while this names the exact
    /// step they're stuck on.
    private var firstRunChecklistSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("GETTING STARTED")

            VStack(spacing: 0) {
                infoRow(
                    icon: infoPlistConfigured ? "checkmark.circle.fill" : "xmark.circle.fill",
                    iconColor: infoPlistConfigured ? .green : .red,
                    title: "Info.plist configured",
                    value: infoPlistConfigured ? "OK" : "Missing keys",
                    valueColor: infoPlistConfigured ? .green : .red
                )

                Divider().padding(.leading, 44)

                infoRow(
                    icon: (bridgeState == .browsing || bridgeState == .connecting)
                        ? "antenna.radiowaves.left.and.right" : "clock",
                    iconColor: (bridgeState == .browsing || bridgeState == .connecting) ? .blue : .secondary,
                    title: "Searching for your Mac",
                    value: (bridgeState == .browsing || bridgeState == .connecting) ? "In progress" : "Waiting",
                    valueColor: (bridgeState == .browsing || bridgeState == .connecting) ? .blue : .secondary
                )

                Divider().padding(.leading, 44)

                infoRow(
                    icon: "circle",
                    iconColor: .secondary,
                    title: "Connected",
                    value: "Not yet",
                    valueColor: .secondary
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )

            if !infoPlistConfigured {
                Text("Missing Info.plist keys — see the Xcode console for exactly what to add, or the Integration Guide.")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .padding(.top, 6)
            }
        }
    }

    // MARK: - Network Info Section
    
    private func networkInfoSection(_ s: ConnectionDiagnostics.Snapshot) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("NETWORK")
            
            VStack(spacing: 0) {
                infoRow(
                    icon: "wifi",
                    iconColor: s.wifiConnected ? .green : .red,
                    title: "Wi-Fi",
                    value: s.wifiConnected ? "Connected" : "Not Connected",
                    valueColor: s.wifiConnected ? .primary : .red
                )
                
                if let ip = s.localIP {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "network",
                        iconColor: .blue,
                        title: "Local IP",
                        value: ip
                    )
                }
                
                if let prefix = s.networkPrefix {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "square.grid.3x3.topleft.filled",
                        iconColor: .blue,
                        title: "Subnet",
                        value: prefix
                    )
                }
                
                if s.vpnActive {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "shield.lefthalf.filled",
                        iconColor: .orange,
                        title: "VPN",
                        value: "Active ⚠️",
                        valueColor: .orange
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
    }
    
    // MARK: - Discovery Section
    
    private func discoverySection(_ s: ConnectionDiagnostics.Snapshot) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // "DISCOVERY", not "BONJOUR DISCOVERY" — this card now also reports the configured
            // Relay channel (Phase 9), so a Bonjour-only title would be inaccurate.
            sectionHeader("DISCOVERY")

            VStack(spacing: 0) {
                infoRow(
                    icon: "antenna.radiowaves.left.and.right",
                    iconColor: .blue,
                    title: "Bonjour Services Found",
                    value: "\(s.browseResultCount)"
                )

                if let endpoint = s.lastFoundEndpoint {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "mappin.and.ellipse",
                        iconColor: .blue,
                        title: "Endpoint",
                        value: endpoint
                    )
                }

                // Relay channel (Phase 9) — same icon convention as macOS's ChannelChip
                // (`globe` = relay), so the two apps use the same visual vocabulary.
                if let host = s.configuredRelayHost, let port = s.configuredRelayPort {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "globe",
                        iconColor: .purple,
                        title: "Relay Configured",
                        value: "\(host):\(port)"
                    )
                }

                if s.reconnectAttempt > 0 {
                    Divider().padding(.leading, 44)
                    infoRow(
                        icon: "arrow.triangle.2.circlepath",
                        iconColor: .orange,
                        title: "Reconnect",
                        value: "Attempt #\(s.reconnectAttempt)",
                        valueColor: .orange
                    )
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.secondarySystemGroupedBackground))
            )
        }
    }
    
    // MARK: - Hints Section
    
    private func hintsSection(_ hints: [String]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("DIAGNOSTICS")
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(hints.enumerated()), id: \.offset) { _, hint in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "lightbulb.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.orange)
                            .padding(.top, 2)
                        
                        Text(hint)
                            .font(.system(size: 13))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.orange.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    // MARK: - Event Log Section
    
    private func eventLogSection(_ events: [ConnectionDiagnostics.DiagnosticEvent]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Tappable header to expand/collapse
            Button(action: {
                withAnimation(.easeInOut(duration: 0.25)) {
                    showEventLog.toggle()
                }
            }) {
                HStack {
                    Text("EVENT LOG")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("\(events.count)")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundColor(.secondary)
                        
                        Image(systemName: showEventLog ? "chevron.up" : "chevron.down")
                            .font(.system(size: 10, weight: .semibold))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 4)
                .padding(.bottom, 6)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showEventLog {
                VStack(spacing: 0) {
                    ForEach(Array(events.reversed().enumerated()), id: \.offset) { index, event in
                        if index > 0 {
                            Divider().padding(.leading, 44)
                        }
                        
                        HStack(spacing: 10) {
                            // Timestamp
                            Text(event.formattedTime)
                                .font(.system(size: 10, weight: .medium, design: .monospaced))
                                .foregroundColor(.secondary)
                                .frame(width: 70, alignment: .leading)
                            
                            // State badge
                            Text(event.state.uppercased())
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(
                                    Capsule()
                                        .fill(colorForStateName(event.state))
                                )
                            
                            // Detail
                            if !event.detail.isEmpty {
                                Text(event.detail)
                                    .font(.system(size: 10))
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                            }
                            
                            Spacer()
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private var actionButtonsSection: some View {
        VStack(spacing: 10) {
            // Full Report button
            Button(action: {
                let snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
                fullReportText = ConnectionDiagnostics.formatReport(snapshot)
                TTDebugBridge.shared.printDiagnosticReport()
                showFullReport = true
            }) {
                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 16, weight: .medium))
                    Text("View Full Report")
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .foregroundColor(.blue)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Reset / Reconnect button
            Button(action: { performReset() }) {
                HStack {
                    if isResetting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .frame(width: 16, height: 16)
                    } else {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 16, weight: .medium))
                    }
                    Text(isResetting ? "Reconnecting..." : "Reset Connection")
                        .font(.system(size: 15, weight: .semibold))
                    Spacer()
                }
                .foregroundColor(.orange)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.secondarySystemGroupedBackground))
                )
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(isResetting)
            .opacity(isResetting ? 0.6 : 1.0)

            // Manual connect / QR scan — fallback when Bonjour/mDNS is blocked
            // (corporate networks, some VPNs) or discovery is just slow.
            HStack(spacing: 10) {
                Button(action: { showManualConnect = true }) {
                    HStack {
                        Image(systemName: "network")
                            .font(.system(size: 14, weight: .medium))
                        Text("Enter IP")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: { showQRScanner = true }) {
                    HStack {
                        Image(systemName: "qrcode.viewfinder")
                            .font(.system(size: 14, weight: .medium))
                        Text("Scan QR")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }

    // MARK: - Manual Connect Sheet

    private var manualConnectSheet: some View {
        NavigationView {
            Form {
                Section {
                    TextField("IP Address (e.g. 192.168.1.10)", text: $manualHost)
                        .keyboardType(.numbersAndPunctuation)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                    TextField("Port (e.g. 50689)", text: $manualPort)
                        .keyboardType(.numberPad)
                } header: {
                    Text("Connect Manually")
                } footer: {
                    Text("Use this when auto-discovery doesn't find TTBDebugPlus (corporate network, VPN blocking mDNS). Find the IP and port in TTBDebugPlus → Connection Health.")
                }
            }
            .navigationBarTitle("Connect Manually", displayMode: .inline)
            .navigationBarItems(
                leading: Button("Cancel") { showManualConnect = false },
                trailing: Button("Connect") { connectManually() }
                    .disabled(
                        manualHost.trimmingCharacters(in: .whitespaces).isEmpty
                        || UInt16(manualPort.trimmingCharacters(in: .whitespaces)) == nil
                    )
            )
        }
    }

    private func connectManually() {
        let host = manualHost.trimmingCharacters(in: .whitespaces)
        guard !host.isEmpty, let port = UInt16(manualPort.trimmingCharacters(in: .whitespaces)) else { return }
        TTDebugBridge.shared.connectManually(host: host, port: port)
        showManualConnect = false
    }

    private func handleScannedCode(_ code: String) {
        // Try the relay-config QR format first (Phase 8) — distinct from, and checked before,
        // the plain LAN-pairing QR below so both formats keep working independently.
        if let info = TTDebugBridge.parseRelayPairingQR(code) {
            TTDebugBridge.shared.applyRelayConfig(info)
            showQRFeedback("Relay configured: \(info.host):\(info.port) — saved for future launches")
            return
        }
        guard !TTDebugBridge.shared.connectManually(pairingString: code) else { return }
        // Not a `ttbdebug://` URL — fall back to a bare "host:port" string.
        let parts = code.split(separator: ":")
        guard parts.count == 2, let port = UInt16(parts[1]) else { return }
        TTDebugBridge.shared.connectManually(host: String(parts[0]), port: port)
    }

    private func showQRFeedback(_ message: String) {
        withAnimation(.easeInOut(duration: 0.2)) { qrFeedback = message }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            withAnimation(.easeInOut(duration: 0.2)) {
                if qrFeedback == message { qrFeedback = nil }
            }
        }
    }

    // MARK: - SDK Info Footer
    
    private var sdkInfoFooter: some View {
        VStack(spacing: 4) {
            if let s = snapshot {
                Text("TTDebugBridge SDK v\(s.sdkVersion)")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
                
                Text(s.isEnabled ? "Bridge Enabled" : "Bridge Disabled")
                    .font(.system(size: 10))
                    .foregroundColor(s.isEnabled ? .green : .red)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }
    
    // MARK: - Reusable Components
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(.secondary)
            .padding(.horizontal, 4)
            .padding(.bottom, 6)
    }
    
    private func infoRow(
        icon: String,
        iconColor: Color,
        title: String,
        value: String,
        valueColor: Color = .primary
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(iconColor.opacity(0.12))
                    .frame(width: 30, height: 30)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(iconColor)
            }
            
            Text(title)
                .font(.system(size: 15))
                .foregroundColor(.primary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundColor(valueColor)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
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
                    let snapshot = TTDebugBridge.shared.getDiagnosticSnapshot()
                    fullReportText = ConnectionDiagnostics.formatReport(snapshot)
                }) {
                    Image(systemName: "arrow.clockwise")
                },
                trailing: HStack(spacing: 12) {
                    Button(action: {
                        UIPasteboard.general.string = fullReportText
                    }) {
                        Image(systemName: "doc.on.doc")
                    }
                    Button("Done") {
                        showFullReport = false
                    }
                }
            )
        }
    }
    
    // MARK: - Actions
    
    private func performReset() {
        isResetting = true
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
        hasEverConnected = TTDebugBridge.shared.hasEverConnected
        infoPlistConfigured = TTDebugBridge.shared.checkInfoPlistConfiguration().isEmpty
        withAnimation(.easeInOut(duration: 0.2)) {
            bridgeState = TTDebugBridge.shared.state
        }
    }
    
    private func startAutoRefresh() {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            refreshSnapshot()
        }
    }
    
    private func formatDuration(_ seconds: TimeInterval) -> String {
        if seconds < 60 {
            return String(format: "%.0fs", seconds)
        } else if seconds < 3600 {
            let mins = Int(seconds) / 60
            let secs = Int(seconds) % 60
            return "\(mins)m \(secs)s"
        } else {
            let hrs = Int(seconds) / 3600
            let mins = (Int(seconds) % 3600) / 60
            return "\(hrs)h \(mins)m"
        }
    }
    
    private func colorForState(_ state: TTDebugBridge.BridgeState) -> Color {
        switch state {
        case .idle: return .gray
        case .browsing: return .blue
        case .connecting: return .orange
        case .connected: return .green
        case .disconnected: return .red
        case .permissionDenied: return .red
        }
    }

    private func colorForStateName(_ name: String) -> Color {
        switch name.lowercased() {
        case "idle": return .gray
        case "browsing": return .blue
        case "connecting": return .orange
        case "connected": return .green
        case "disconnected": return .red
        default: return .secondary
        }
    }
    
    private func sfSymbolForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle: return "pause.circle"
        case .browsing: return "antenna.radiowaves.left.and.right"
        case .connecting: return "arrow.triangle.2.circlepath"
        case .connected: return "checkmark.circle.fill"
        case .disconnected: return "xmark.circle"
        case .permissionDenied: return "lock.shield"
        }
    }

    private func labelForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle: return "Idle"
        case .browsing: return "Scanning..."
        case .connecting: return "Connecting..."
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .permissionDenied: return "Permission Denied"
        }
    }

    private func descriptionForState(_ state: TTDebugBridge.BridgeState) -> String {
        switch state {
        case .idle:
            return "Debug Bridge is not active.\nCall TTDebugBridge.shared.start() to begin."
        case .browsing:
            return "Looking for TTBDebugPlus on your Mac...\nMake sure both devices are on the same Wi-Fi."
        case .connecting:
            return "Establishing connection to macOS service..."
        case .connected:
            return "Successfully connected to TTBDebugPlus.\nLogs are being streamed in real-time."
        case .disconnected:
            return "Connection lost. Auto-reconnecting..."
        case .permissionDenied:
            return "Local Network access is denied.\nGrant permission in Settings to connect."
        }
    }
    
    private func diagnosticHints(_ s: ConnectionDiagnostics.Snapshot) -> [String] {
        var hints: [String] = []
        
        if !s.wifiConnected {
            hints.append("Connect to Wi-Fi to enable debug bridge")
        }
        if s.vpnActive {
            hints.append("VPN may block mDNS discovery — try disabling it")
        }
        if s.bridgeState == .browsing && s.browseResultCount == 0 && s.stateDuration > 15 {
            hints.append("No macOS service found — is TTBDebugPlus running?")
            hints.append("Check that both devices are on the same Wi-Fi network")
        }
        if s.bridgeState == .connecting && s.stateDuration > 10 {
            hints.append("Connection is taking longer than expected")
            hints.append("Check Mac firewall settings")
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

// MARK: - UIKit ViewController for Debug Bridge

/// A UIKit view controller that hosts the `DebugBridgeStatusView` SwiftUI view.
/// Presented from TTBaseDebugKit menu → "Debug Bridge".
@available(iOS 14.0, *)
public class DebugBridgeViewController: UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Debug Bridge"
        view.backgroundColor = .systemGroupedBackground
        
        // Nav bar appearance
        if #available(iOS 15.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemGroupedBackground
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }

        let hostingController = UIHostingController(rootView: DebugBridgeStatusView())
        hostingController.view.backgroundColor = .clear
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        hostingController.didMove(toParent: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(dismissSelf)
        )
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

#endif
