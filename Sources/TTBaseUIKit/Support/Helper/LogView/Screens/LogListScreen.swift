//
//  LogListScreen.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogListScreen.swift
//  TTBaseUIKit
//

import SwiftUI
import UIKit

// MARK: - Log List Screen
@available(iOS 14.0, *)
public struct LogListScreen: View {

    @StateObject private var viewModel = LogListViewModel()
    @State private var showResetConfirmation: Bool = false
    @State private var showInspectorSummary: Bool = false
    @State private var showFilters: Bool = true
    @State private var isCompactRows: Bool = false
    @State private var showShareSheet: Bool = false

    public init() {}

    public var body: some View {
        NavigationView {
            contentView
                .navigationBarTitle("Network Logs", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        closeButton
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack(spacing: 14) {
                            densityButton
                            filterButton
                            shareButton
                            sortButton
                            resetButton
                            refreshButton
                        }
                    }
                }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .preferredColorScheme(.dark)
        .onAppear {
            configureNavBar()
            viewModel.loadLogs()
        }
        .actionSheet(isPresented: $showResetConfirmation) {
            ActionSheet(
                title: Text("Clear API Logs?"),
                message: Text("This removes all captured logs from the debug viewer."),
                buttons: [
                    .destructive(Text("Clear Logs")) {
                        viewModel.resetAllLogs()
                    },
                    .cancel()
                ]
            )
        }
        .sheet(isPresented: $showShareSheet) {
            ActivityViewControllerWrapper(activityItems: [
                viewModel.exportTitle,
                viewModel.exportText
            ])
        }
    }

    private var contentView: some View {
        VStack(spacing: 0) {
            compactHeader

            if showInspectorSummary {
                summaryHeader
            }

            // Filter bar
            if showFilters {
                FilterBarView(
                    selectedMethod: $viewModel.selectedMethod,
                    selectedStatusCategory: $viewModel.selectedStatusCategory,
                    searchText: $viewModel.searchText
                )
            }

            // Log list
            if viewModel.filteredLogs.isEmpty {
                emptyStateView
            } else {
                logList
            }

            // Footer
            footerView
        }
        .background(LogViewTheme.background.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Log List
    private var logList: some View {
        ScrollView {
            LazyVStack(spacing: isCompactRows ? 6 : 10) {
                ForEach(viewModel.filteredLogs, id: \.stableID) { log in
                    LogRowView(log: log, isCompact: isCompactRows) {
                        presentDetail(log: log)
                    }
                }
            }
            .padding(.horizontal, CGFloat(isCompactRows ? 10 : TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
            .padding(.vertical, isCompactRows ? 6 : 8)
        }
        .background(LogViewTheme.background)
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(LogViewTheme.mutedText)
            Text(emptyStateTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(LogViewTheme.primaryText)
            Text(emptyStateSubtitle)
                .font(.system(size: 13))
                .foregroundColor(LogViewTheme.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            if viewModel.hasActiveFilter {
                Button(action: {
                    viewModel.clearFilters()
                }) {
                    Text("Clear Filters")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(LogViewTheme.background)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(LogViewTheme.accent)
                        .cornerRadius(7)
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LogViewTheme.background)
    }

    private var emptyStateTitle: String {
        viewModel.hasActiveFilter ? "No matching logs found" : "No API logs yet"
    }

    private var emptyStateSubtitle: String {
        viewModel.hasActiveFilter
            ? "Try another method, status class, endpoint, status code, request, or response keyword."
            : "Captured API traffic will appear here after the app sends a request."
    }

    // MARK: - Compact Header
    private var compactHeader: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text("\(viewModel.filteredCount)")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(LogViewTheme.primaryText)
                    Text(viewModel.hasActiveFilter ? "visible" : "logs")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(LogViewTheme.secondaryText)
                    if viewModel.hasActiveFilter {
                        Text("/ \(viewModel.totalCount)")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(LogViewTheme.mutedText)
                    }
                }
                Text(compactHeaderSubtitle)
                    .font(.system(size: 11))
                    .foregroundColor(LogViewTheme.mutedText)
                    .lineLimit(1)
            }

            Spacer(minLength: 8)

            Button(action: {
                withAnimation(.easeInOut(duration: 0.16)) {
                    showInspectorSummary.toggle()
                }
            }) {
                HStack(spacing: 5) {
                    Image(systemName: showInspectorSummary ? "chart.bar.fill" : "chart.bar")
                        .font(.system(size: 11, weight: .semibold))
                    Text(viewModel.issueCount > 0 ? "\(viewModel.issueCount)" : "OK")
                        .font(.system(size: 12, weight: .bold))
                }
                .foregroundColor(viewModel.issueCount > 0 ? LogViewTheme.warning : LogViewTheme.success)
                .padding(.horizontal, 9)
                .padding(.vertical, 6)
                .background((viewModel.issueCount > 0 ? LogViewTheme.warning : LogViewTheme.success).opacity(0.14))
                .cornerRadius(7)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 8)
        .background(LogViewTheme.surface)
        .overlay(
            Rectangle()
                .fill(LogViewTheme.subtleBorder)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private var compactHeaderSubtitle: String {
        if viewModel.hasActiveFilter {
            return "Filtered by method, status, or search keyword"
        }
        return viewModel.sortAscending ? "Oldest first, compact inspector mode" : "Newest first, compact inspector mode"
    }

    // MARK: - Summary
    private var summaryHeader: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            HStack(alignment: .center, spacing: 10) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Debug timeline")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(LogViewTheme.primaryText)
                    Text("\(viewModel.totalCount) captured logs")
                        .font(.system(size: 12))
                        .foregroundColor(LogViewTheme.secondaryText)
                }
                Spacer()
                healthBadge
            }

            HStack(spacing: 8) {
                SummaryStatView(
                    title: "Success",
                    value: "\(viewModel.successCount)",
                    icon: "checkmark.seal.fill",
                    tint: LogViewTheme.success
                )
                SummaryStatView(
                    title: "4xx",
                    value: "\(viewModel.clientErrorCount)",
                    icon: "exclamationmark.triangle.fill",
                    tint: LogViewTheme.warning
                )
                SummaryStatView(
                    title: "5xx",
                    value: "\(viewModel.serverErrorCount)",
                    icon: "xmark.octagon.fill",
                    tint: LogViewTheme.danger
                )
                SummaryStatView(
                    title: "Unknown",
                    value: "\(viewModel.unknownCount)",
                    icon: "questionmark.circle.fill",
                    tint: LogViewTheme.mutedText
                )
            }
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(LogViewTheme.surface)
        .overlay(
            Rectangle()
                .fill(LogViewTheme.subtleBorder)
                .frame(height: 1),
            alignment: .bottom
        )
    }

    private var healthBadge: some View {
        let hasIssues = viewModel.issueCount > 0
        return HStack(spacing: 5) {
            Image(systemName: hasIssues ? "bolt.horizontal.circle.fill" : "checkmark.circle.fill")
                .font(.system(size: 12, weight: .semibold))
            Text(hasIssues ? "\(viewModel.issueCount) issues" : "Healthy")
                .font(.system(size: 12, weight: .semibold))
        }
        .foregroundColor(hasIssues ? LogViewTheme.warning : LogViewTheme.success)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background((hasIssues ? LogViewTheme.warning : LogViewTheme.success).opacity(0.14))
        .cornerRadius(6)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke((hasIssues ? LogViewTheme.warning : LogViewTheme.success).opacity(0.35), lineWidth: 1)
        )
    }

    // MARK: - Footer
    private var footerView: some View {
        HStack {
            if viewModel.hasActiveFilter {
                Text("\(viewModel.filteredCount) of \(viewModel.totalCount) logs")
                    .font(.system(size: 12))
                    .foregroundColor(LogViewTheme.secondaryText)
            } else {
                Text("Total: \(viewModel.totalCount) logs")
                    .font(.system(size: 12))
                    .foregroundColor(LogViewTheme.secondaryText)
            }
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: viewModel.sortAscending ? "arrow.up" : "arrow.down")
                    .font(.system(size: 10, weight: .bold))
                Text(viewModel.sortAscending ? "Oldest first" : "Newest first")
            }
                .font(.system(size: 12))
                .foregroundColor(LogViewTheme.secondaryText)
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 8)
        .background(LogViewTheme.surface)
        .overlay(
            Rectangle()
                .fill(LogViewTheme.subtleBorder)
                .frame(height: 1),
            alignment: .top
        )
    }

