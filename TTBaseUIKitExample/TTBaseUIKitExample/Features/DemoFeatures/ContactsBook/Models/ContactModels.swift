//
//  ContactModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - JPUser
struct JPUser: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: JPAddress
    let phone: String
    let website: String
    let company: JPCompany
    
    var initials: String {
        let parts = name.components(separatedBy: " ")
        return parts.compactMap { $0.first.map(String.init) }.prefix(2).joined()
    }
}

struct JPAddress: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: JPGeo
    
    var formatted: String { "\(street), \(suite), \(city) \(zipcode)" }
}

struct JPGeo: Codable {
    let lat: String
    let lng: String
}

struct JPCompany: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}
