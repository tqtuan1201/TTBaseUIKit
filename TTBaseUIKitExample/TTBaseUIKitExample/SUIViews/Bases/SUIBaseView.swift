//
//  SUIBaseView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 18/5/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct NavigationBarBackgroundModifier: ViewModifier {
    let color: Color

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .toolbarBackground(color, for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } else {
            content
                .onAppear {
                    let appearance = UINavigationBarAppearance()
                    appearance.configureWithOpaqueBackground()
                    appearance.backgroundColor = UIColor(color)

                    appearance.titleTextAttributes = [
                        .foregroundColor: UIColor.white
                    ]
                    appearance.largeTitleTextAttributes = [
                        .foregroundColor: UIColor.white
                    ]

                    UINavigationBar.appearance().standardAppearance = appearance
                    UINavigationBar.appearance().scrollEdgeAppearance = appearance
                }
        }
    }
}

extension View {
    func navigationBarBackground(_ color: Color) -> some View {
        self.modifier(NavigationBarBackgroundModifier(color: color))
    }
}

public struct SUIBaseView<Content: View>: View {
    
    public enum BACK_TYPE {
        case POP
        case POP_TO_ROOT
        case DISMISS
        case DISMISS_ALL
        case CLOSE_FLOW
        case SWIFTUI
    }
    
    public enum TYPE {
        case DEFAULT
        case INFO
        case NO_NAV
    }
    
    @Environment(\.presentationMode) public var presentationMode
    @EnvironmentObject var hostingProvider: ViewControllerProvider
    
    public var viewDefBgColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor)
    public var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    public let content: (() -> Content)
    
    private var type:TYPE = .INFO
    private var backType:BACK_TYPE = .POP
    
    private var title:String = "Title SUIBaseView"
    private var isHiddenTabbar:Bool = true
    private var backAction:(() -> Void)? = nil
    private var titleAction:(() -> Void)? = nil
    private var rightAction:(() -> Void)? = nil
    
    
    public init(withCornerRadius radio:CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.viewDefCornerRadius = radio
        self.content = content
    }
    
    public init(withCornerRadius radio:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, bg:Color = Color(TTBaseUIKitConfig.getViewConfig().viewDefColor),
                
                backType:BACK_TYPE = .POP,
                title:String = "SUIBaseView",
                
                type:SUIBaseView.TYPE = .DEFAULT,
                isHiddenTabbar:Bool = true,
                
                backAction:(() -> Void)? = nil,
                titleAction:(() -> Void)? = nil,
                rightAction:(() -> Void)? = nil,
                
                @ViewBuilder content: @escaping () -> Content) {
        
        self.viewDefCornerRadius = radio
        self.viewDefBgColor = bg
        
        self.type = type
        self.backType = backType
        
        self.title = title
        self.isHiddenTabbar = isHiddenTabbar
        
        self.backAction = backAction
        self.titleAction = titleAction
        self.rightAction = rightAction
        
        self.content = content
    }
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    public var body: some View {
        let iconHeight:CGFloat = 25.0
        let removeLeftRightPadding:CGFloat = 0.0
        NavigationView {
            if self.type == .DEFAULT {
                self.content()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarBackground(XView.buttonBgDef.toColor())
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                TTBaseSUIText.init(withBold: .TITLE, text: self.title, align: .trailing, color: .white).onTapGesture {
                                    self.titleAction?()
                                }.padding([.leading, .trailing], XSize.P_CONS_DEF)
                            }
                        }
                    }
                    .navigationBarItems(trailing: Button(action: {
                        // Handle right bar button item action
                        DispatchQueue.main.async { //CommonFunctions.share.onPresentSupportVC()
                        }
                        self.rightAction?()
                    }, label: {
                        //Text("Right Button").foregroundColor(Color.red)
                        Image("icon-check-circle")
                            .resizable()
                            .frame(width: iconHeight - XSize.P_CONS_DEF / 2, height: iconHeight - XSize.P_CONS_DEF / 2, alignment: .trailing)
                            .foregroundColor(.white)
                            .layoutPriority(1)
                            .hidden()
                    }).padding(.trailing, -removeLeftRightPadding)
                    )
                    .navigationBarItems(leading: Button(action: {
                        self.onTouchBackHandle { self.backAction?() }
                    }, label: {
                        TTBaseSUIImage.init(withname: "icon.back", color: Color.white)
                            .frame(width: iconHeight, height: iconHeight, alignment: .leading)
                            .padding(.leading, -XSize.P_CONS_DEF / 2).layoutPriority(1)
                    }).padding(.leading, -removeLeftRightPadding)
                    )
            } else   if self.type == .INFO {
                self.content()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(trailing:
                        HStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                        TTBaseSUIText(withType: .TITLE, text: self.title, align: .trailing, color: .white).onTapGesture {self.titleAction?()}
                        Image("icon.supportNav").resizable().frame(width: XSize.H_NAV - XSize.P_CONS_DEF * 2, height: XSize.H_NAV - XSize.P_CONS_DEF * 2, alignment: .trailing).foregroundColor(.white).onTapGesture {
                            DispatchQueue.main.async { //CommonFunctions.share.onPresentSupportVC()
                            }
                            self.rightAction?()
                        }
                    })
                    .navigationBarItems(leading: Button(action: {
                        self.backAction?()
                    }, label: {
                        TTBaseSUIText(withBold: .TITLE, text: "TrueDoc Provider", align: .leading, color: .white)
                    }))
            } else {
                if #available(iOS 16.0, *) {
                    self.content()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationTitle("")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .toolbar(.hidden, for: .navigationBar)
                } else {
                    // Fallback on earlier versions
                    self.content()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationTitle("")
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                }
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if self.isHiddenTabbar { UITabBar.hideTabBar(animated: true)} else { UITabBar.showTabBar(animated: true) }
            UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
        }
    }
}

