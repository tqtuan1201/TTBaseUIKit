//
//  DeviceDetailModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - DeviceStatus
enum DeviceStatus: String {
    case online = "Trực tuyến"
    case offline = "Ngoại tuyến"

    var isOnline: Bool { self == .online }
}

// MARK: - DeviceDetailModel
struct DeviceDetailModel: Identifiable {
    let id: String
    var name: String
    var status: DeviceStatus
    var location: String
    var batteryPercent: Int

    var displayName: String {
        "\(id) - \(name)"
    }

    var batteryText: String {
        "\(batteryPercent)%"
    }
}

// MARK: - Sample Data
extension DeviceDetailModel {
    static let sample = DeviceDetailModel(
        id: "33251",
        name: "AALCLPLXX",
        status: .online,
        location: "Phòng khách",
        batteryPercent: 90
    )
}
