//
//  QuoteService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import TTBaseUIKit

// MARK: - QuoteEndpoint
enum QuoteEndpoint: TTAPIEndpoint {
    case list(limit: Int, skip: Int)
    case random
    case single(id: Int)
    
    var path: String {
        switch self {
        case .list:              return "/quotes"
        case .random:            return "/quotes/random"
        case .single(let id):    return "/quotes/\(id)"
        }
    }
    
    var method: TTHTTPMethod { .GET }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .list(let limit, let skip):
            return [URLQueryItem(name: "limit", value: "\(limit)"),
                    URLQueryItem(name: "skip", value: "\(skip)")]
        default: return nil
        }
    }
}

// MARK: - QuoteService
final class QuoteService: TTBaseAPIService {
    static let shared = QuoteService()
    private init() { super.init(baseURL: "https://dummyjson.com") }
    
    func fetchQuotes(limit: Int = 20, skip: Int = 0) async throws -> QuoteResponse {
        try await request(QuoteEndpoint.list(limit: limit, skip: skip))
    }
    
    func fetchRandom() async throws -> DJQuote {
        try await request(QuoteEndpoint.random)
    }
}
