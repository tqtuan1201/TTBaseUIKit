//
//  DebugUIDemoView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - DebugUIDemoView
struct DebugUIDemoView: View {
    
    @State fileprivate var isTouchDebugActive: Bool = false
    
    @State private var isDebugActive = false
    @State private var launchButtonPulse = false
    
    init() {
        LogViewHelper.share.seedFakeLogs()
    }
    
    var body: some View {
        NavigationView {
            TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
                TTBaseSUIVStack(alignment: .leading, spacing: 16, bg: .clear) {
                    
                    // Hero Card
                    heroCard
                    
                    // Features Section
                    sectionHeader(title: "🔍 What You Can Do", subtitle: "Powerful in-app debugging tools")
                    featuresList
                    
                    // How to Use Section
                    sectionHeader(title: "📖 How to Use", subtitle: "Gestures & interactions")
                    howToUseCard
                    
                    // Launch Button
                    launchButton
                    
                    // Code Snippet
                    sectionHeader(title: "💻 Integration Code", subtitle: "Add to your AppDelegate or any ViewController")
                    codeSnippetCard
                    
                    // Footer
                    footerView
                }
                .pAll(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("UI Debug", displayMode: .inline)
            .onAppear {
                UITabBar.showTabBar(animated: true)
                isDebugActive = UserDefaults.standard.bool(forKey: "TTBaseDebugKit.activated")
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
        }
    }
    
    // MARK: - Hero Card
    private var heroCard: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear) {
            // Icon
            Image(systemName: "eye.trianglebadge.exclamationmark")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Color(XView.viewBgNavColor))
                .frame(width: 80, height: 80)
                .background(Color(XView.viewBgNavColor).opacity(0.1))
                .cornerRadius(20)
            
            TTBaseSUIText(withBold: .HEADER, text: "Smart UI Debugging for iOS", align: .center)
            
            Text("A powerful developer tool to inspect, trace, and debug UI components in both UIKit and SwiftUI — directly on-device or in the simulator.")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            // Status Badge
            TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                Circle()
                    .fill(isDebugActive ? Color.green : Color.gray)
                    .frame(width: 8, height: 8)
                Text(isDebugActive ? "Debug Kit Active" : "Debug Kit Inactive")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(isDebugActive ? .green : .secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill((isDebugActive ? Color.green : Color.gray).opacity(0.1))
            )
        }
        .maxWidth()
        .pAll(20)
        .cornerRadius(16)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Features List
    private var featuresList: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
            featureRow(icon: "rectangle.3.group", color: .blue,
                       title: "Layout Inspector",
                       detail: "Triple-tap to visualize constraints, frames, and view hierarchy")
            Divider().padding(.leading, 52)
            
            featureRow(icon: "network", color: .purple,
                       title: "API Response Log Viewer",
                       detail: "Inspect request/response data, headers, and status codes in-app")
            
            Divider().padding(.leading, 52)
            
            featureRow(icon: "camera.viewfinder", color: .orange,
                       title: "Screen Capture",
                       detail: "Annotate screenshots and share with your team")
            Divider().padding(.leading, 52)
            
            featureRow(icon: "gearshape.2", color: .green,
                       title: "Developer Settings Panel",
                       detail: "Toggle environments, feature flags, and debug options")
            Divider().padding(.leading, 52)
            
