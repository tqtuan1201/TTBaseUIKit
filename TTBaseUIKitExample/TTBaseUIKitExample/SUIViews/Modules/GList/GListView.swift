//
//  GListView.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 18/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import SwiftUI
import TTBaseUIKit

// MARK: - GListView
struct GListView: View {

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel = GListState()

    var body: some View {
        TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIVStack(alignment: .center, spacing: 0, bg: XView.viewBgCellColor.toColor()) {
                headerSection

                TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
                    TTBaseSUILazyVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: .clear) {
                        searchSection
                        resultCountSection
                        deviceListSection
                    }
                    .padding(.horizontal, XSize.P_CONS_DEF)
                    .padding(.bottom, XSize.H_BUTTON + XSize.P_L * 2)
                }
                .maxWidth(alignment: .leading)

                bottomActionSection
            }
        }
        .background(XView.viewBgCellColor.toColor().ignoresSafeArea())
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarHidden(true)
        .onAppear {
            viewModel.fetchDevices()
            UITabBar.hideTabBar(animated: true)
        }
    }
}

// MARK: - Sections
private extension GListView {

    var headerSection: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            TTBaseSUIView(withCornerRadius: XSize.H_LINEVIEW * 2, bg: XView.viewDisableColor.toColor()) { }
                .frame(width: XSize.H_BUTTON, height: XSize.H_LINEVIEW * 3)
                .padding(.top, XSize.P_S)
            Image(systemName: "simcard.fill")
                .font(.system(size: XFont.HEADER_H + XSize.P_S, weight: .semibold))
                .foregroundColor(XView.notificationBgWarning.toColor())

            TTBaseSUIText(withBold: .HEADER, text: XText("App.GList.Title"), align: .center, color: XView.textDefColor.toColor())
        }
        .padding(.horizontal, XSize.P_CONS_DEF)
        .padding(.bottom, XSize.P_CONS_DEF)
    }

    var searchSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: .clear) {
            TTBaseSUIText(withType: .SUB_TITLE, text: XText("App.GList.Description"), align: .leading, color: XView.textSubTitleColor.toColor())

            TTBaseSUITextField(placeholder: XText("App.GList.Search.Placeholder"), text: $viewModel.searchText, type: .SEARCH)
                .frame(height: XSize.H_TEXTFIELD + XSize.P_S)
        }
    }

    var resultCountSection: some View {
        TTBaseSUIText(withType: .SUB_SUB_TILE, text: String(format: XText("App.GList.Result.Count"), viewModel.filteredDevices.count), align: .leading, color: XView.textSubTitleColor.toColor())
            .padding(.top, XSize.P_S)
    }

    var deviceListSection: some View {
        TTBaseSUILazyVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            ForEach(viewModel.filteredDevices) { device in
                GListDeviceCardView(device: device, isSelected: viewModel.isSelected(device))
                    .skeleton(active: viewModel.isLoading)
                    .onTapHandle {
                        viewModel.selectDevice(device)
                    }
            }
        }
    }

    var bottomActionSection: some View {
        TTBaseSUIView(withCornerRadius: 0, bg: XView.viewBgCellColor.toColor()) {
            TTBaseSUIButton(
                type: viewModel.hasSelectedDevice
                    ? .DEFAULT_COLOR(color: XView.notificationBgWarning, textColor: XView.textDefColor)
                    : .DISABLE,
                title: XText("App.GList.Button.Add")
            ) {
                viewModel.submitSelectedDevice()
            }
            .padding(.horizontal, XSize.P_CONS_DEF)
            .padding(.top, XSize.P_CONS_DEF)
            .padding(.bottom, XSize.P_L)
        }
        .baseShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: -2)
    }
}

// MARK: - GListDeviceCardView
struct GListDeviceCardView: View {

    let device: GListDeviceModel
    let isSelected: Bool

    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_CONS_DEF, bg: Color.clear, radius: XSize.CORNER_PANEL) {
            cardHeader

            deviceInfoRow(title: XText("App.GList.Device.Type"), value: device.deviceType, valueColor: XView.textDefColor.toColor())
            deviceInfoRow(title: XText("App.GList.Device.ActivationStatus"), value: XText(device.activationStatusKey), valueColor: XView.viewBgNavColor.toColor())
            deviceInfoRow(title: XText("App.GList.Device.DeviceStatus"), value: XText(device.maintenanceStatusKey), valueColor: XView.notificationBgWarning.toColor(), isBadge: true)
        }
        .pAll(XSize.P_CONS_DEF)
        .padding(XSize.P_CONS_DEF)
        
        .maxWidth(alignment: .leading)
        .overlay(
            RoundedRectangle(cornerRadius: XSize.CORNER_PANEL)
                .stroke(isSelected ? XView.notificationBgWarning.toColor() : Color.clear, lineWidth: XSize.H_LINEVIEW * 2)
        )
        .overlay(selectedBadge, alignment: .topTrailing)
        .bg(byDef: XView.viewBgCellColor.toColor())
        .baseShadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 3)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(device.deviceCode), \(XText(device.connectionStatus.localizedKey)), \(device.deviceType)")
    }

    private var cardHeader: some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_S, bg: .clear) {
            Image(systemName: "simcard.fill")
                .font(.system(size: XFont.SUB_TITLE_H, weight: .semibold))
                .foregroundColor(XView.notificationBgWarning.toColor())

            TTBaseSUIText(withBold: .TITLE, text: device.deviceCode, align: .leading, color: XView.textDefColor.toColor())

            TTBaseSUISpacer()

            Circle()
                .fill(device.connectionStatus.isOnline ? Color.green : XView.viewDisableColor.toColor())
                .frame(width: XSize.H_LINEVIEW * 4, height: XSize.H_LINEVIEW * 4)

            TTBaseSUIText(withType: .SUB_SUB_TILE, text: XText(device.connectionStatus.localizedKey), align: .trailing, color: XView.textDefColor.toColor())
        }
    }

    private func deviceInfoRow(title: String, value: String, valueColor: Color, isBadge: Bool = false) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: XSize.P_S, bg: .clear) {
            TTBaseSUIText(withType: .SUB_TITLE, text: title, align: .leading, color: XView.textSubTitleColor.toColor())
            TTBaseSUISpacer()
            if isBadge {
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: value, align: .center, color: valueColor)
                    .padding(.horizontal, XSize.P_CONS_DEF)
                    .padding(.vertical, XSize.P_S / 2)
                    .background(XView.notificationBgWarning.toColor().opacity(0.12))
                    .cornerRadius(XSize.CORNER_BUTTON)
            } else {
                TTBaseSUIText(withType: .SUB_TITLE, text: value, align: .trailing, color: valueColor)
            }
        }
    }

    @ViewBuilder
    private var selectedBadge: some View {
        if isSelected {
            Image(systemName: "checkmark")
                .font(.system(size: XFont.SUB_SUB_TITLE_H, weight: .bold))
                .foregroundColor(XView.viewBgCellColor.toColor())
                .frame(width: XSize.P_L, height: XSize.P_L)
                .background(XView.notificationBgWarning.toColor())
                .clipShape(RoundedRectangle(cornerRadius: XSize.P_S))
        }
    }
}

// MARK: - Preview
struct GListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GListView()
        }
    }
}
