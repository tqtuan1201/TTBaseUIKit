//
//  DeviceDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import SwiftUI
import TTBaseUIKit

// MARK: - DeviceDetailView
struct DeviceDetailView: View {

    @StateObject private var viewModel: DeviceDetailViewModel

    init(device: DeviceDetailModel = .sample) {
        _viewModel = StateObject(wrappedValue: DeviceDetailViewModel(device: device))
    }

    var body: some View {
        VStack(spacing: 0) {
            // Device info card
            deviceInfoCard
                .padding(.top, XSize.P_L)
                .padding(.horizontal, XSize.P_L)

            Spacer()

            // Delete button at bottom
            deleteButton
                .padding(.horizontal, XSize.P_L)
                .padding(.bottom, XSize.P_L)
        }
        .background(XView.viewBgColor.toColor().ignoresSafeArea())
        .navigationBarTitle(viewModel.device.displayName, displayMode: .inline)
        .alert(isPresented: $viewModel.showDeleteConfirmation) {
            Alert(
                title: Text("Xác nhận"),
                message: Text("Bạn có chắc chắn muốn xoá thiết bị này?"),
                primaryButton: .destructive(Text("Xoá")) {
                    viewModel.confirmDeleteDevice()
                },
                secondaryButton: .cancel(Text("Huỷ"))
            )
        }
    }
}

// MARK: - Device Info Card
private extension DeviceDetailView {

    var deviceInfoCard: some View {
        VStack(spacing: 0) {
            // Row 1: Tên thiết bị (Device Name) - tappable
            deviceNameRow

            rowDivider

            // Row 2: Trạng thái hoạt động (Status)
            statusRow

            rowDivider

            // Row 3: Vị trí (Location) - tappable
            locationRow

            rowDivider

            // Row 4: Pin (Battery)
            batteryRow
        }
        .background(XView.viewBgCellColor.toColor())
        .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_PANEL))
        .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Info Rows
private extension DeviceDetailView {

    var deviceNameRow: some View {
        Button {
            viewModel.onDeviceNameTapped()
        } label: {
            infoRow(
                title: "Tên thiết bị",
                trailing: {
                    HStack(spacing: XSize.P_S) {
                        Text(viewModel.device.displayName)
                            .font(.system(size: XFont.TITLE_H, weight: .regular))
                            .foregroundColor(XView.textDefColor.toColor())
                        Image(systemName: "chevron.right")
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .medium))
                            .foregroundColor(XView.iconColor.toColor())
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Tên thiết bị, \(viewModel.device.displayName)")
        .accessibilityHint("Nhấn để chỉnh sửa tên thiết bị")
    }

    var statusRow: some View {
        infoRow(
            title: "Trạng thái hoạt động",
            trailing: {
                HStack(spacing: XSize.P_S) {
                    Circle()
                        .fill(viewModel.device.status.isOnline
                              ? Color.green
                              : XView.iconColor.toColor())
                        .frame(width: 8, height: 8)
                    Text(viewModel.device.status.rawValue)
                        .font(.system(size: XFont.TITLE_H, weight: .regular))
                        .foregroundColor(XView.textDefColor.toColor())
                }
            }
        )
        .accessibilityLabel("Trạng thái hoạt động, \(viewModel.device.status.rawValue)")
    }

    var locationRow: some View {
        Button {
            viewModel.onLocationTapped()
        } label: {
            infoRow(
                title: "Vị trí",
                trailing: {
                    HStack(spacing: XSize.P_S) {
                        Text(viewModel.device.location)
                            .font(.system(size: XFont.TITLE_H, weight: .regular))
                            .foregroundColor(XView.textDefColor.toColor())
                        Image(systemName: "chevron.right")
                            .font(.system(size: XFont.SUB_TITLE_H, weight: .medium))
                            .foregroundColor(XView.iconColor.toColor())
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Vị trí, \(viewModel.device.location)")
        .accessibilityHint("Nhấn để thay đổi vị trí")
    }

    var batteryRow: some View {
        infoRow(
            title: "Pin",
            trailing: {
                Text(viewModel.device.batteryText)
                    .font(.system(size: XFont.TITLE_H, weight: .regular))
                    .foregroundColor(XView.textDefColor.toColor())
            }
        )
        .accessibilityLabel("Pin, \(viewModel.device.batteryText)")
    }
}

// MARK: - Shared Row Layout
private extension DeviceDetailView {

    func infoRow<Trailing: View>(
        title: String,
        @ViewBuilder trailing: () -> Trailing
    ) -> some View {
        HStack {
            Text(title)
                .font(.system(size: XFont.TITLE_H, weight: .regular))
                .foregroundColor(XView.textSubTitleColor.toColor())

            Spacer()

            trailing()
        }
        .padding(.horizontal, XSize.P_L)
        .frame(minHeight: 52)
        .contentShape(Rectangle())
    }

    var rowDivider: some View {
        Divider()
            .padding(.leading, XSize.P_L)
    }
}

// MARK: - Delete Button
private extension DeviceDetailView {

    var deleteButton: some View {
        Button {
            viewModel.requestDeleteDevice()
        } label: {
            Text("Xoá thiết bị này")
                .font(.system(size: XFont.TITLE_H, weight: .semibold))
                .foregroundColor(XView.textDefColor.toColor())
                .frame(maxWidth: .infinity)
                .frame(height: XSize.H_BUTTON + 8)
                .background(XView.viewBgCellColor.toColor())
                .clipShape(RoundedRectangle(cornerRadius: XSize.CORNER_PANEL + 4))
                .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isDeleting)
        .opacity(viewModel.isDeleting ? 0.5 : 1.0)
        .accessibilityLabel("Xoá thiết bị này")
        .accessibilityHint("Nhấn để xoá thiết bị")
    }
}

// MARK: - Preview
struct DeviceDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DeviceDetailView(device: .sample)
        }
    }
}
