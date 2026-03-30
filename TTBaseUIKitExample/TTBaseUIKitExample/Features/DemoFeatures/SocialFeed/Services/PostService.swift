//
//  PostService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

enum PostEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case detail(id: Int)
    case search(query: String)
    case comments(postId: Int)
    case tags
    case byTag(tag: String)
    
    var path: String {
        switch self {
        case .list:                   return "/posts"
        case .detail(let id):         return "/posts/\(id)"
        case .search:                 return "/posts/search"
        case .comments(let id):       return "/posts/\(id)/comments"
        case .tags:                   return "/posts/tags"
        case .byTag(let tag):         return "/posts/tag/\(tag)"
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

final class PostService: TTBaseAPIService {
    static let shared = PostService()
    private init() { super.init(baseURL: "https://dummyjson.com") }
    
    func fetchPosts(limit: Int = 20, skip: Int = 0) async throws -> PostResponse {
        try await request(PostEndpoint.list(limit: limit, skip: skip))
    }
    
    func fetchPost(id: Int) async throws -> DJPost {
        try await request(PostEndpoint.detail(id: id))
    }
    
    func fetchComments(postId: Int) async throws -> CommentResponse {
        try await request(PostEndpoint.comments(postId: postId))
    }
    
    func searchPosts(query: String) async throws -> PostResponse {
        try await request(PostEndpoint.search(query: query))
    }
}
