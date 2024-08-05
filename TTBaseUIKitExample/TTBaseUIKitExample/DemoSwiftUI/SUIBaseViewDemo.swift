//
//  SUIBaseView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 2/8/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct SUIBaseViewDemo<Content: View>: View {
    
    public enum BACK_TYPE {
        case POP
        case POP_TO_ROOT
        case DISMISS
        case DISMISS_ALL
        case CLOSE_FLOW
    }
    
    public enum TYPE {
        case DEFAULT
        case INFO
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
                
                type:SUIBaseViewDemo.TYPE = .DEFAULT,
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
        let iconHeight:CGFloat = XSize.H_NAV - XSize.P_CONS_DEF * 2.7
        let removeLeftRightPadding:CGFloat = XSize.P_CONS_DEF / 2
        NavigationView {
            if self.type == .DEFAULT {
                self.content()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            VStack {
                                TTBaseSUIText(withType: .TITLE, text: self.title, align: .center, color: .white).onTapGesture {
                                    self.titleAction?()
                                }.padding([.leading, .trailing], XSize.P_CONS_DEF)
                            }
                        }
                    }
                    .navigationBarItems(trailing: Button(action: {
                        // Handle right bar button item action
                        DispatchQueue.main.async { UIApplication.topViewController()?.showNoticeView(body: "Right Button") }
                        self.rightAction?()
                    }, label: {
                        //Text("Right Button").foregroundColor(Color.white)
                        Image("icon.supportNav")
                            .resizable()
                            .frame(width: iconHeight - XSize.P_CONS_DEF / 2, height: iconHeight - XSize.P_CONS_DEF / 2, alignment: .trailing)
                            .foregroundColor(.white)
                            .layoutPriority(1)
                    }).padding(.trailing, -removeLeftRightPadding)
                    )
                    .navigationBarItems(leading: Button(action: {
                        self.onTouchBackHandle { self.backAction?() }
                    }, label: {
                        TTBaseSUIImage(withname: "icon.nav.backswiftui", color: .white, contentMode: .fit)
                            .frame(width: iconHeight, height: iconHeight, alignment: .leading)
                            .padding(.leading, -XSize.P_CONS_DEF).layoutPriority(1)
                    }).padding(.leading, -removeLeftRightPadding)
                    )
            } else {
                self.content()
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarItems(trailing:
                        HStack(alignment: .center, spacing: XSize.P_CONS_DEF) {
                        TTBaseSUIText(withType: .TITLE, text: self.title, align: .trailing, color: .white).onTapGesture {self.titleAction?()}
                        Image("icon.supportNav").resizable().frame(width: XSize.H_NAV - XSize.P_CONS_DEF * 2, height: XSize.H_NAV - XSize.P_CONS_DEF * 2, alignment: .trailing).foregroundColor(.white).onTapGesture {
                            DispatchQueue.main.async { UIApplication.topViewController()?.showNoticeView(body: "Right Button") }
                            self.rightAction?()
                        }
                    })
                    .navigationBarItems(leading: Button(action: {
                        self.backAction?()
                    }, label: {
                        TTBaseSUIText(withBold: .TITLE, text: "12BAY.VN", align: .leading, color: .white)
                    }))
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            if self.isHiddenTabbar { UITabBar.hideTabBar(animated: true)} else { UITabBar.showTabBar(animated: true) }
            UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
        }
    }
}

//MARK:// For base funcs
extension SUIBaseViewDemo {
    fileprivate func onTouchBackHandle(completeHandle:( () -> ())?) {
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
            }
        //Another maybe on swiftUI world!!!
        } else {
            self.presentationMode.wrappedValue.dismiss()
            completeHandle?()
        }
    }
}

struct SUIBaseView_Previews: PreviewProvider {
    static var previews: some View {
        SUIBaseViewDemo(backType: .POP, title: "Nav Title") {
            TTBaseSUIView(withCornerRadius: 10, bg: XView.labelBgDef.toColor()) {
                
            }.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/, 40.0)
        }
    }
}

