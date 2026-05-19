//
//  DeviceDetailViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - DeviceDetailViewModel
@MainActor
class DeviceDetailViewModel: ObservableObject {

    @Published var device: DeviceDetailModel
    @Published var isDeleting: Bool = false
    @Published var showDeleteConfirmation: Bool = false

    init(device: DeviceDetailModel = .sample) {
        self.device = device
    }

    // MARK: - Actions

    func onDeviceNameTapped() {
        // Navigate to edit device name
        print("[DeviceDetail] Device name tapped: \(device.displayName)")
    }

    func onLocationTapped() {
        // Navigate to change location
        print("[DeviceDetail] Location tapped: \(device.location)")
    }

    func requestDeleteDevice() {
        showDeleteConfirmation = true
    }

    func confirmDeleteDevice() {
        isDeleting = true
        // Simulate delete action
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isDeleting = false
            print("[DeviceDetail] Device deleted: \(self?.device.displayName ?? "")")
        }
    }
}