    // MARK: - Toolbar
    private var closeButton: some View {
        Button(action: {
            UIApplication.topViewController()?.dismiss(animated: true)
        }) {
            Image(systemName: "xmark")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private var refreshButton: some View {
        Button(action: { viewModel.refreshLogs() }) {
            Image(systemName: "arrow.clockwise")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private var filterButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.16)) {
                showFilters.toggle()
            }
        }) {
            Image(systemName: showFilters ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(showFilters || viewModel.hasActiveFilter ? LogViewTheme.accent : .white)
        }
    }

    private var densityButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.16)) {
                isCompactRows.toggle()
            }
        }) {
            Image(systemName: isCompactRows ? "rectangle.compress.vertical" : "rectangle.expand.vertical")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(LogViewTheme.primaryText)
        }
    }

    private var shareButton: some View {
        Button(action: {
            guard !viewModel.isEmpty else { return }
            showShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(viewModel.isEmpty ? LogViewTheme.primaryText.opacity(0.35) : .white)
        }
        .disabled(viewModel.isEmpty)
    }

    private var sortButton: some View {
        Button(action: { viewModel.toggleSortOrder() }) {
            Image(systemName: viewModel.sortAscending ? "arrow.up.arrow.down.circle.fill" : "arrow.up.arrow.down.circle")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
        }
    }

    private var resetButton: some View {
        Button(action: {
            guard !viewModel.isEmpty else { return }
            showResetConfirmation = true
        }) {
            Image(systemName: "trash")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(viewModel.isEmpty ? LogViewTheme.primaryText.opacity(0.35) : .white)
        }
        .disabled(viewModel.isEmpty)
    }

    // MARK: - Navigation
    private func presentDetail(log: LogViewModel) {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }),
              var topVC = window.rootViewController else { return }

        while let presented = topVC.presentedViewController {
            topVC = presented
        }

        let detailVC = LogDetailHostingController(log: log)
        detailVC.modalPresentationStyle = .fullScreen
        topVC.present(detailVC, animated: true)
    }

    private func configureNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = LogViewTheme.uiNavigation
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
}

// MARK: - Summary Stat View
@available(iOS 14.0, *)
private struct SummaryStatView: View {

    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Image(systemName: icon)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(tint)
                Text(title)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(LogViewTheme.secondaryText)
                    .lineLimit(1)
            }
            Text(value)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(LogViewTheme.primaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
        .padding(.vertical, 9)
        .background(LogViewTheme.elevatedSurface)
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(tint.opacity(0.28), lineWidth: 1)
        )
    }
}
