//
//  SwiftUIView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 26/11/25.
//

import SwiftUI
import UIKit

// MARK: - TT Blur wrapper (iOS 14 compatible)
struct TTVisualEffectBlur: UIViewRepresentable {
    let style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) { }
}

// MARK: - TT Progress Bar
struct TTProgressBar: View {
    var progress: CGFloat // 0...1
    var height: CGFloat = 6

    var body: some View {
        GeometryReader { g in
            TTBaseSUIZStack(alignment: .leading, bg: .clear) {
                Capsule()
                    .foregroundColor(Color.white.opacity(Double(0.08)))
                    .frame(height: g.size.height)

                Capsule()
                    .foregroundColor(Color.white.opacity(Double(0.18)))
                    .frame(width: max(0, g.size.width * progress), height: g.size.height)
                    .overlay(
                        Capsule()
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.white.opacity(Double(0.12)),
                                                                Color.white.opacity(Double(0.02))]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 0.4
                            )
                    )
            }
        }
        .frame(height: height)
        .clipShape(Capsule())
        .animation(.linear, value: progress)
    }
}

// MARK: - TT New Version Popup
public struct TTBaseNewVersionPopupView: View {
    @Binding var isPresented: Bool
    var autoDismissAfter: TimeInterval = 4.0
    
    
    fileprivate var title:String = "TTBaseUIkit.NewVersion.Title".localize(def: "New update available")
    fileprivate var subTitle:String = "TTBaseUIkit.NewVersion.SubTitle".localize(def: "This update brings enhanced performance and optimized stability. Update now to get the most out of the app.")
    fileprivate var primaryTitle:String = "TTBaseUIkit.NewVersion.Button.Update".localize(def: "Update Now")
    fileprivate var laterTitle:String =  "TTBaseUIkit.NewVersion.Button.Later".localize(def: "Maybe Later")
    
    @State private var appear = false
    @State private var floatToggle = false
    @State private var pulse = false
    @State private var primaryPressed = false
    @State private var progress: CGFloat = 0.0
    @State private var autoDismissTimer: Timer?

    private let corner: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS * 4
    private let cardMaxWidth: CGFloat = TTSize.W - TTSize.getPaddingDef() * 2
    
    @Environment(\.presentationMode) public var presentationMode
    
    public let openAppstoreHandle: () -> Void
    public let laterHandle: () -> Void
    
    public init(subTitle text:String = "TTBaseUIkit.NewVersion.SubTitle".localize(def: "This update brings enhanced performance and optimized stability. Update now to get the most out of the app."),
         isPresented:Binding<Bool>,
         autoDismissAfter:TimeInterval = 4.0,
         openAppstoreHandle: @escaping () -> Void,
         laterHandle: @escaping () -> Void
    ) {
        self.subTitle = text
        self._isPresented = isPresented
        self.autoDismissAfter = autoDismissAfter
        self.openAppstoreHandle = openAppstoreHandle
        self.laterHandle = laterHandle
    }

