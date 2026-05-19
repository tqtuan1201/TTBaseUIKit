//
//  GateDetailView.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import SwiftUI
import TTBaseUIKit

// MARK: - GateDetailView
struct GateDetailView: View {

    @StateObject private var viewModel: GateDetailViewModel

    init(gateway: GateDetailModel = .sample) {
        _viewModel = StateObject(wrappedValue: GateDetailViewModel(gateway: gateway))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: XSize.P_L) {

                // ── 1. Gateway Info Card ──────────────────────────────
                gatewayInfoCard
                    .padding(.top, XSize.P_L)

                // ── 2. G6/G6S Section ────────────────────────────────
                g6Section

                // ── 3. Endpoint Section ───────────────────────────────
                endpointSection
                    .padding(.bottom, XSize.P_L)
            }
            .padding(.horizontal, XSize.P_L)
        }
        .background(XView.viewBgColor.toColor().ignoresSafeArea())
        .navigationBarTitle(viewModel.gateway.navTitle, displayMode: .inline)
        .alert(isPresented: $viewModel.showDeleteEndpointConfirmation) {
            Alert(
                title: Text(XText("App.GateDetail.Alert.DeleteTitle")),
                message: Text(XText("App.GateDetail.Alert.DeleteMessage")),
                primaryButton: .destructive(Text(XText("App.GateDetail.Alert.DeleteConfirm"))) {
                    viewModel.confirmDeleteEndpoint()
                },
                secondaryButton: .cancel(Text(XText("App.GateDetail.Alert.DeleteCancel")))
            )
        }
        .onAppear { viewModel.fetchGatewayDetail() }
    }
}

// MARK: - Gateway Info Card
private extension GateDetailView {

    var gatewayInfoCard: some View {
        VStack(spacing: 0) {
            infoRow(title: XText("App.GateDetail.Info.Pin"),         value: viewModel.gateway.batteryText)
            rowDivider
            infoRow(title: XText("App.GateDetail.Info.Temperature"), value: viewModel.gateway.temperatureText)
            rowDivider
            infoRow(title: XText("App.GateDetail.Info.RSSI"),        value: viewModel.gateway.rssi)
        }
        .background(XView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_PANEL))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }

    func infoRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textSubTitleColor.toColor())
            Spacer()
            Text(value)
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textDefColor.toColor())
        }
        .padding(.horizontal, XSize.P_L)
        .frame(minHeight: 52)
    }

    var rowDivider: some View {
        Divider()
            .padding(.leading, XSize.P_L)
    }
}

// MARK: - G6/G6S Section
private extension GateDetailView {

    var g6Section: some View {
        VStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {

            // Section title
            Text(XText("App.GateDetail.G6.SectionTitle"))
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textDefColor.toColor())

            if viewModel.gateway.g6Devices.isEmpty {
                VStack(spacing: XSize.P_CONS_DEF) {
                    g6EmptyStateView
                    g6AddButton
                }
            } else {
                ForEach(viewModel.gateway.g6Devices) { device in
                    g6DeviceRow(device)
                }
                g6AddButton
            }
        }
    }

    // Dashed-border empty state card
    var g6EmptyStateView: some View {
        VStack(spacing: XSize.P_CONS_DEF) {
            ZStack {
                Circle()
                    .fill(XView.viewBgColor.toColor())
                    .frame(width: 56, height: 56)
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 22, weight: .light))
                    .foregroundColor(XView.iconColor.toColor())
                Image(systemName: "sparkle")
                    .font(.system(size: 8, weight: .regular))
                    .foregroundColor(XView.iconColor.toColor())
                    .offset(x: 20, y: -14)
                Image(systemName: "sparkle")
                    .font(.system(size: 6, weight: .regular))
                    .foregroundColor(XView.iconColor.toColor())
                    .offset(x: -22, y: 18)
            }
            .padding(.top, XSize.P_L)

            Text(XText("App.GateDetail.G6.EmptyMessage"))
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textSubTitleColor.toColor())
                .multilineTextAlignment(.center)
                .padding(.bottom, XSize.P_L)
        }
        .frame(maxWidth: .infinity)
        .overlay(
            RoundedRectangle(cornerRadius: XSize.CORNER_PANEL)
                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                .foregroundColor(XView.iconColor.toColor().opacity(0.4))
        )
    }

    var g6AddButton: some View {
        Button {
            viewModel.onAddG6DeviceTapped()
        } label: {
            Text(XText("App.GateDetail.G6.AddButton"))
                .font(.system(size: XFont.TITLE_H, weight: .semibold))
                .foregroundColor(UIColor.gray.toColor())
                .frame(maxWidth: .infinity)
                .frame(height: XSize.H_BUTTON + 4)
                .background(Color(red: 1.0, green: 0.80, blue: 0.08))
                .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_BUTTON + 6))
        }
        .buttonStyle(.plain)
        .accessibilityLabel(XText("App.GateDetail.A11y.AddG6"))
    }

    func g6DeviceRow(_ device: G6DeviceModel) -> some View {
        HStack {
            Text(device.name)
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textDefColor.toColor())
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: XFont.SUB_TITLE_H, weight: .medium))
                .foregroundColor(XView.iconColor.toColor())
        }
        .padding(.horizontal, XSize.P_L)
        .frame(minHeight: 52)
        .background(XView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_PANEL))
        .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
    }
}