            featureRow(icon: "hand.tap", color: .red,
                       title: "Gesture Activated",
                       detail: "Long-press any screen to open, triple-tap to inspect layout")
        }
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    @ViewBuilder
    private func featureRow(icon: String, color: Color, title: String, detail: String, action: (() -> Void)? = nil) -> some View {
        let content = TTBaseSUIHStack(alignment: .top, spacing: 12, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.primary)
                Text(detail)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .maxWidth(alignment: .leading)
        }

        if let action {
            Button(action: action) {
                content
                    .pAll(14)
            }
            .buttonStyle(.plain)
        } else {
            content
                .pAll(14)
        }
    }
    
    // MARK: - How to Use
    private var howToUseCard: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
            gestureRow(emoji: "👆", gesture: "Long Press", detail: "Long-touch any screen to show the Dev Mode View")
            Divider().padding(.leading, 40)
            gestureRow(emoji: "👆👆👆", gesture: "Triple Tap", detail: "Tap 3 times to activate UI debugging & layout inspector")
            Divider().padding(.leading, 40)
            gestureRow(emoji: "🔑", gesture: "Passcode", detail: "Set a passcode if you need authentication for debug access")
        }
        .pAll(14)
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private func gestureRow(emoji: String, gesture: String, detail: String) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
            Text(emoji)
                .font(.system(size: 20))
                .frame(width: 32, height: 32)
            
            TTBaseSUIVStack(alignment: .leading, spacing: 1, bg: .clear) {
                Text(gesture)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                Text(detail)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .maxWidth(alignment: .leading)
        }
    }
    
    // MARK: - Launch Button
    private var launchButton: some View {
        Button(action: {
            if self.isTouchDebugActive {
                UIApplication.topViewController()?.showAlert("Activated. Please long-press anywhere to open the debug panel.")
            } else {
                self.startDebugKit()
            }
        }) {
            TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.55), lineWidth: 1.5)
                        .frame(width: 42, height: 42)
                        .scaleEffect(launchButtonPulse ? 1.32 : 0.82)
                        .opacity(launchButtonPulse ? 0 : 0.75)
                    
                    Circle()
                        .fill(Color.white.opacity(0.18))
                        .frame(width: 42, height: 42)
                    
                    Image(systemName: isDebugActive ? "checkmark.circle.fill" : "play.circle.fill")
                        .font(.system(size: 24, weight: .semibold))
                        .scaleEffect(launchButtonPulse ? 1.08 : 0.96)
                }
                
                TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                    Text(isDebugActive ? "TTBaseDebugKit Ready" : "Start TTBaseDebugKit")
                        .font(.system(size: 15, weight: .bold))
                    Text(isDebugActive ? "Tap to review debug actions, logs, capture, and settings" : "Tap to activate, then explore the debug actions")
                        .font(.system(size: 11))
                        .opacity(0.85)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    TTBaseSUIHStack(alignment: .center, spacing: 5, bg: .clear) {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 5, height: 5)
                            .opacity(launchButtonPulse ? 1 : 0.45)
                        Text("Tap to explore actions")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.white.opacity(0.18))
                    .cornerRadius(10)
                }
                .maxWidth(alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .offset(x: launchButtonPulse ? 4 : 0)
            }
            .foregroundColor(.white)
            .pAll(16)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color(XView.viewBgNavColor), Color(XView.viewBgNavColor).opacity(0.75)]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(14)
            .baseShadow(color: Color(XView.viewBgNavColor).opacity(0.3), radius: 8, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.white.opacity(launchButtonPulse ? 0.35 : 0.12), lineWidth: 1)
            )
            .scaleEffect(launchButtonPulse ? 1.01 : 1.0)
            .animation(.easeInOut(duration: 1.05).repeatForever(autoreverses: true), value: launchButtonPulse)
            .onAppear {
                launchButtonPulse = true
            }
        }
    }
    
    // MARK: - Code Snippet
    private var codeSnippetCard: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                Image(systemName: "chevron.left.forwardslash.chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                Text("Swift")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary)
            }
            
            Text(codeSnippet)
                .font(.system(size: 11, design: .monospaced))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
                .pAll(12)
                .maxWidth(alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(10)
        }
        .pAll(14)
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private var codeSnippet: String {
        """
        // Add to AppDelegate or ViewController
        LogViewHelper.share.config(
            withDes: "Debug Panel",
            isStartAppToShow: false,
            passCode: ""
        ).onShow()
        
        // Gestures:
        // • Long-press → Open Dev Mode View
        // • Triple-tap → Activate UI Debugging
        """
    }
    
    // MARK: - Section Header
    private func sectionHeader(title: String, subtitle: String) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: subtitle, align: .leading, color: .secondary)
        }
        .pTop(4)
    }
    
    // MARK: - Footer
    private var footerView: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Built-in with TTBaseUIKit v2.2.1+", align: .center, color: .secondary)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "No additional dependencies required", align: .center, color: .secondary)
        }
        .maxWidth()
        .pVertical(16)
    }
    
    // MARK: - Actions
    
    private func startDebugKit() {
        isDebugActive = true
        UserDefaults.standard.set(true, forKey: "TTBaseDebugKit.activated")
        LogViewHelper.share.config(
            withDes: "TTBaseDebugKit provides developers with powerful in-app tools for inspecting UI, tracking logs, and simulating environments—making debugging faster, easier, and more efficient",
            isStartAppToShow: true,
            passCode: ""
        ).onStartAndPresentVC()
        self.isTouchDebugActive = false
    }
}

// MARK: - Preview
#Preview {
    DebugUIDemoView()
}