    public var body: some View {
        TTBaseSUIZStack(alignment: .center, bg: .clear) {
            // Dim background with smoother curve
            Color.black
                .opacity(Double(appear ? 0.18 : 0.0))
                .ignoresSafeArea()
                .animation(.easeOut(duration: 0.35), value: appear)
                .onTapGesture {
                    if TTParam.forceUpdateNewVersion == false {
                        dismiss()
                    }
                }

            card
                .frame(maxWidth: cardMaxWidth)
                .padding(.horizontal, 20) // outer safe padding
                .scaleEffect(appear ? 1 : 0.94)
                .opacity(appear ? 1 : 0)
                .offset(y: appear ? (floatToggle ? -6 : 6) : 20)
                .animation(
                    .spring(response: 0.55, dampingFraction: 0.75, blendDuration: 0)
                        .repeatForever(autoreverses: true)
                        .speed(0.6),
                    value: floatToggle
                )
                .onAppear {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.7)) {
                        appear = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) { floatToggle.toggle() }
                    withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                        pulse.toggle()
                    }
                    if TTParam.forceUpdateNewVersion == false {
                        startAutoDismissTimer(total: self.autoDismissAfter)
                    }
                }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isPresented)
        .ignoresSafeArea()
    }

    private var card: some View {
        TTBaseSUIVStack(alignment: .center, spacing: TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 2) {
            // Top icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.11, green: 0.64, blue: 0.98).opacity(Double(0.18)),
                                Color(red: 0.78, green: 0.44, blue: 0.99).opacity(Double(0.14))
                            ]),
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 130, height: 130)
                    .scaleEffect(pulse ? 1.06 : 0.94)
                    .opacity(pulse ? 0.95 : 0.85)
                    .blur(radius: pulse ? 8 : 6)

                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color(red: 0.11, green: 0.64, blue: 0.98),
                                Color(red: 0.78, green: 0.44, blue: 0.99)
                            ]),
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 92, height: 92)
                    .shadow(color: Color(red: 0.64, green: 0.39, blue: 0.99).opacity(Double(0.28)), radius: 12, x: 0, y: 8)

                Image(systemName: "checkmark")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
                    .offset(y: -2)
            }
            .padding(.top, TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 1.2)

            // Title
            TTBaseSUIText(withBold: .HEADER, text: self.title, align: .center, color: .white)
                .shadow(color: Color.black.opacity(Double(0.15)), radius: 6, x: 0, y: 2)
                .padding(.horizontal, 18)

            // Subtitle
            TTBaseSUIText(withType: .SUB_TITLE,
                          text: self.subTitle,
                          align: .center,
                          color: .white)
                .opacity(Double(0.99))
                .padding(.horizontal, 22)

            // Progress
            if TTParam.forceUpdateNewVersion == false {
                TTProgressBar(progress: progress, height: 8)
                    .padding(.horizontal, 24)
                    .padding(.top, 6)
            }

            // Primary CTA
            Button(action: {
                let g = UIImpactFeedbackGenerator(style: .medium)
                g.impactOccurred()
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    primaryPressed = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    withAnimation(.spring()) {
                        primaryPressed = false
                        if TTParam.forceUpdateNewVersion == false {
                            dismiss()
                        }
                        self.openAppstoreHandle()
                    }
                }
            }) {
                TTBaseSUIText(withBold: .TITLE, text: self.primaryTitle, align: .center, color: .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16) // larger hit area
                    .contentShape(Rectangle())
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        TTView.buttonBgDef.toColor().opacity(0.8),
                        TTView.buttonBgWar.toColor().opacity(0.8)
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(16)
            .padding(.horizontal, 22)
            .scaleEffect(primaryPressed ? 0.97 : 1)
            .shadow(color: Color.blue.opacity(Double(0.26)), radius: 16, x: 0, y: 8)

            // Secondary action
            if TTParam.forceUpdateNewVersion == false {
                Button(action: {
                    let g = UIImpactFeedbackGenerator(style: .light)
                    g.impactOccurred()
                    dismiss()
                    self.laterHandle()
                }) {
                    TTBaseSUIText(withType: .TITLE, text: self.laterTitle, align: .center, color: .white)
                        .opacity(0.92)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 4)
                        .contentShape(Rectangle())
                }
                .padding(.bottom, TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 1.2)
            }
        }
        // Card background: layered glass + tint + inner highlight
        .padding(.vertical, 18) // inner vertical padding for content
        .background(
            ZStack {
                TTVisualEffectBlur(style: .systemThinMaterial)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                TTView.buttonBgDef.toColor().opacity(0.9),
                                TTView.labelBgWar.toColor().opacity(0.2)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))

                // Subtle inner highlight
                RoundedRectangle(cornerRadius: corner, style: .continuous)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.06)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 0.8
                    )
                    .blendMode(.overlay)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .overlay(
            // Premium border
            RoundedRectangle(cornerRadius: corner, style: .continuous)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.white.opacity(Double(0.45)),
                            Color(red: 0.64, green: 0.39, blue: 0.99).opacity(Double(0.42))
                        ]),
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.1
                )
                .blendMode(.overlay)
        )
        .shadow(color: Color.black.opacity(Double(0.28)), radius: 30, x: 0, y: 10)
        .padding(.horizontal, TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 1.75)
    }

    private func dismiss() {
        autoDismissTimer?.invalidate()
        autoDismissTimer = nil
        
        self.presentationMode.wrappedValue.dismiss()
        
        withAnimation(.easeInOut(duration: 0.25)) {
            appear = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.28) {
            isPresented = false
        }
    }

    private func startAutoDismissTimer(total: TimeInterval) {
        progress = 0
        let interval: TimeInterval = 0.05
        var elapsed: TimeInterval = 0
        autoDismissTimer?.invalidate()

        autoDismissTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { t in
            elapsed += interval
            let p = min(1.0, CGFloat(elapsed / total))
            withAnimation(.linear(duration: interval)) {
                progress = p
            }
            if elapsed >= total {
                t.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
                    dismiss()
                    self.openAppstoreHandle()
                }
            }
        }
        RunLoop.current.add(autoDismissTimer!, forMode: .common)
    }
}

