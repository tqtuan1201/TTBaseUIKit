//
//  SocialFeedView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - SocialFeedView
struct SocialFeedView: View {
    @StateObject private var viewModel = SocialFeedViewModel()
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading && viewModel.posts.isEmpty {
                skeletonView
            } else {
                contentView
            }
        }
        .navigationBarTitle("Social Feed", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadPosts() }
        }
    }
    
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField("Search posts...", text: $viewModel.searchText).font(.system(size: 15))
                }
                .pAll(12).cornerRadius(12).bg(byDef: Color.white)
                
                ForEach(viewModel.filteredPosts) { post in
                    NavigationLink(destination: PostDetailView(post: post)) {
                        postCard(post)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if viewModel.hasMore {
                    TTBaseSUIButton(type: .BORDER, title: "Load More") {
                        Task { await viewModel.loadMore() }
                    }.maxWidth()
                }
            }
            .pAll(16)
        }
    }
    
    private func postCard(_ post: DJPost) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear, radius: 16) {
            TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                TTBaseSUIText(withBold: .SUB_TITLE, text: "U\(post.userId)", align: .center, color: .white)
                    .frame(width: 36, height: 36)
                    .background(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                    TTBaseSUIText(withBold: .SUB_TITLE, text: "User #\(post.userId)", align: .leading)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Published", align: .leading, color: .secondary)
                }.maxWidth(alignment: .leading)
            }
            TTBaseSUIText(withBold: .TITLE, text: post.title, align: .leading)
            TTBaseSUIText(withType: .SUB_TITLE, text: post.body, align: .leading, color: .secondary).lineLimit(3)
            
            if !post.tags.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 6) {
                        ForEach(post.tags, id: \.self) { tag in
                            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "#\(tag)", align: .center, color: .blue)
                                .pAll(.horizontal, 8).pAll(.vertical, 4)
                                .background(Color.blue.opacity(0.08)).cornerRadius(8)
                        }
                    }
                }
            }
            
            Divider()
            TTBaseSUIHStack(alignment: .center, spacing: 16, bg: .clear) {
                metricItem(icon: "hand.thumbsup.fill", value: "\(post.reactions.likes)", color: .blue)
                metricItem(icon: "hand.thumbsdown.fill", value: "\(post.reactions.dislikes)", color: .red)
                metricItem(icon: "eye.fill", value: "\(post.views)", color: .secondary)
                Spacer()
                Image(systemName: "bubble.right").font(.system(size: 14)).foregroundColor(.secondary)
            }
        }
        .pAll(14).cornerRadius(16).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private func metricItem(icon: String, value: String, color: Color) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
            Image(systemName: icon).font(.system(size: 13)).foregroundColor(color)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: value, align: .leading, color: .secondary)
        }
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                ForEach(0..<5, id: \.self) { _ in
                    TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: Color(.systemBackground), radius: 16) {
                        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                            Circle().fill(Color(.systemGray5)).frame(width: 36, height: 36)
                            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                                RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 14).frame(maxWidth: 100)
                                RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 10).frame(maxWidth: 60)
                            }
                        }
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 18)
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 50)
                    }.pAll(14).bg(byDef: Color.white).skeleton(active: true, isShimmering: true, isLight: true)
                }
            }.pAll(16)
        }
    }
}
