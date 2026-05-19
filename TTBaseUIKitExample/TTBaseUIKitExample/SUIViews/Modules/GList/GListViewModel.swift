//
//  GListViewModel.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 18/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - GListViewModel
@MainActor
class GListViewModel: ObservableObject {

    @Published var searchText: String = ""
    @Published var devices: [GListDeviceModel] = []
    @Published var selectedDeviceId: String?
    @Published var isLoading: Bool = false

    var filteredDevices: [GListDeviceModel] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return devices }
        return devices.filter {
            $0.deviceCode.localizedCaseInsensitiveContains(query)
                || $0.deviceType.localizedCaseInsensitiveContains(query)
        }
    }

    var hasSelectedDevice: Bool {
        selectedDeviceId != nil
    }

    func fetchDevices() {
        guard devices.isEmpty else { return }
        isLoading = true
        devices = GListDeviceModel.samples
        selectedDeviceId = devices.first?.id
        isLoading = false
    }

    func selectDevice(_ device: GListDeviceModel) {
        selectedDeviceId = device.id
    }

    func isSelected(_ device: GListDeviceModel) -> Bool {
        selectedDeviceId == device.id
    }

    func submitSelectedDevice() {
        guard let selectedDevice = devices.first(where: { $0.id == selectedDeviceId }) else { return }
        print("[GList] Add selected device: \(selectedDevice.deviceCode)")
    }
}

typealias GListState = GListViewModel
