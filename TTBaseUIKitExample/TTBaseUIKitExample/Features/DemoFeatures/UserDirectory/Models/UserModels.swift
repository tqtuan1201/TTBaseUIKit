//
//  UserModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - User Response
struct DJUserResponse: Codable {
    let users: [DJUser]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - User
struct DJUser: Codable, Identifiable {
    let id: Int
    let firstName: String
    let lastName: String
    let maidenName: String
    let age: Int
    let gender: String
    let email: String
    let phone: String
    let username: String
    let birthDate: String
    let image: String
    let bloodGroup: String
    let height: Double
    let weight: Double
    let eyeColor: String
    let hair: DJUserHair
    let address: DJUserAddress
    let university: String
    let company: DJUserCompany
    
    var fullName: String { "\(firstName) \(lastName)" }
    var formattedHeight: String { String(format: "%.0f cm", height) }
    var formattedWeight: String { String(format: "%.1f kg", weight) }
    var initials: String {
        let f = firstName.prefix(1)
        let l = lastName.prefix(1)
        return "\(f)\(l)"
    }
}

struct DJUserHair: Codable {
    let color: String
    let type: String
}

struct DJUserAddress: Codable {
    let address: String
    let city: String
    let state: String
    let stateCode: String
    let postalCode: String
    let country: String
    
    var formatted: String { "\(city), \(state)" }
}

struct DJUserCompany: Codable {
    let department: String
    let name: String
    let title: String
}
