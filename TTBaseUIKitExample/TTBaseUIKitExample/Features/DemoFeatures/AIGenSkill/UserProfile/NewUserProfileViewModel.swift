//
//  NewUserProfileViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 13/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import Foundation

@MainActor
class NewUserProfileViewModel: ObservableObject {
    @Published var user: DJUser?
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchUser(id: Int = 1) {
        isLoading = true
        errorMessage = nil

        Task {
            do {
                let fetchedUser = try await UserDirectoryService.shared.fetchUser(id: id)
                self.user = fetchedUser
            } catch {
                self.errorMessage = "Failed to load user profile"
                print("Error fetching user: \(error)")
            }
            self.isLoading = false
        }
    }

    func loadRandomUser() {
        let randomId = Int.random(in: 1...100)
        fetchUser(id: randomId)
    }
}
