//
//  GListModels.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 18/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - GListConnectionStatus
enum GListConnectionStatus: String {
    case online
    case offline

    var isOnline: Bool { self == .online }

    var localizedKey: String {
        switch self {
        case .online: return "App.GList.Status.Online"
        case .offline: return "App.GList.Status.Offline"
        }
    }
}

// MARK: - GListDeviceModel
struct GListDeviceModel: Identifiable {
    let id: String
    let deviceCode: String
    let deviceType: String
    let activationStatusKey: String
    let maintenanceStatusKey: String
    let connectionStatus: GListConnectionStatus
}

// MARK: - Sample Data
extension GListDeviceModel {
    static let samples: [GListDeviceModel] = [
        GListDeviceModel(
            id: "g6-001",
            deviceCode: "0025800037378",
            deviceType: "TTS-06",
            activationStatusKey: "App.GList.Status.Activated",
            maintenanceStatusKey: "App.GList.Status.Maintenance",
            connectionStatus: .online
        ),
        GListDeviceModel(
            id: "g6-002",
            deviceCode: "0025800037378",
            deviceType: "TTS-06",
            activationStatusKey: "App.GList.Status.Activated",
            maintenanceStatusKey: "App.GList.Status.Maintenance",
            connectionStatus: .online
        ),
        GListDeviceModel(
            id: "g6-003",
            deviceCode: "0025800037378",
            deviceType: "TTS-06",
            activationStatusKey: "App.GList.Status.Activated",
            maintenanceStatusKey: "App.GList.Status.Maintenance",
            connectionStatus: .online
        )
    ]
}
