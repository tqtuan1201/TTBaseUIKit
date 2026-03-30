//
//  PhotoModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - JPAlbum
struct JPAlbum: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
}

// MARK: - JPPhoto
struct JPPhoto: Codable, Identifiable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
