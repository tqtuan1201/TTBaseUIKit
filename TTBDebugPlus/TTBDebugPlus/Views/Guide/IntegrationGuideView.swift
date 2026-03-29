//
//  IntegrationGuideView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  iOS SDK setup guide with numbered steps and copyable code snippets
//

import SwiftUI

struct IntegrationGuideView: View {
    @Environment(ConnectionManager.self) var connectionManager
    @State private var expandedStep: Int? = 1
    @State private var copiedStep: Int? = nil
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                header
                
                // Connection status
                connectionStatusBanner
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                
                // Steps
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(steps) { step in
                        StepView(
                            step: step,
                            isExpanded: expandedStep == step.number,
                            isCopied: copiedStep == step.number,
                            onToggle: {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    expandedStep = expandedStep == step.number ? nil : step.number
                                }
                            },
                            onCopy: { copyCode(step) }
                        )
                    }
                }
                .padding(.horizontal, 32)
                
                // Troubleshooting
                troubleshootingSection
                    .padding(.horizontal, 32)
                    .padding(.top, 32)
                    .padding(.bottom, 40)
            }
        }
        .background(Color.ttBackground)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.ttPrimary.opacity(0.12))
                        .frame(width: 40, height: 40)
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.ttIcon(TTIcon.xxl))
                        .foregroundColor(.ttPrimary)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("iOS SDK Integration")
                        .font(TTFont.displayMedium)
                        .foregroundColor(.ttTextPrimary)
                    Text("Set up your iOS app to send logs to TTBDebugPlus")
                        .font(TTFont.bodyMedium)
                        .foregroundColor(.ttTextSecondary)
                }
            }
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
        .padding(.bottom, 20)
    }
    
    // MARK: - Connection Status
    private var connectionStatusBanner: some View {
        let serverRunning = connectionManager.isServerRunning
        let hasDevices = !connectionManager.connectedDevices.isEmpty
        
        return HStack(spacing: 16) {
            statusItem(
                icon: "antenna.radiowaves.left.and.right",
                title: "Bonjour Server",
                isOk: serverRunning,
                okText: "Running on _ttbdebug._tcp",
                failText: "Not started — go to menu → Server → Start"
            )
            
            Divider().frame(height: 40)
            
            statusItem(
                icon: "iphone.gen3",
                title: "iOS Device",
                isOk: hasDevices,
                okText: "\(connectionManager.connectedDevices.count) device(s) connected",
                failText: "No device found — ensure same Wi-Fi network"
            )
            
            Spacer()
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill((serverRunning && hasDevices) ? Color.ttSuccess.opacity(0.06) : Color.ttWarning.opacity(0.06))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke((serverRunning && hasDevices) ? Color.ttSuccess.opacity(0.2) : Color.ttWarning.opacity(0.2), lineWidth: 1)
                )
        )
    }
    
    private func statusItem(icon: String, title: String, isOk: Bool, okText: String, failText: String) -> some View {
        HStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isOk ? Color.ttSuccess.opacity(0.15) : Color.ttWarning.opacity(0.15))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.ttIcon(TTIcon.xxl))
                    .foregroundColor(isOk ? .ttSuccess : .ttWarning)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(TTFont.labelLarge)
                        .foregroundColor(.ttTextPrimary)
                    Image(systemName: isOk ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                        .font(.ttIcon(TTIcon.lg))
                        .foregroundColor(isOk ? .ttSuccess : .ttWarning)
                }
                Text(isOk ? okText : failText)
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
            }
        }
    }
    
    // MARK: - Steps Data
    private var steps: [IntegrationStep] {
        [
            IntegrationStep(
                number: 1,
                title: "Add TTBaseUIKit to Your Project",
                description: "Add the TTBaseUIKit package which includes the DebugBridge module. You can use Swift Package Manager or copy the files manually.",
                code: """
                // Swift Package Manager — add to Package.swift:
                dependencies: [
                    .package(
                        url: "https://github.com/tqtuan1201/TTBaseUIKit.git",
                        from: "4.2.0"
                    )
                ]
                
                // Or copy these 3 files manually:
                // • TTDebugBridge.swift
                // • DebugProtocol.swift
                // • LogInterceptor.swift
                """,
                language: "swift",
                note: "The DebugBridge files are in TTBaseUIKit/Support/DebugBridge/"
            ),
            IntegrationStep(
                number: 2,
                title: "⚠️ Configure Info.plist (Required)",
                description: "iOS 14+ requires local network access declarations in Info.plist. Missing this step causes a 'NoAuth -65555' error when NWBrowser attempts Bonjour scanning.",
                code: """
                <!-- Add to your iOS app's Info.plist -->
                
                <!-- Required: Describe why local network access is needed -->
                <key>NSLocalNetworkUsageDescription</key>
                <string>Required for connecting to TTBDebugPlus on macOS to stream debug logs.</string>
                
                <!-- Required: Declare Bonjour service type -->
                <key>NSBonjourServices</key>
                <array>
                    <string>_ttbdebug._tcp</string>
                </array>
                """,
                language: "xml",
                note: "⚠️ IMPORTANT: Without these 2 keys, iOS will block NWBrowser with a NoAuth error. After adding them, delete the app from the device and Build & Run again so iOS shows the permission prompt."
            ),
            IntegrationStep(
                number: 3,
                title: "Start the Debug Bridge",
                description: "Initialize the bridge in your AppDelegate or SceneDelegate. Wrap in #if DEBUG so it's excluded from production builds.",
                code: """
                import TTBaseUIKit

                // In AppDelegate.swift
                func application(
                    _ application: UIApplication,
                    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
                ) -> Bool {
                    
                    #if DEBUG
                    TTDebugBridge.shared.start()
                    #endif
                    
                    return true
                }
                """,
                language: "swift",
                note: "The bridge auto-discovers the macOS app via Bonjour — no manual IP config needed!"
            ),
            IntegrationStep(
                number: 4,
                title: "Forward API Logs",
                description: "In your network layer (e.g. Alamofire responseHandler, URLSession completion), call sendAPILog to forward request/response data.",
                code: """
                // In your network response handler:
                TTDebugBridge.shared.sendAPILog(
                    method: request.httpMethod ?? "GET",
                    url: request.url?.absoluteString ?? "",
                    statusCode: response.statusCode,
                    requestHeaders: request.allHTTPHeaderFields ?? [:],
                    requestBody: String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "",
                    responseHeaders: response.allHeaderFields as? [String: String] ?? [:],
                    responseBody: String(data: responseData, encoding: .utf8) ?? "",
                    durationMs: elapsedTime * 1000,
                    sizeBytes: responseData.count
                )
                """,
                language: "swift",
                note: "You can also use LogInterceptor to auto-hook into LogViewHelper patterns."
            ),
            IntegrationStep(
                number: 5,
                title: "Forward Console Logs",
                description: "Send console log entries for viewing in the macOS Console tab. Supports log levels: debug, info, warning, error.",
                code: """
                // Manual log forwarding:
                TTDebugBridge.shared.sendConsoleLog(
                    level: "debug",       // debug | info | warning | error
                    subsystem: "Network", // your module name
                    message: "User profile loaded successfully",
                    sourceFile: #file,
                    sourceLine: #line
                )
                
                // Or use LogInterceptor for automatic forwarding:
                LogInterceptor.shared.startIntercepting()
                """,
                language: "swift",
                note: "LogInterceptor hooks into existing XPrint/LogViewHelper calls automatically."
            ),
            IntegrationStep(
                number: 6,
                title: "Run & Verify Connection",
                description: "Make sure both devices are on the same Wi-Fi network, then run your iOS app. The macOS app should detect it automatically within seconds.",
                code: """
                // Optional: Monitor connection state
                TTDebugBridge.shared.onStateChange = { state in
                    print("[Debug] Bridge state: \\(state.rawValue)")
                    // States: idle → browsing → connecting → connected
                }
                
                // Optional: Custom configuration
                var config = TTDebugBridge.Config()
                config.heartbeatInterval = 3.0  // seconds
                config.maxBufferedMessages = 500
                TTDebugBridge.shared.config = config
                """,
                language: "swift",
                note: "On first run on a physical device, iOS will show an 'Allow local network access' popup — tap Allow."
            ),
        ]
    }
    
    // MARK: - Troubleshooting
    private var troubleshootingSection: some View {
        CardView(title: "TROUBLESHOOTING") {
            VStack(alignment: .leading, spacing: 20) {
                // Error -65555 NoAuth
                troubleItem(
                    errorLog: "[TTDebugBridge] Browser failed: -65555: NoAuth",
                    icon: "exclamationmark.shield.fill",
                    iconColor: .ttError,
                    title: "NoAuth (-65555) — Missing Local Network Permission",
                    explanation: "iOS 14+ requires NSLocalNetworkUsageDescription and NSBonjourServices in Info.plist. Without them, the system blocks NWBrowser immediately with error code -65555.",
                    solution: "1. Open Info.plist → Add NSLocalNetworkUsageDescription (describe reason)\n2. Add NSBonjourServices → array containing \"_ttbdebug._tcp\"\n3. Delete the app from device → Build & Run again\n4. When the popup appears → tap \"Allow\""
                )
                
                Divider().background(Color.ttBorder.opacity(0.2))
                
                // posixError 57
                troubleItem(
                    errorLog: "[TTDebugBridge] Connection failed: posixError(57)",
                    icon: "wifi.exclamationmark",
                    iconColor: .ttWarning,
                    title: "posixError(57) — Socket Connection Failed",
                    explanation: "Error 57 (ENOTCONN) occurs when iOS discovers the macOS service via Bonjour but cannot establish a TCP/WebSocket connection. Causes: different subnet, firewall blocking, or macOS app not listening.",
                    solution: "1. Ensure both devices are on the same Wi-Fi network (same SSID, same subnet)\n2. Disable VPN if active\n3. Check macOS Firewall: System Settings → Network → Firewall → allow TTBDebugPlus\n4. Restart the macOS app and verify the log shows \"Bonjour advertiser ready\""
                )
                
                Divider().background(Color.ttBorder.opacity(0.2))
                
                // No device found
                troubleItem(
                    errorLog: "macOS: \"Waiting for iOS devices...\" — No device found",
                    icon: "iphone.slash",
                    iconColor: .ttWarning,
                    title: "iOS app not appearing in macOS sidebar",
                    explanation: "macOS is advertising _ttbdebug._tcp but iOS cannot find it. Common causes: different Wi-Fi networks, iOS hasn't called start(), or Local Network permission was previously denied.",
                    solution: "1. Verify both devices are on the same Wi-Fi network\n2. Confirm TTDebugBridge.shared.start() has been called\n3. If permission was denied: Settings → Privacy → Local Network → re-enable for your app\n4. Try restarting both the iOS app and macOS app"
                )
                
                Divider().background(Color.ttBorder.opacity(0.2))
                
                // Connection drops
                troubleItem(
                    errorLog: "[TTDebugBridge] ❌ Connection failed / ⏳ Reconnecting...",
                    icon: "arrow.triangle.2.circlepath",
                    iconColor: .ttPrimary,
                    title: "Connection keeps dropping",
                    explanation: "The bridge auto-reconnects with exponential backoff (2s → 4s → 8s → 16s → 30s max). If it keeps reconnecting, the network is unstable or the macOS app was closed.",
                    solution: "1. Check that the network connection is stable\n2. Reduce heartbeatInterval in Config (default is 5s)\n3. Ensure the macOS app is open and the server is running\n4. Check macOS logs to confirm \"Bonjour advertiser ready\""
                )
                
                Divider().background(Color.ttBorder.opacity(0.2))
                
                // Logs stop
                troubleItem(
                    errorLog: "Logs stop appearing after a while",
                    icon: "moon.fill",
                    iconColor: .ttTextTertiary,
                    title: "App entered background — Bridge paused",
                    explanation: "When the iOS app enters background, the system suspends network connections. The bridge will automatically resume when the app returns to foreground.",
                    solution: "1. Bring the iOS app to the foreground to resume\n2. Screenshot capture only works when the app is in the foreground\n3. Messages are buffered (max 200) and flushed on reconnect"
                )
                
                Divider().background(Color.ttBorder.opacity(0.2))
                
                // Production safety
                troubleItem(
                    errorLog: "How to exclude from production builds?",
                    icon: "lock.shield.fill",
                    iconColor: .ttSuccess,
                    title: "Ensure it doesn't ship in release builds",
                    explanation: "The bridge is a no-op when start() hasn't been called, but best practice is to wrap everything in #if DEBUG so the compiler completely strips it from the binary.",
                    solution: "Wrap all TTDebugBridge calls in:\n#if DEBUG\n    TTDebugBridge.shared.start()\n#endif\n\nVerify by: Build for Release → Search for TTDebugBridge in binary → should not exist."
                )
            }
        }
    }
    
    private func troubleItem(errorLog: String, icon: String, iconColor: Color, title: String, explanation: String, solution: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            // Error log preview
            HStack(spacing: 6) {
                Image(systemName: "terminal.fill")
                    .font(.ttIcon(TTIcon.sm))
                    .foregroundColor(.ttTextTertiary)
                Text(errorLog)
                    .font(TTFont.codeMedium)
                    .foregroundColor(.ttError.opacity(0.9))
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.ttError.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.ttError.opacity(0.12), lineWidth: 1)
                    )
            )
            
            // Title
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.ttIcon(TTIcon.xl))
                    .foregroundColor(iconColor)
                Text(title)
                    .font(TTFont.labelLarge)
                    .foregroundColor(.ttTextPrimary)
            }
            
            // Explanation
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.ttIcon(TTIcon.md))
                    .foregroundColor(.ttPrimary)
                    .padding(.top, 2)
                Text(explanation)
                    .font(TTFont.bodySmall)
                    .foregroundColor(.ttTextSecondary)
            }
            .padding(.leading, 4)
            
            // Solution
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.ttIcon(TTIcon.md))
                    .foregroundColor(.ttSuccess)
                    .padding(.top, 2)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Solution:")
                        .font(TTFont.labelSmall)
                        .foregroundColor(.ttSuccess)
                    Text(solution)
                        .font(TTFont.bodySmall)
                        .foregroundColor(.ttTextTertiary)
                }
            }
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ttSuccess.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.ttSuccess.opacity(0.12), lineWidth: 1)
                    )
            )
            .padding(.leading, 4)
        }
    }
    
    // MARK: - Copy Code
    private func copyCode(_ step: IntegrationStep) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(step.code, forType: .string)
        copiedStep = step.number
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if copiedStep == step.number { copiedStep = nil }
        }
    }
}

