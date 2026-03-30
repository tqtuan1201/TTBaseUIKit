//
//  PostDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - PostDetailView
struct PostDetailView: View {
    let post: DJPost
    @StateObject private var viewModel = SocialFeedViewModel()
    
    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 16, bg: .clear) {
                // Post Content
                TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear, radius: 16) {
                    TTBaseSUIText(withBold: .HEADER, text: post.title, align: .leading)
                    TTBaseSUIText(withType: .TITLE, text: post.body, align: .leading, color: .secondary)
                    
                    // Tags
                    if !post.tags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 6) {
                                ForEach(post.tags, id: \.self) { tag in
                                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "#\(tag)", align: .center, color: .blue)
                                        .pAll(.horizontal, 10)
                                        .pAll(.vertical, 5)
                                        .background(Color.blue.opacity(0.08))
                                        .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    Divider()
                    
                    // Engagement Stats
                    TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
                        engagementStat(icon: "hand.thumbsup.fill", value: "\(post.reactions.likes)", label: "Likes", color: .blue)
                        engagementStat(icon: "hand.thumbsdown.fill", value: "\(post.reactions.dislikes)", label: "Dislikes", color: .red)
                        engagementStat(icon: "eye.fill", value: "\(post.views)", label: "Views", color: .green)
                    }
                }
                .pAll(16)
                .bg(byDef: Color.white)
                .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
                
                // Comments Section
                TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                    TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                        Image(systemName: "bubble.left.and.bubble.right.fill")
                            .foregroundColor(.blue)
                        TTBaseSUIText(withBold: .TITLE, text: "Comments", align: .leading)
                    }
                    
                    if viewModel.isLoadingComments {
                        ProgressView().maxWidth().pAll(20)
                    } else if viewModel.comments.isEmpty {
                        TTBaseSUIText(withType: .SUB_TITLE, text: "No comments yet", align: .center, color: .secondary)
                            .maxWidth()
                            .pAll(20)
                    } else {
                        ForEach(viewModel.comments) { comment in
                            commentCard(comment)
                        }
                    }
                }
            }
            .pAll(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle("Post Detail", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadComments(for: post.id) }
        }
    }
    
    private func engagementStat(icon: String, value: String, label: String, color: Color) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            Image(systemName: icon).font(.system(size: 20)).foregroundColor(color)
            TTBaseSUIText(withBold: .TITLE, text: value, align: .center)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }
        .maxWidth()
    }
    
    private func commentCard(_ comment: DJComment) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear, radius: 14) {
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                // Avatar
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: String(comment.user.fullName.prefix(2)).uppercased(),
                              align: .center, color: .white)
                    .frame(width: 30, height: 30)
                    .background(Color.green)
                    .clipShape(Circle())
                
                TTBaseSUIVStack(alignment: .leading, spacing: 1, bg: .clear) {
                    TTBaseSUIText(withBold: .SUB_TITLE, text: comment.user.fullName, align: .leading)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "@\(comment.user.username)", align: .leading, color: .secondary)
                }
                .maxWidth(alignment: .leading)
                
                TTBaseSUIHStack(alignment: .center, spacing: 3, bg: .clear) {
                    Image(systemName: "heart.fill").font(.system(size: 10)).foregroundColor(.pink)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "\(comment.likes)", align: .leading, color: .secondary)
                }
            }
            
            TTBaseSUIText(withType: .SUB_TITLE, text: comment.body, align: .leading, color: .primary)
        }
        .pAll(12)
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
}
