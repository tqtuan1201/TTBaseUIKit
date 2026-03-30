//
//  PostModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

struct PostResponse: Codable {
    let posts: [DJPost]
    let total: Int
    let skip: Int
    let limit: Int
}

struct DJPost: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let tags: [String]
    let reactions: PostReactions
    let views: Int
    let userId: Int
    
    var totalReactions: Int { reactions.likes + reactions.dislikes }
    var likePercentage: Double {
        guard totalReactions > 0 else { return 0 }
        return Double(reactions.likes) / Double(totalReactions) * 100
    }
}

struct PostReactions: Codable {
    let likes: Int
    let dislikes: Int
}

struct CommentResponse: Codable {
    let comments: [DJComment]
    let total: Int
    let skip: Int
    let limit: Int
}

struct DJComment: Codable, Identifiable {
    let id: Int
    let body: String
    let postId: Int
    let likes: Int
    let user: CommentUser
}

struct CommentUser: Codable {
    let id: Int
    let username: String
    let fullName: String
}
