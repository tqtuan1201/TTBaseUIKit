//
//  QuoteModels.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - QuoteResponse
struct QuoteResponse: Codable {
    let quotes: [DJQuote]
    let total: Int
    let skip: Int
    let limit: Int
}

// MARK: - DJQuote
struct DJQuote: Codable, Identifiable {
    let id: Int
    let quote: String
    let author: String
}
