//
//  QuotesViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - QuotesViewModel
@MainActor
final class QuotesViewModel: ObservableObject {
    @Published var quotes: [DJQuote] = []
    @Published var randomQuote: DJQuote?
    @Published var isLoading = false
    @Published var isLoadingMore = false
    @Published var errorMessage: String?
    
    private let service = QuoteService.shared
    private var currentSkip = 0
    private var totalQuotes = 0
    private let pageSize = 20
    
    var hasMore: Bool { currentSkip < totalQuotes }
    
    private let gradients: [[Color]] = [
        [.purple, .pink], [.blue, .blue.opacity(0.6)], [.orange, .red],
        [.green, .blue.opacity(0.8)], [.purple.opacity(0.8), .purple], [.pink, .orange],
        [.blue.opacity(0.8), .blue], [.red, .pink]
    ]
    
    func gradientFor(_ index: Int) -> [Color] {
        gradients[index % gradients.count]
    }
    
    func loadQuotes() async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil; currentSkip = 0
        do {
            async let quotesTask = service.fetchQuotes(limit: pageSize, skip: 0)
            async let randomTask = service.fetchRandom()
            let (r, random) = try await (quotesTask, randomTask)
            quotes = r.quotes; totalQuotes = r.total; currentSkip = r.quotes.count
            randomQuote = random
        } catch { errorMessage = error.localizedDescription }
        isLoading = false
    }
    
    func loadMore() async {
        guard !isLoadingMore, hasMore else { return }
        isLoadingMore = true
        do {
            let r = try await service.fetchQuotes(limit: pageSize, skip: currentSkip)
            quotes.append(contentsOf: r.quotes); totalQuotes = r.total; currentSkip += r.quotes.count
        } catch { errorMessage = error.localizedDescription }
        isLoadingMore = false
    }
    
    func refreshRandom() async {
        do { randomQuote = try await service.fetchRandom() } catch { }
    }
}
