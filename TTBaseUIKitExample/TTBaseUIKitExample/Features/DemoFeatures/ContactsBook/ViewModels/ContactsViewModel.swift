//
//  ContactsViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - ContactsViewModel
@MainActor
final class ContactsViewModel: ObservableObject {
    @Published var contacts: [JPUser] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = ContactService.shared
    
    var filteredContacts: [JPUser] {
        if searchText.isEmpty { return contacts }
        return contacts.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.email.localizedCaseInsensitiveContains(searchText) ||
            $0.company.name.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadContacts() async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil
        do {
            contacts = try await service.fetchUsers()
        } catch { errorMessage = error.localizedDescription }
        isLoading = false
    }
}
