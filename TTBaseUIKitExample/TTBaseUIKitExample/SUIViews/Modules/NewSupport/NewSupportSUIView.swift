//
//  NewSupportSUIView.swift
//  AI_HEALTH
//
//  Created by TuanTruong on 19/9/24.
//  Copyright © 2024 Tuan Truong Quang. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct NewSupportSUIView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        TTBaseSUIZStack(alignment: .bottom, bg: Color.clear) {
            Color.clear.onTapHandle {
                self.onClose()
            }
            TTBaseSUIVStack(alignment: .center, spacing: XSize.getPaddingDef(), bg: .white) {
                //Title
                TTBaseSUIHStack(alignment: .top, spacing: XSize.getPadding(), bg: .clear) {
                    TTBaseSUISpacer(maxHeight: 1).layoutPriority(0)
                    TTBaseSUIText(withBold: .TITLE, text: XText("App.SupportV2.Title"), align: .center, color: XView.textDefColor.toColor())
                        .padding(.leading, XSize.H_SMALL_ICON + XSize.P_CONS_DEF)
                        .layoutPriority(1)
                    TTBaseSUISpacer(maxHeight: 1).layoutPriority(0)
                    TTBaseSUIImage(withname: "close1", contentMode: .fit)
                        .sizeSquare(width: XSize.H_SMALL_ICON - XSize.P_CONS_DEF)
                        .padding(.trailing, XSize.getPadding())
                        .onTapHandle {
                            self.onClose()
                        }
                }.padding(.top, XSize.getPadding())
                //Hot-line
                TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                    TTBaseSUIText(withType: .TITLE, text: XText("App.SupportV2.Sub1"), align: .leading, color: XView.textTitleColor.toColor())
                        .maxWidth(alignment: .leading)
                    TTBaseSUIHStack(alignment: .center, spacing: XSize.getPadding(), bg: .clear) {
                        TTBaseSUIHStack(alignment: .center, spacing: XSize.getPadding(), bg: .clear) {
                            TTBaseSUIImage(withname: "icon.yellow.callAudio", contentMode: .fit)
                                .setIcon(color: XView.buttonBgDef.toColor())
                                .sizeSquare(width: 20.0)
                                .padding([.leading, .top, .bottom], XSize.P_CONS_DEF)
                            TTBaseSUIText(withType: .SUB_TITLE, text: XText("PoupWarningDeleleAccount.Button.CallHotline"), align: .leading, color: XView.buttonBgDef.toColor())
                        }.onTapHandle(action: {
                            self.onClose()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                TTBaseUtil.shared.makeCall(WithPhoneNumber: "19002624")
                            }
                        })
                        .padding([.leading], XSize.P_CONS_DEF / 2)
                        .padding([.trailing], XSize.P_CONS_DEF)
                        .padding([.top, .bottom], XSize.P_CONS_DEF / 3)
                        .baseBorder(width: 2, radius: XSize.CORNER_BUTTON * 2)
                        .padding([.top, .trailing, .bottom], /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .padding([.leading], 2)
                            
                    }
                    .maxWidth(alignment: .leading)
                }.padding([.leading, .trailing], XSize.getPadding())
                //Chat
                TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                    TTBaseSUIText(withType: .TITLE, text: XText("App.SupportV2.Sub2"), align: .leading, color: XView.textTitleColor.toColor())
                        .maxWidth(alignment: .leading)
                    TTBaseSUIHStack(alignment: .center, spacing: XSize.getPadding() * 1.4, bg: .clear) {
                        TTBaseSUIImage(withname: "icon-zalo", contentMode: .fit)
                            .sizeSquare(width: 35.0)
                            .padding([.leading, .top, .bottom], XSize.P_CONS_DEF)
                            .onTapHandle {
                                self.onClose()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    XPrint("CommonActions.share.makeSupportByZaloMessge()")
                                }
                            }
                        TTBaseSUIImage(withname: "icon-gmail", contentMode: .fit)
                            .sizeSquare(width: 35.0)
                            .padding([.leading, .top, .bottom], XSize.P_CONS_DEF)
                            .onTapHandle {
                                self.onClose()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    XPrint("CommonActions.share.openEmail(withAddress: ValueUtil.gmailLink)")
                                }
                            }
                    }
                    .maxWidth(alignment: .leading)
                }
                .padding([.leading, .trailing], XSize.getPadding())
                .padding(.bottom, XSize.getPadding() * 2)
            }.clipShape(RoundedTopCorners(radius: 20))
        }
    }
    
    
    func onClose() {
        DispatchQueue.main.async { self.presentationMode.wrappedValue.dismiss() }
    }
}

struct NewSupportSUIView_Previews: PreviewProvider {
    static var previews: some View {
        NewSupportSUIView()
    }
}


