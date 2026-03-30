//
//  TodoService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - TodoEndpoint
enum TodoEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case single(id: Int)
    case random
    
    var path: String {
        switch self {
        case .list:              return "/todos"
        case .single(let id):    return "/todos/\(id)"
        case .random:            return "/todos/random"
        }
    }
    
    var method: TTHTTPMethod { .GET }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let skip):
            return [URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "skip", value: "\(skip)")]
        default: return nil
        }
    }
}

// MARK: - TodoService
final class TodoService: TTBaseAPIService {
    static let shared = TodoService()
    private init() { super.init(baseURL: "https://dummyjson.com") }
    
    func fetchTodos(limit: Int = 30, skip: Int = 0) async throws -> TodoResponse {
        try await request(TodoEndpoint.list(limit: limit, skip: skip))
    }
    
    func fetchRandom() async throws -> DJTodo {
        try await request(TodoEndpoint.random)
    }
}
