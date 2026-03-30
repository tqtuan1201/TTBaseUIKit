//
//  QuotesWallView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - QuotesWallView
struct QuotesWallView: View {
    @StateObject private var viewModel = QuotesViewModel()
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading && viewModel.quotes.isEmpty {
                skeletonView
            } else {
                contentView
            }
        }
        .navigationBarTitle("Quotes Wall", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadQuotes() }
        }
    }
    
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 14, bg: .clear) {
                if let random = viewModel.randomQuote { featuredQuote(random) }
                
                ForEach(Array(viewModel.quotes.enumerated()), id: \.element.id) { idx, quote in
                    quoteCard(quote, index: idx)
                }
                
                if viewModel.hasMore {
                    TTBaseSUIButton(type: .BORDER, title: "Load More Quotes") {
                        Task { await viewModel.loadMore() }
                    }.maxWidth()
                }
            }
            .pAll(16)
        }
    }
    
    private func featuredQuote(_ quote: DJQuote) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 16, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: "sparkles").foregroundColor(.yellow)
                TTBaseSUIText(withBold: .SUB_TITLE, text: "QUOTE OF THE MOMENT", align: .leading, color: .white.opacity(0.8))
                Spacer()
                Button(action: { Task { await viewModel.refreshRandom() } }) {
                    Image(systemName: "arrow.clockwise").font(.system(size: 16, weight: .semibold)).foregroundColor(.white.opacity(0.7))
                }
            }
            TTBaseSUIText(withType: .HEADER, text: "\"\(quote.quote)\"", align: .leading, color: .white)
            TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                Rectangle().fill(Color.white.opacity(0.5)).frame(width: 20, height: 2)
                TTBaseSUIText(withBold: .SUB_TITLE, text: quote.author, align: .leading, color: .white.opacity(0.9))
            }
        }
        .pAll(20)
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .baseShadow(color: .purple.opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private func quoteCard(_ quote: DJQuote, index: Int) -> some View {
        let colors = viewModel.gradientFor(index)
        return TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear, radius: 16) {
            TTBaseSUIHStack(alignment: .top, spacing: 8, bg: .clear) {
                Image(systemName: "quote.opening").font(.system(size: 20)).foregroundColor(colors[0].opacity(0.5))
                Spacer()
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "#\(quote.id)", align: .trailing, color: .secondary)
            }
            TTBaseSUIText(withType: .TITLE, text: quote.quote, align: .leading)
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: String(quote.author.prefix(1)), align: .center, color: .white)
                    .frame(width: 28, height: 28)
                    .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                TTBaseSUIText(withBold: .SUB_TITLE, text: quote.author, align: .leading, color: .secondary)
                Spacer()
                Image(systemName: "heart").font(.system(size: 14)).foregroundColor(colors[0].opacity(0.5))
            }
        }
        .pAll(16).cornerRadius(16).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 14, bg: .clear) {
                RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray5)).frame(height: 180)
                    .skeleton(active: true, isShimmering: true, isLight: true)
                ForEach(0..<4, id: \.self) { _ in
                    TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: Color(.systemBackground), radius: 16) {
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 20)
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 60)
                        TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                            Circle().fill(Color(.systemGray5)).frame(width: 28, height: 28)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 14).frame(maxWidth: 120)
                        }
                    }.pAll(16).bg(byDef: Color.white).skeleton(active: true, isShimmering: true, isLight: true)
                }
            }.pAll(16)
        }
    }
}
