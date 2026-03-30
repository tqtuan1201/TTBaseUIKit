//
//  SocialFeedViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - SocialFeedViewModel
@MainActor
final class SocialFeedViewModel: ObservableObject {
    @Published var posts: [DJPost] = []
    @Published var searchText = ""
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    @Published var selectedPost: DJPost?
    @Published var comments: [DJComment] = []
    @Published var isLoadingComments = false
    
    private let service = PostService.shared
    private var currentSkip = 0
    private var totalPosts = 0
    private let pageSize = 15
    
    var hasMore: Bool { currentSkip < totalPosts }
    
    var filteredPosts: [DJPost] {
        if searchText.isEmpty { return posts }
        return posts.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.body.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    func loadPosts() async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil; currentSkip = 0
        do {
            let r = try await service.fetchPosts(limit: pageSize, skip: 0)
            posts = r.posts; totalPosts = r.total; currentSkip = r.posts.count
        } catch { errorMessage = error.localizedDescription }
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        do {
            let r = try await service.fetchPosts(limit: pageSize, skip: currentSkip)
            posts.append(contentsOf: r.posts); totalPosts = r.total; currentSkip += r.posts.count
        } catch { errorMessage = error.localizedDescription }
        isLoadingMore = false
    }
    
    func loadComments(for postId: Int) async {
        isLoadingComments = true
        do {
            let r = try await service.fetchComments(postId: postId)
            comments = r.comments
        } catch { comments = [] }
        isLoadingComments = false
    }
}