// MARK: - Endpoint Section
private extension GateDetailView {

    var endpointSection: some View {
        VStack(alignment: .leading, spacing: XSize.P_CONS_DEF) {

            // Section header row
            HStack {
                Text(XText("App.GateDetail.Endpoint.SectionTitle"))
                    .font(.system(size: XFont.TITLE_H, weight: .regular))
                    .foregroundColor(XView.textDefColor.toColor())
                Spacer()
                Button {
                    viewModel.onAddEndpointTapped()
                } label: {
                    Text(XText("App.GateDetail.Endpoint.AddNew"))
                        .font(.system(size: XFont.TITLE_H, weight: .regular))
                        .foregroundColor(Color(red: 1.0, green: 0.70, blue: 0.05))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(XText("App.GateDetail.A11y.AddEndpoint"))
            }

            // Device list
            VStack(spacing: XSize.P_S) {
                ForEach(viewModel.gateway.endpointDevices) { device in
                    endpointDeviceRow(device)
                }
            }
        }
    }

    func endpointDeviceRow(_ device: EndpointDeviceModel) -> some View {
        Button {
            viewModel.onEndpointDeviceTapped(device)
        } label: {
            HStack(spacing: XSize.P_CONS_DEF) {

                // Device icon placeholder
                RoundedRectangle(cornerRadius: XSize.P_S)
                    .fill(XView.viewBgColor.toColor())
                    .frame(width: 44, height: 44)
                    .overlay(
                        Image(systemName: "sensor.tag.radiowaves.forward.fill")
                            .font(.system(size: 18, weight: .light))
                            .foregroundColor(XView.iconColor.toColor())
                    )

                // Labels
                VStack(alignment: .leading, spacing: 4) {
                    Text(device.displayName)
                        .font(.system(size: XFont.TITLE_H, weight: .semibold))
                        .foregroundColor(XView.textDefColor.toColor())
                        .lineLimit(1)

                    HStack(spacing: 6) {
                        Circle()
                            .fill(device.status.isOnline ? Color.green : XView.iconColor.toColor())
                            .frame(width: 7, height: 7)

                        Text(XText(device.status.localizedKey))
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(XView.textSubTitleColor.toColor())

                        Text("·")
                            .foregroundColor(XView.textSubTitleColor.toColor())
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))

                        Text(device.location)
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(XView.textSubTitleColor.toColor())

                        Text("·")
                            .foregroundColor(XView.textSubTitleColor.toColor())
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))

                        Text(device.batteryText)
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(XView.textSubTitleColor.toColor())

                        Image(systemName: "battery.75percent")
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .regular))
                            .foregroundColor(XView.textSubTitleColor.toColor())
                    }
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: XFont.SUB_TITLE_H, weight: .medium))
                    .foregroundColor(XView.iconColor.toColor())
            }
            .padding(.horizontal, XSize.P_CONS_DEF)
            .padding(.vertical, XSize.P_CONS_DEF)
            .background(XView.viewBgCellColor.toColor())
            .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_RADIUS))
            .shadow(color: .black.opacity(0.06), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(device.displayName), \(XText(device.status.localizedKey)), \(device.location), Pin \(device.batteryText)")
        .accessibilityHint(XText("App.GateDetail.A11y.DeviceHint"))
    }
}

// MARK: - Preview
struct GateDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GateDetailView(gateway: .sample)
        }
    }
}
