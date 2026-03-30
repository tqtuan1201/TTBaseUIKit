//
//  UserDirectoryView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - UserDirectoryView
struct UserDirectoryView: View {
    
    @StateObject private var viewModel = UserDirectoryViewModel()
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading && viewModel.users.isEmpty {
                skeletonView
            } else {
                contentView
            }
        }
        .navigationBarTitle("User Directory", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadUsers() }
        }
    }
    
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                searchBar
                statsBar
                
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(destination: UserProfileView(user: user)) {
                        userCard(user)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                if viewModel.hasMore && viewModel.searchText.isEmpty { loadMoreButton }
            }
            .pAll(16)
        }
    }
    
    private var searchBar: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
            Image(systemName: "magnifyingglass").foregroundColor(.secondary)
            TextField("Search by name, email, company...", text: $viewModel.searchText).font(.system(size: 15))
        }
        .pAll(12).cornerRadius(12).bg(byDef: Color.white)
    }
    
    private var statsBar: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
            miniStat(icon: "person.fill", value: "\(viewModel.filteredUsers.count)", label: "Showing", color: .blue)
            Divider().frame(height: 30)
            miniStat(icon: "person.3.fill", value: "\(viewModel.users.count)", label: "Loaded", color: .green)
        }
        .cornerRadius(12).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
    
    private func miniStat(icon: String, value: String, label: String, color: Color) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
            Image(systemName: icon).font(.system(size: 14)).foregroundColor(color)
            TTBaseSUIText(withBold: .SUB_TITLE, text: value, align: .center)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }.maxWidth().pAll(10)
    }
    
    private func userCard(_ user: DJUser) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 12, bg: Color(.clear)) {
            TTBaseSUIAsyncImage(urlString: user.image, type: .CIRCLE).sizeSquare(width: 56)
            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                TTBaseSUIText(withBold: .TITLE, text: user.fullName, align: .leading)
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "building.2").font(.system(size: 10)).foregroundColor(.purple)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: user.company.title, align: .leading, color: .secondary).lineLimit(1)
                }
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "mappin.circle.fill").font(.system(size: 10)).foregroundColor(.orange)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: user.address.formatted, align: .leading, color: .secondary).lineLimit(1)
                }
            }.maxWidth(alignment: .leading)
            TTBaseSUIText(withBold: .SUB_SUB_TILE, text: "\(user.age)y", align: .center, color: .blue)
                .pAll(.horizontal, 8).pAll(.vertical, 4).background(Color.blue.opacity(0.1)).cornerRadius(8)
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.secondary)
        }
        .pAll(14).cornerRadius(14).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                ForEach(0..<8, id: \.self) { _ in
                    TTBaseSUIHStack(alignment: .center, spacing: 12, bg: Color(.systemBackground)) {
                        Circle().fill(Color(.systemGray5)).frame(width: 56, height: 56)
                        TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 16).frame(maxWidth: 150)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 200)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 120)
                        }.maxWidth(alignment: .leading)
                    }.pAll(14).cornerRadius(14).bg(byDef: Color.white).skeleton(active: true, isShimmering: true, isLight: true)
                }
            }.pAll(16)
        }
    }
    
    private var loadMoreButton: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
            if viewModel.isLoadingMore {
                ProgressView()
                TTBaseSUIText(withType: .SUB_TITLE, text: "Loading...", align: .center, color: .secondary)
            } else {
                TTBaseSUIButton(type: .BORDER, title: "Load More Users") { Task { await viewModel.loadMore() } }
            }
        }.maxWidth().pVertical(8)
    }
}
