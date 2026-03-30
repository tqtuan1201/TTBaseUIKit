//
//  TodoManagerView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - TodoManagerView
struct TodoManagerView: View {
    @StateObject private var viewModel = TodoViewModel()
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading && viewModel.todos.isEmpty {
                skeletonView
            } else {
                contentView
            }
        }
        .navigationBarTitle("Todo Manager", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadTodos() }
        }
    }
    
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                progressCard
                filterBar
                
                ForEach(viewModel.filteredTodos) { todo in
                    todoRow(todo)
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
    
    private var progressCard: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 14, bg: .clear) {
            TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
                TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                    TTBaseSUIText(withBold: .HEADER, text: "\(Int(viewModel.progress * 100))%", align: .leading, color: .white)
                    TTBaseSUIText(withType: .SUB_TITLE, text: "Completed", align: .leading, color: .white.opacity(0.7))
                }
                Spacer()
                TTBaseSUIVStack(alignment: .trailing, spacing: 4, bg: .clear) {
                    TTBaseSUIText(withBold: .TITLE, text: "\(viewModel.completedCount)/\(viewModel.todos.count)", align: .trailing, color: .white)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: "tasks done", align: .trailing, color: .white.opacity(0.7))
                }
            }
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 6).fill(Color.white.opacity(0.2)).frame(height: 10)
                    RoundedRectangle(cornerRadius: 6).fill(Color.white)
                        .frame(width: max(0, geo.size.width * viewModel.progress), height: 10)
                        .animation(.spring(response: 0.6), value: viewModel.progress)
                }
            }.frame(height: 10)
            TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
                quickStatPill(icon: "checkmark.circle.fill", value: "\(viewModel.completedCount)", label: "Done", color: .white)
                quickStatPill(icon: "circle", value: "\(viewModel.pendingCount)", label: "Pending", color: .white.opacity(0.7))
            }
        }
        .pAll(20)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(20)
        .baseShadow(color: .blue.opacity(0.8).opacity(0.3), radius: 8, x: 0, y: 4)
    }
    
    private func quickStatPill(icon: String, value: String, label: String, color: Color) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
            Image(systemName: icon).font(.system(size: 12)).foregroundColor(color)
            TTBaseSUIText(withBold: .SUB_SUB_TILE, text: value, align: .center, color: color)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: color.opacity(0.7))
        }
    }
    
    private var filterBar: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
            ForEach(TodoViewModel.FilterMode.allCases, id: \.rawValue) { mode in
                let isSelected = viewModel.filterMode == mode
                TTBaseSUIText(withBold: .SUB_SUB_TILE, text: mode.rawValue, align: .center,
                              color: isSelected ? .white : .primary)
                    .pAll(.horizontal, 16).pAll(.vertical, 8)
                    .background(isSelected ? Color.blue.opacity(0.8) : Color(.systemBackground))
                    .cornerRadius(20)
                    .baseShadow(color: .black.opacity(0.04), radius: 2, x: 0, y: 1)
                    .onTapGesture { withAnimation(.spring(response: 0.3)) { viewModel.filterMode = mode } }
            }
            Spacer()
        }
    }
    
    private func todoRow(_ todo: DJTodo) -> some View {
        TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
            Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle")
                .font(.system(size: 22)).foregroundColor(todo.completed ? .green : .secondary)
            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                TTBaseSUIText(withType: .TITLE, text: todo.todo, align: .leading, color: todo.completed ? .secondary : .primary)
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "User #\(todo.userId)", align: .leading, color: .secondary)
            }.maxWidth(alignment: .leading)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: todo.completed ? "Done" : "Todo",
                          align: .center, color: todo.completed ? .green : .orange)
                .pAll(.horizontal, 8).pAll(.vertical, 4)
                .background((todo.completed ? Color.green : Color.orange).opacity(0.1)).cornerRadius(8)
        }
        .pAll(14).cornerRadius(14).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 12, bg: .clear) {
                RoundedRectangle(cornerRadius: 20).fill(Color(.systemGray5)).frame(height: 160)
                    .skeleton(active: true, isShimmering: true, isLight: true)
                ForEach(0..<8, id: \.self) { _ in
                    TTBaseSUIHStack(alignment: .center, spacing: 12, bg: Color(.systemBackground)) {
                        Circle().fill(Color(.systemGray5)).frame(width: 22, height: 22)
                        RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 16)
                    }.pAll(14).cornerRadius(14).bg(byDef: Color.white).skeleton(active: true, isShimmering: true, isLight: true)
                }
            }.pAll(16)
        }
    }
}
