//
//  GateDetailViewModel.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - GateDetailViewModel
@MainActor
class GateDetailViewModel: ObservableObject {

    @Published var gateway: GateDetailModel
    @Published var isLoading: Bool = false
    @Published var showAddG6Sheet: Bool = false
    @Published var showAddEndpointSheet: Bool = false
    @Published var showDeleteEndpointConfirmation: Bool = false

    private var pendingDeleteEndpointId: String?

    init(gateway: GateDetailModel = .sample) {
        self.gateway = gateway
    }

    // MARK: - Actions

    func onAddG6DeviceTapped() {
        showAddG6Sheet = true
        print("[GateDetail] Add G6/G6S device tapped")
    }

    func onAddEndpointTapped() {
        showAddEndpointSheet = true
        print("[GateDetail] Add endpoint device tapped")
    }

    func onEndpointDeviceTapped(_ device: EndpointDeviceModel) {
        print("[GateDetail] Endpoint device tapped: \(device.displayName)")
    }

    func requestDeleteEndpoint(_ device: EndpointDeviceModel) {
        pendingDeleteEndpointId = device.id
        showDeleteEndpointConfirmation = true
    }

    func confirmDeleteEndpoint() {
        guard let deleteId = pendingDeleteEndpointId else { return }
        gateway.endpointDevices.removeAll { $0.id == deleteId }
        pendingDeleteEndpointId = nil
        print("[GateDetail] Endpoint deleted: \(deleteId)")
    }

    // MARK: - Fetch (simulate)

    func fetchGatewayDetail() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            self?.isLoading = false
            print("[GateDetail] Gateway detail loaded: \(self?.gateway.gatewayId ?? "")")
        }
    }
}
