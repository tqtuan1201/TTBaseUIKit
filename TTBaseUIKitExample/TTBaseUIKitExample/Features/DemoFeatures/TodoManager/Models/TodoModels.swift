//
//  TodoModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - TodoResponse
struct TodoResponse: Codable {
    let todos: [DJTodo]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - DJTodo
struct DJTodo: Codable, Identifiable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}
