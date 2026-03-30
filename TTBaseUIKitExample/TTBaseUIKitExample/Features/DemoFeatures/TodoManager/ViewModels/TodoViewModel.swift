//
//  TodoViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - TodoViewModel
@MainActor
final class TodoViewModel: ObservableObject {
    @Published var todos: [DJTodo] = []
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var filterMode: FilterMode = .all
    
    enum FilterMode: String, CaseIterable {
        case all = "All"
        case completed = "Done"
        case pending = "Pending"
    }
    
    private let service = TodoService.shared
    private var currentSkip = 0
    private var totalTodos = 0
    private let pageSize = 30
    
    var hasMore: Bool { currentSkip < totalTodos }
    
    var filteredTodos: [DJTodo] {
        switch filterMode {
        case .all: return todos
        case .completed: return todos.filter { $0.completed }
        case .pending: return todos.filter { !$0.completed }
        }
    }
    
    var completedCount: Int { todos.filter { $0.completed }.count }
    var pendingCount: Int { todos.filter { !$0.completed }.count }
    var progress: Double {
        guard !todos.isEmpty else { return 0 }
        return Double(completedCount) / Double(todos.count)
    }
    
    func loadTodos() async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil; currentSkip = 0
        do {
            let r = try await service.fetchTodos(limit: pageSize, skip: 0)
            todos = r.todos; totalTodos = r.total; currentSkip = r.todos.count
        } catch { errorMessage = error.localizedDescription }
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        do {
            let r = try await service.fetchTodos(limit: pageSize, skip: currentSkip)
            todos.append(contentsOf: r.todos); totalTodos = r.total; currentSkip += r.todos.count
        } catch { errorMessage = error.localizedDescription }
        isLoadingMore = false
    }
}
