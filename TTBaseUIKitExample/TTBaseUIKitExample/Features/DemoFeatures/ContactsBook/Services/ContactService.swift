//
//  ContactService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - ContactService
final class ContactService: TTBaseAPIService {
    static let shared = ContactService()
    private init() { super.init(baseURL: "https://jsonplaceholder.typicode.com") }
    
    func fetchUsers() async throws -> [JPUser] {
        try await request(TTSimpleEndpoint(path: "/users"))
    }
    
    func fetchUser(id: Int) async throws -> JPUser {
        try await request(TTSimpleEndpoint(path: "/users/\(id)"))
    }
}
