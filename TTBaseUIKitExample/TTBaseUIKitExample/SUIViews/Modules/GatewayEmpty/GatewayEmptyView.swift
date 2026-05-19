//
//  GatewayEmptyView.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 18/5/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

struct GatewayEmptyView: View {
    @StateObject private var viewModel: GatewayEmptyViewModel = GatewayEmptyViewModel()

    var onCancel: (() -> Void)?
    var onContinue: (() -> Void)?

    var body: some View {
        SUIBaseView(backType: .SWIFTUI, title: XText("App.GatewayEmpty.Nav.Title"), type: .DEFAULT, isHiddenTabbar: true) {
            TTBaseSUIVStack(alignment: .center, spacing: 0, bg: XView.viewBgCellColor.toColor()) {
                mainContent
                bottomConfirmPanel
            }
            .maxWidth()
            .maxHeight()
            .bg(byDef: XView.viewBgCellColor.toColor())
        }
    }

    private var mainContent: some View {
        TTBaseSUIScroll(alignment: .vertical, bg: XView.viewBgCellColor.toColor(), content: {
            TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_L, bg: XView.viewBgCellColor.toColor()) {
                deviceHeader
                guideSection
            }
            .maxWidth()
            .pHorizontal(XSize.P_L + XSize.P_CONS_DEF)
            .pTop(XSize.P_L * 3)
            .pBottom(XSize.P_L)
        }, isEnablePullToRefresh: false)
        .maxHeight()
    }

    private var deviceHeader: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            gatewayIllustration
            TTBaseSUIText(withBold: .TITLE, text: XText("App.GatewayEmpty.Device.Name"), align: .center, color: XView.textDefColor.toColor())
        }
        .maxWidth()
    }

    private var guideSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: .clear) {
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.GatewayEmpty.Guide.Title"), align: .leading, color: XView.textSubTitleColor.toColor().opacity(0.55))
            guideRow(index: "1", title: XText("App.GatewayEmpty.Guide.Step1"))
            guideRow(index: "2", title: XText("App.GatewayEmpty.Guide.Step2"))
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.GatewayEmpty.Guide.Note"), align: .leading, color: XView.textSubTitleColor.toColor().opacity(0.75))
                .pLeading(XSize.P_L + XSize.P_XS)
                .pTop(XSize.P_XS)
        }
    }

    private var bottomConfirmPanel: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIView(withCornerRadius: 0, bg: XView.lineDefColor.toColor()) { }
                .size(height: XSize.H_LINEVIEW)
                .maxWidth()
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.GatewayEmpty.Confirm.Title"), align: .leading, color: XView.textSubTitleColor.toColor().opacity(0.7))
            confirmCheckRow
            TTBaseSUIButton(type: viewModel.canContinue ? .DEFAULT : .DISABLE, title: XText("App.GatewayEmpty.Button.Continue")) {
                if self.viewModel.canContinue {
                    self.onContinue?()
                }
            }
            .size(height: XSize.H_BUTTON_WITH_PANEL)
            .maxWidth()
            .pTop(XSize.P_CONS_DEF)
        }
        .pHorizontal(XSize.P_CONS_DEF)
        .pTop(XSize.P_CONS_DEF)
        .bg(byDef: XView.viewBgCellColor.toColor())
    }

    private var confirmCheckRow: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            checkboxView
            TTBaseSUIText(withType: .TITLE, text: XText("App.GatewayEmpty.Confirm.NetworkLight"), align: .leading, color: XView.textDefColor.toColor())
        }
        .onTapHandle { self.viewModel.toggleNetworkLightReady() }
    }

    private var checkboxView: some View {
        TTBaseSUIZStack(alignment: .center, bg: viewModel.isNetworkLightReady ? XView.buttonBgDef.toColor() : XView.viewBgCellColor.toColor()) {
            TTBaseSUIImage(withSystemName: "checkmark", iconColor: XView.viewBgCellColor.toColor(), contentMode: .fit)
                .sizeSquare(width: XSize.P_CONS_DEF)
                .hidden(!viewModel.isNetworkLightReady)
        }
        .sizeSquare(width: XSize.P_L)
        .corner(byDef: XSize.CORNER_RADIUS)
        .baseBorder(color: XView.buttonBorderColor.toColor(), width: XSize.H_LINEVIEW, radius: XSize.CORNER_RADIUS)
    }

    private var gatewayIllustration: some View {
        TTBaseSUIZStack(alignment: .center, bg: .clear) {
            TTBaseSUIView(withCornerRadius: XSize.CORNER_PANEL, bg: XView.viewBgSkeleton.toColor()) { }
                .size(width: XSize.H_BUTTON * 4, height: XSize.H_BUTTON * 4)
                .baseShadow(color: .black.opacity(0.07), radius: 12, x: 10, y: 12)
            TTBaseSUIView(withCornerRadius: XSize.CORNER_PANEL, bg: XView.viewBgSkeleton.toColor().opacity(0.85)) { }
                .size(width: XSize.H_BUTTON * 3.4, height: XSize.H_BUTTON * 3.4)
                .pTop(XSize.P_L)
            gatewayFace
        }
        .size(width: XSize.H_BUTTON * 5, height: XSize.H_BUTTON * 5)
    }

    private var gatewayFace: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_XS, bg: XView.viewBgSkeleton.toColor().opacity(0.95), radius: XSize.CORNER_PANEL) {
            indicatorLights
            TTBaseSUIImage(withSystemName: "line.3.horizontal.decrease", iconColor: XView.viewDisableColor.toColor(), contentMode: .fit)
                .size(width: XSize.H_BUTTON * 1.3, height: XSize.H_BUTTON)
            TTBaseSUIView(withCornerRadius: XSize.CORNER_RADIUS, bg: XView.viewDisableColor.toColor().opacity(0.45)) { }
                .size(width: XSize.H_BUTTON * 1.8, height: XSize.P_XS)
        }
        .size(width: XSize.H_BUTTON * 2.8, height: XSize.H_BUTTON * 2.3)
        .pAll(XSize.P_CONS_DEF)
        .baseShadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 8)
    }

    private var indicatorLights: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_XS, bg: .clear) {
            statusLight(color: XView.viewBgNavColor.toColor(), isActive: true)
            statusLight(color: XView.viewDisableColor.toColor(), isActive: false)
            statusLight(color: XView.viewDisableColor.toColor(), isActive: false)
            statusLight(color: XView.viewDisableColor.toColor(), isActive: false)
        }
    }

    private func guideRow(index: String, title: String) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            TTBaseSUIZStack(alignment: .center, bg: XView.notificationBgWarning.toColor().opacity(0.22)) {
                TTBaseSUIText(withBold: .SUB_TITLE, text: index, align: .center, color: XView.notificationBgWarning.toColor())
            }
            .sizeSquare(width: XSize.P_L)
            .corner(byDef: XSize.P_L / 2)
            TTBaseSUIText(withType: .TITLE, text: title, align: .leading, color: XView.textDefColor.toColor())
        }
    }

    private func statusLight(color: Color, isActive: Bool) -> some View {
        TTBaseSUIView(withCornerRadius: XSize.P_CONS_DEF / 2, bg: color) { }
            .sizeSquare(width: XSize.P_CONS_DEF)
            .baseShadow(color: isActive ? color.opacity(0.65) : .clear, radius: XSize.P_CONS_DEF, x: 0, y: 0)
    }
}

struct GatewayEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        GatewayEmptyView()
    }
}