typealias SUIBaseViewDemo<Content: View> = SUIBaseView<Content>

//MARK:// For base funcs
extension SUIBaseView {
    fileprivate func onTouchBackHandle(completeHandle:( () -> ())?) {
        if self.backType == .SWIFTUI {
            self.presentationMode.wrappedValue.dismiss()
            completeHandle?()
        } else {
            if let _currentVC = self.hostingProvider.getCurrentVC() {
                switch self.backType {
                case .POP:
                    _currentVC.pop()
                    completeHandle?()
                break
                case .POP_TO_ROOT:
                    _currentVC.navigationController?.popToRootViewController(animated: true)
                    completeHandle?()
                break
                case .DISMISS:
                    _currentVC.dismiss(animated: true) { completeHandle?() }
                break
                case .DISMISS_ALL:
                    _currentVC.dismissAll(animated: true) { completeHandle?() }
                break
                case .CLOSE_FLOW:
                    if let nav = _currentVC.navigationController {
                        nav.popToRootViewController(animated: true)
                        nav.dismiss(animated: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { completeHandle?() }
                    } else {
                        _currentVC.dismissAll(animated: true) { completeHandle?() }
                    }
                break
                case .SWIFTUI:
                    self.presentationMode.wrappedValue.dismiss()
                }
            //Another maybe on swiftUI world!!!
            } else {
                self.presentationMode.wrappedValue.dismiss()
                completeHandle?()
                if EnvironmentsConfig.IS_SHOW_LOG {
                    UIApplication.topViewController()?.showAlert("[Dev mode] Please double check in extension SUIBaseView onTouchBackHandle")
                }
            }
        }
    }
}


struct CoreSUIBaseView_Previews: PreviewProvider {
    static var previews: some View {
        SUIBaseView(backType: .POP, title: "Search View", type: .DEFAULT) {
            TTBaseSUIText(withType: .TITLE, text: "SUIBaseView", align: .center)
                .maxWidth()
                .padding()
        }
    }
}
