//
//  SetupDevicesView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 13/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import SwiftUI
import TTBaseUIKit

// MARK: - SetupDevicesView
struct SetupDevicesView: View {

    @StateObject private var viewModel = SetupDevicesViewModel()

    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                // Device Image
                deviceImageSection

                // Device Name
                TTBaseSUIText(withBold: .HEADER, text: "Đầu báo khói", align: .center)
                    .pTop(XSize.P_CONS_DEF)

                // Instructions Card
                instructionsCard
                    .pTop(XSize.P_L)

                // Checkbox
                checkboxSection
                    .pTop(XSize.P_L)

                // Spacer
                TTBaseSUISpacer()

                // Continue Button
                continueButton
            }
            .pAll(XSize.P_CONS_DEF)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle("Kết nối thiết bị", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
        }
    }

    // MARK: - Device Image Section
    private var deviceImageSection: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear) {
            // Smoke Detector Icon
            Image(systemName: "smoke.fill")
                .font(.system(size: 60))
                .foregroundColor(.white)
                .frame(width: 120, height: 120)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.red.opacity(0.8), Color.orange.opacity(0.8)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(XSize.CORNER_RADIUS * 3)
                .baseShadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

            // Subtitle
            TTBaseSUIText(withType: .SUB_TITLE, text: "Thiết bị sẵn sàng kết nối", align: .center, color: Color(.secondaryLabel))
        }
        .pTop(XSize.P_L)
    }

    // MARK: - Instructions Card
    private var instructionsCard: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
            // Header
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                TTBaseSUIText(withBold: .TITLE, text: "Hướng dẫn kết nối", align: .leading)
            }
            .pAll(XSize.P_CONS_DEF)

            Divider()

            // Steps
            stepRow(number: 1, text: "Lắp pin vào đầu báo khói theo chiều dương (+) âm (-)")
                .pTop(XSize.P_CONS_DEF)

            Divider()
                .pTop(XSize.P_CONS_DEF)

            stepRow(number: 2, text: "Đợi đèn led nhấp nháy màu xanh lá, báo hiệu đã kết nối thành công")
                .pTop(XSize.P_CONS_DEF)

            Divider()
                .pTop(XSize.P_CONS_DEF)

            // Note
            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: Color(.systemGray5)) {
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Lưu ý:", align: .leading, color: .orange)
                    .pTop(XSize.P_S)

                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Đèn mạng nhấp nháy màu đỏ trong 30 giây đầu tiên là hiện tượng bình thường.", align: .leading, color: XView.textDefColor.toColor())
                    .pBottom(XSize.P_S)
            }
            .pAll(XSize.P_CONS_DEF)
            .corner(byDef: XSize.CORNER_RADIUS)
            .pTop(XSize.P_CONS_DEF)
        }
        .maxWidth()
        .bg(byDef: .white)
        .corner(byDef: XSize.CORNER_RADIUS)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Step Row
    private func stepRow(number: Int, text: String) -> some View {
        TTBaseSUIHStack(alignment: .top, spacing: 12, bg: .clear) {
            // Number Badge
            Text("\(number)")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(XView.buttonBgDef.toColor())
                .cornerRadius(12)

            // Step Text
            TTBaseSUIText(withType: .SUB_TITLE, text: text, align: .leading, color: XView.textDefColor.toColor())
                .maxWidth(alignment: .leading)
        }
        .pAll(.horizontal, XSize.P_CONS_DEF)
    }

    // MARK: - Checkbox Section
    private var checkboxSection: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
            // Checkbox
            Button { viewModel.toggleCheckbox() } label: {
                Image(systemName: viewModel.isDeviceConfirmed ? "checkmark.square.fill" : "square")
                    .font(.system(size: 24))
                    .foregroundColor(viewModel.isDeviceConfirmed ? XView.buttonBgDef.toColor() : Color(.secondaryLabel))
            }

            TTBaseSUIText(withType: .SUB_TITLE, text: "Đèn led trên thiết bị đã nhấp nháy màu xanh lá", align: .leading, color: XView.textDefColor.toColor())
                .maxWidth(alignment: .leading)
        }
        .pAll(XSize.P_CONS_DEF)
        .maxWidth()
        .bg(byDef: .white)
        .corner(byDef: XSize.CORNER_RADIUS)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Continue Button
    private var continueButton: some View {
        TTBaseSUIButton(
            type: viewModel.isDeviceConfirmed ? .DEFAULT : .DISABLE,
            title: "Tiếp tục"
        ) {
            if viewModel.isDeviceConfirmed {
                viewModel.continueToNextStep()
            }
        }
        .pBottom(XSize.P_L)
    }
}

// MARK: - Preview
struct SetupDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SetupDevicesView()
        }
    }
}
