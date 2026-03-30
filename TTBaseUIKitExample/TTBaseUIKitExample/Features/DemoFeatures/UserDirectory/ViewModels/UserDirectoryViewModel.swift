//
//  UserDirectoryViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

@MainActor
final class UserDirectoryViewModel: ObservableObject {
    
    @Published var users: [DJUser] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let service = UserDirectoryService.shared
    private var currentSkip = 0
    private var totalUsers = 0
    private let pageSize = 15
    
    var hasMore: Bool { currentSkip < totalUsers }
    
    var filteredUsers: [DJUser] {
        if searchText.isEmpty { return users }
        return users.filter {
            $0.fullName.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText) ||
            $0.company.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadUsers() async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil
        currentSkip = 0
        
        do {
            let response = try await service.fetchUsers(limit: pageSize, skip: 0)
            users = response.users
            totalUsers = response.total
            currentSkip = response.users.count
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        
        do {
            let response = try await service.fetchUsers(limit: pageSize, skip: currentSkip)
            users.append(contentsOf: response.users)
            totalUsers = response.total
            currentSkip += response.users.count
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoadingMore = false
    }
}