// MARK: - Example host view (optional demo)
public struct BaseNewVersionPopupContentView: View {
    @State private var showPopup = false
 
    public init(showPopup: Bool = false) {
        self.showPopup = showPopup
    }
    
    let des:String = """
        let paramsConfig:ParamConfig = ParamConfig()
        paramsConfig.forceUpdateNewVersion = true

        TTBaseUIKitConfig.withDefaultConfig(withFontConfig: fontConfig, frameSize: sizeConfig, view: view, style: styleConfig, params: paramsConfig)?.start(withViewLog: true)
    
    """
    
    public var body: some View {
        TTBaseSUIZStack(alignment: .center, bg: .clear) {
            TTBaseSUIVStack(alignment: .center, spacing: TTBaseUIKitConfig.getSizeConfig().H_BUTTON) {
                Spacer()
                TTBaseSUIText(withBold: .HEADER, text: "Demo App", align: .center, color: .black)
                TTBaseSUIText(withBold: .TITLE, text: "To enable force-update mode,\nset forceUpdateNewVersion to true", align: .center, color: .black)
                
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: "Just call TTBaseCheckNewVersion.shared.onCheck()\nfrom any screen where you want to display the new-version popup", align: .leading, color: .black)
                    .pAll()
                    .bg(byDef: Color.red.opacity(0.2))
                    .corner()
                    .pHorizontal(TTSize.P_CONS_DEF)
        
                
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: des, align: .leading, color: .black)
                    .pAll()
                    .bg(byDef: Color.gray.opacity(0.2))
                    .corner()
                    .pHorizontal(TTSize.P_CONS_DEF)
                
                TTBaseSUIButton(type: .DEFAULT, title: "Show Update Popup") {
                    showPopup = true
                } .pHorizontal(TTSize.P_CONS_DEF)

                .corner(byDef: 16.0)
                .size(width: TTSize.W * 0.8)
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 0.95, green: 0.96, blue: 0.98),
                        Color(red: 0.87, green: 0.90, blue: 0.98)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                ).ignoresSafeArea()
            )

            if showPopup {
                //TTBaseNewVersionPopupView( isPresented: $showPopup, autoDismissAfter: 4.0,
                TTBaseNewVersionPopupView.init(isPresented: $showPopup) {
                    TTBaseFunc.shared.printLog(object: "Click update update button handle")
                } laterHandle: {
                    TTBaseFunc.shared.printLog(object: "Click update later button handle")
                }
                .zIndex(1)
            }
        }.ignoresSafeArea()
    }
}

struct BaseNewVersionPopupContentView_Previews: PreviewProvider {
    static var previews: some View {
        BaseNewVersionPopupContentView()
    }
}
