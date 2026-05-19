//
//  GateDetailModels.swift
//  TTBaseUIKitExample
//
//  Created by Antigravity on 15/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

// MARK: - GatewayDeviceStatus
enum GatewayDeviceStatus: String {
    case online  = "online"
    case offline = "offline"

    var isOnline: Bool { self == .online }

    /// Localizable.strings key — use with XText(status.localizedKey)
    var localizedKey: String {
        switch self {
        case .online:  return "App.GateDetail.Status.Online"
        case .offline: return "App.GateDetail.Status.Offline"
        }
    }
}

// MARK: - G6DeviceModel
struct G6DeviceModel: Identifiable {
    let id: String
    var name: String
}

// MARK: - EndpointDeviceModel
struct EndpointDeviceModel: Identifiable {
    let id: String
    var name: String
    var status: GatewayDeviceStatus
    var location: String
    var batteryPercent: Int

    var displayName: String { "\(id) - \(name)" }
    var batteryText: String  { "\(batteryPercent)%" }
}

// MARK: - GateDetailModel
struct GateDetailModel {
    let gatewayId: String          // e.g. "GL302A112233"
    var batteryPercent: Int         // Pin %
    var temperature: Int            // Nhiệt độ (°C)
    var rssi: String                // e.g. "-36dBm"
    var g6Devices: [G6DeviceModel]
    var endpointDevices: [EndpointDeviceModel]

    var navTitle: String { "Gateway - \(gatewayId)" }
    var batteryText: String { "\(batteryPercent)%" }
    var temperatureText: String { "\(temperature)" }
}

// MARK: - Sample Data
extension GateDetailModel {
    static let sample = GateDetailModel(
        gatewayId: "GL302A112233",
        batteryPercent: 90,
        temperature: 30,
        rssi: "-36dBm",
        g6Devices: [],
        endpointDevices: [
            EndpointDeviceModel(id: "33251", name: "AALCLPLXX", status: .online,  location: "Phòng ăn", batteryPercent: 90),
            EndpointDeviceModel(id: "33251", name: "AALCLPLXX", status: .online,  location: "Phòng ăn", batteryPercent: 90),
            EndpointDeviceModel(id: "33251", name: "AALCLPLXX", status: .offline, location: "Phòng ăn", batteryPercent: 90),
            EndpointDeviceModel(id: "33251", name: "AALCLPLXX", status: .online,  location: "Phòng ăn", batteryPercent: 90)
        ]
    )
}
