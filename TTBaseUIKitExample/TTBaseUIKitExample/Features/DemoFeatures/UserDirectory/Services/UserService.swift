//
//  UserService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

enum UserEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case detail(id: Int)
    case search(query: String)
    
    var path: String {
        switch self {
        case .list:                return "/users"
        case .detail(let id):      return "/users/\(id)"
        case .search:              return "/users/search"
        }
    }
    
    var method: TTHTTPMethod { .GET }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let skip):
            return [
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "skip", value: "\(skip)")
            ]
        case .search(let query):
            return [URLQueryItem(name: "q", value: query)]
        default: return nil
        }
    }
}

final class UserDirectoryService: TTBaseAPIService {
    static let shared = UserDirectoryService()
    private init() { super.init(baseURL: "https://dummyjson.com") }
    
    func fetchUsers(limit: Int = 20, skip: Int = 0) async throws -> DJUserResponse {
        try await request(UserEndpoint.list(limit: limit, skip: skip))
    }
    
    func fetchUser(id: Int) async throws -> DJUser {
        try await request(UserEndpoint.detail(id: id))
    }
    
    func searchUsers(query: String) async throws -> DJUserResponse {
        try await request(UserEndpoint.search(query: query))
    }
}