// MARK: - Step View
struct StepView: View {
    let step: IntegrationStep
    let isExpanded: Bool
    let isCopied: Bool
    var onToggle: () -> Void
    var onCopy: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Step header
            Button(action: onToggle) {
                HStack(spacing: 14) {
                    // Step number + connector line
                    VStack(spacing: 0) {
                        ZStack {
                            Circle()
                                .fill(isExpanded ? Color.ttPrimary : Color.ttSurface)
                                .frame(width: 32, height: 32)
                                .overlay(
                                    Circle()
                                        .stroke(isExpanded ? Color.clear : Color.ttBorder, lineWidth: 1)
                                )
                            Text("\(step.number)")
                                .font(TTFont.codeLarge)
                                .foregroundColor(isExpanded ? .white : .ttTextSecondary)
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(step.title)
                            .font(TTFont.heading3)
                            .foregroundColor(.ttTextPrimary)
                        Text(step.description)
                            .font(TTFont.bodySmall)
                            .foregroundColor(.ttTextTertiary)
                            .lineLimit(isExpanded ? nil : 1)
                    }
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.ttIcon(TTIcon.lg))
                        .foregroundColor(.ttTextTertiary)
                }
            }
            .buttonStyle(.plain)
            .padding(.vertical, 14)
            
            // Expanded content
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    // Code block
                    VStack(alignment: .leading, spacing: 0) {
                        // Code header
                        HStack {
                            HStack(spacing: 6) {
                                Circle().fill(Color.ttError.opacity(0.8)).frame(width: 8, height: 8)
                                Circle().fill(Color.ttWarning.opacity(0.8)).frame(width: 8, height: 8)
                                Circle().fill(Color.ttSuccess.opacity(0.8)).frame(width: 8, height: 8)
                            }
                            
                            Spacer()
                            
                            Text(step.language.uppercased())
                                .font(TTFont.badge)
                                .foregroundColor(.ttTextTertiary)
                            
                            Button(action: onCopy) {
                                HStack(spacing: 4) {
                                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                                        .font(.ttIcon(TTIcon.md))
                                    Text(isCopied ? "Copied!" : "Copy")
                                        .font(TTFont.labelSmall)
                                }
                                .foregroundColor(isCopied ? .ttSuccess : .ttTextSecondary)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(Color(nsColor: NSColor(red: 0.12, green: 0.13, blue: 0.16, alpha: 1.0)))
                        
                        // Code content
                        ScrollView(.horizontal, showsIndicators: false) {
                            Text(step.code)
                                .font(TTFont.codeMedium)
                                .foregroundColor(.ttTextPrimary)
                                .textSelection(.enabled)
                                .padding(14)
                        }
                        .background(Color(nsColor: NSColor(red: 0.09, green: 0.10, blue: 0.13, alpha: 1.0)))
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.ttBorder.opacity(0.3), lineWidth: 1)
                    )
                    
                    // Note callout
                    if let note = step.note {
                        HStack(spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .font(.ttIcon(TTIcon.lg))
                                .foregroundColor(.ttWarning)
                            Text(note)
                                .font(TTFont.bodySmall)
                                .foregroundColor(.ttTextSecondary)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.ttWarning.opacity(0.06))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.ttWarning.opacity(0.15), lineWidth: 1)
                                )
                        )
                    }
                }
                .padding(.leading, 46) // Align with step title
                .padding(.bottom, 14)
            }
            
            // Divider
            if step.number < 6 {
                Divider()
                    .background(Color.ttBorder.opacity(0.3))
                    .padding(.leading, 46)
            }
        }
    }
}

// MARK: - Model
struct IntegrationStep: Identifiable {
    let number: Int
    let title: String
    let description: String
    let code: String
    let language: String
    let note: String?
    
    var id: Int { number }
}

#Preview {
    IntegrationGuideView()
        .environment(ConnectionManager())
        .frame(width: 800, height: 900)
        .preferredColorScheme(.dark)
}
