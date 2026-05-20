//
//  LogDetailScreen.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogDetailScreen.swift
//  TTBaseUIKit
//

import SwiftUI
import UIKit

// MARK: - Log Detail Screen
@available(iOS 14.0, *)
public struct LogDetailScreen: View {

    @Environment(\.presentationMode) private var presentationMode
    @StateObject private var viewModel: LogDetailViewModel
    @State private var showShareSheet: Bool = false
    @State private var showCopiedToast: Bool = false
    @State private var copiedLabel: String = ""
    @State private var showActionSheet: Bool = false
    @State private var showJSONSearch: Bool = false
    @State private var showDetailOverview: Bool = false

    public init(log: LogViewModel) {
        _viewModel = StateObject(wrappedValue: LogDetailViewModel(log: log))
    }

    public var body: some View {
        VStack(spacing: 0) {
            // URL header
            urlHeader

            if showDetailOverview {
                detailOverview
            }

            // Tab selector
            tabSelector

            // JSON content
            jsonContent

            // Action toolbar
            actionToolbar
        }
        .background(LogViewTheme.background.edgesIgnoringSafeArea(.all))
        .preferredColorScheme(.dark)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Log Detail")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
            }
            ToolbarItem(placement: .navigationBarLeading) {
                closeButton
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 14) {
                    overviewButton
                    shareButton
                }
            }
        }
        .onAppear {
            configureNavBar()
        }
        .sheet(isPresented: $showShareSheet) {
            shareSheetView
        }
        .alert(isPresented: $showCopiedToast) {
            SwiftUI.Alert(
                title: SwiftUI.Text("Copied"),
                message: SwiftUI.Text("\(copiedLabel) copied to clipboard"),
                dismissButton: SwiftUI.Alert.Button.default(SwiftUI.Text("OK"))
            )
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Copy Options"),
                buttons: [
                    .default(Text("Copy JSON (raw)")) {
                        copyWithFeedback("JSON") {
                            copyToPasteboard(viewModel.rawJSON)
                        }
                    },
                    .default(Text("Copy JSON (pretty)")) {
                        copyWithFeedback("Pretty JSON") {
                            copyToPasteboard(viewModel.currentJSON)
                        }
                    },
                    .default(Text("Copy URL")) {
                        copyWithFeedback("URL") {
                            copyToPasteboard(viewModel.log.urlRequest)
                        }
                    },
                    .default(Text("Copy Endpoint")) {
                        copyWithFeedback("Endpoint") {
                            copyToPasteboard(viewModel.log.endpoint)
                        }
                    },
                    .default(Text("Copy cURL")) {
                        copyWithFeedback("cURL") {
                            copyToPasteboard(viewModel.cURLText)
                        }
                    },
                    .default(Text("Copy Status")) {
                        copyWithFeedback("Status") {
                            copyToPasteboard(viewModel.statusCopyText)
                        }
                    },
                    .cancel()
                ]
            )
        }
    }

    // MARK: - URL Header
    private var urlHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                // Method badge
                Text(viewModel.log.httpMethod.displayName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(LogViewTheme.background)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(LogViewTheme.methodColor(for: viewModel.log.httpMethod))
                    .cornerRadius(4)

                // Status badge
                if viewModel.log.statusCode > 0 {
                    HStack(spacing: 5) {
                        Image(systemName: viewModel.log.statusCategory.systemImageName)
                            .font(.system(size: 10, weight: .bold))
                        Text("\(viewModel.log.statusCode)")
                            .font(.system(size: 12, weight: .bold))
                    }
                    .foregroundColor(LogViewTheme.background)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(LogViewTheme.statusColor(for: viewModel.log.statusCategory))
                    .cornerRadius(4)
                }

                // Time
                Spacer()
                Text(viewModel.log.formattedTime)
                    .font(.system(size: 11))
                    .foregroundColor(LogViewTheme.secondaryText)
            }

            // URL
            Text(viewModel.log.urlRequest)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(LogViewTheme.primaryText)
                .lineLimit(2)
                .truncationMode(.middle)

            Text(viewModel.log.serviceName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(LogViewTheme.secondaryText)
                .lineLimit(1)
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 10)
        .background(LogViewTheme.surface)
        .overlay(
            Rectangle()
                .fill(LogViewTheme.subtleBorder)
                .frame(height: 1),
            alignment: .bottom
        )
        .onTapGesture {
            copyWithFeedback("URL") {
                copyToPasteboard(viewModel.log.urlRequest)
            }
        }
    }

    // MARK: - Detail Overview
    private var detailOverview: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                LogDetailMetricView(
                    title: "Status",
                    value: viewModel.log.statusDisplayText,
                    icon: viewModel.log.statusCategory.systemImageName,
                    tint: Color(viewModel.log.statusColor)
                )
                LogDetailMetricView(
                    title: "Request",
                    value: viewModel.requestSummary,
                    icon: "arrow.up.doc.fill",
                    tint: LogViewTheme.accent
                )
            }

            HStack(spacing: 8) {
                LogDetailMetricView(
                    title: "Response",
                    value: viewModel.responseSummary,
                    icon: "arrow.down.doc.fill",
                    tint: LogViewTheme.purple
                )
                LogDetailMetricView(
                    title: "Logged",
                    value: viewModel.log.formattedDateTime,
                    icon: "clock.fill",
                    tint: LogViewTheme.secondaryText
                )
            }
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 8)
        .background(LogViewTheme.background)
    }

    // MARK: - Tab Selector
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(LogDetailTab.allCases, id: \.rawValue) { tab in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        viewModel.selectedTab = tab
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(tab.title)
                            .font(.system(size: 14, weight: viewModel.selectedTab == tab ? .bold : .medium))
                            .foregroundColor(
                                viewModel.selectedTab == tab
                                    ? LogViewTheme.accent
                                    : LogViewTheme.secondaryText
                            )
                        Rectangle()
                            .fill(
                                viewModel.selectedTab == tab
                                    ? LogViewTheme.accent
                                    : Color.clear
                            )
                            .frame(height: 2)
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.top, 4)
        .background(LogViewTheme.surface)
    }

    // MARK: - JSON Content
    private var jsonContent: some View {
        VStack(spacing: 0) {
            // Search toggle
            HStack {
                Text(viewModel.selectedTab == .request ? "REQUEST" : "RESPONSE")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(LogViewTheme.secondaryText)

                Spacer()

                Button(action: {
                    showJSONSearch.toggle()
                }) {
                    Image(systemName: showJSONSearch ? "magnifyingglass.circle.fill" : "magnifyingglass.circle")
                        .foregroundColor(showJSONSearch ? LogViewTheme.accent : LogViewTheme.secondaryText)
                }
            }
            .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
            .padding(.vertical, 6)
            .background(LogViewTheme.background)

            // Search field
            if showJSONSearch {
                HStack(spacing: 8) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(LogViewTheme.secondaryText)
                        .frame(width: 14, height: 14)

                    TextField("Search in JSON...", text: $viewModel.jsonSearchText)
                        .font(.system(size: 13))
                        .foregroundColor(LogViewTheme.primaryText)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)

                    if !viewModel.jsonSearchText.isEmpty {
                        Button(action: { viewModel.jsonSearchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(LogViewTheme.secondaryText)
                        }
                    }
                }
                .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
                .padding(.vertical, 8)
                .background(LogViewTheme.elevatedSurface)
                .overlay(
                    Rectangle()
                        .fill(LogViewTheme.subtleBorder)
                        .frame(height: 1),
                    alignment: .bottom
                )
            }

            // JSON viewer
            JSONTextView(
                json: viewModel.currentJSON,
                searchText: viewModel.jsonSearchText
            )
            .frame(maxHeight: .infinity)
        }
    }

    // MARK: - Action Toolbar
    private var actionToolbar: some View {
        HStack(spacing: 10) {
            // Copy button
            Button(action: {
                showActionSheet = true
            }) {
                toolbarItem(icon: "doc.on.doc", title: "Copy", color: LogViewTheme.secondaryText)
            }

            Spacer()

            Button(action: {
                copyWithFeedback("cURL") {
                    copyToPasteboard(viewModel.cURLText)
                }
            }) {
                toolbarItem(icon: "chevron.left.slash.chevron.right", title: "cURL", color: LogViewTheme.secondaryText)
            }

            Spacer()

            Button(action: {
                showShareSheet = true
            }) {
                toolbarItem(icon: "square.and.arrow.up", title: "Share", color: LogViewTheme.secondaryText)
            }

            Spacer()

            Button(action: {
                shareAll()
            }) {
                toolbarItem(icon: "square.and.arrow.up.fill", title: "All", color: LogViewTheme.accent)
            }
        }
        .padding(.horizontal, CGFloat(TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF))
        .padding(.vertical, 10)
        .background(LogViewTheme.surface)
        .overlay(
            Rectangle()
                .fill(LogViewTheme.subtleBorder)
                .frame(height: 1),
            alignment: .top
        )
    }

    private func toolbarItem(icon: String, title: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
            Text(title)
                .font(.system(size: 10, weight: .medium))
        }
        .foregroundColor(color)
        .frame(minWidth: 54)
    }

    // MARK: - Nav Bar Buttons
    private var closeButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                Text("Close")
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundColor(.white)
        }
    }

    private var shareButton: some View {
        Button(action: {
            showShareSheet = true
        }) {
            Image(systemName: "square.and.arrow.up")
                .font(.system(size: 14))
                .foregroundColor(.white)
        }
    }

    private var overviewButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.16)) {
                showDetailOverview.toggle()
            }
        }) {
            Image(systemName: showDetailOverview ? "info.circle.fill" : "info.circle")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(showDetailOverview ? LogViewTheme.accent : .white)
        }
    }

    // MARK: - Share Sheet
    private var shareSheetView: some View {
        ActivityViewControllerWrapper(activityItems: [viewModel.shareText])
    }

    // MARK: - Helpers
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

    private func copyWithFeedback(_ label: String, action: @escaping () -> Void) {
        action()
        copiedLabel = label
        showCopiedToast = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showCopiedToast = false
        }
    }

    private func copyToPasteboard(_ value: String) {
        UIPasteboard.general.string = value
    }

    private func shareAll() {
        let vc = UIActivityViewController(
            activityItems: [viewModel.allShareText],
            applicationActivities: nil
        )
        if let topVC = UIApplication.topViewController() {
            vc.popoverPresentationController?.sourceView = topVC.view
            vc.popoverPresentationController?.sourceRect = CGRect(
                x: topVC.view.bounds.midX,
                y: topVC.view.bounds.midY,
                width: 0,
                height: 0
            )
            vc.popoverPresentationController?.permittedArrowDirections = []
            topVC.present(vc, animated: true)
        }
    }
}

// MARK: - Log Detail Metric View
@available(iOS 14.0, *)
private struct LogDetailMetricView: View {

    let title: String
    let value: String
    let icon: String
    let tint: Color

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(tint)
                .frame(width: 18, height: 18)

            VStack(alignment: .leading, spacing: 2) {
                Text(title.uppercased())
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundColor(LogViewTheme.secondaryText)
                Text(value)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(LogViewTheme.primaryText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 9)
        .padding(.vertical, 8)
        .background(LogViewTheme.elevatedSurface)
        .cornerRadius(7)
        .overlay(
            RoundedRectangle(cornerRadius: 7)
                .stroke(LogViewTheme.border, lineWidth: 1)
        )
    }
}

// MARK: - Activity View Controller Wrapper
@available(iOS 14.0, *)
public struct ActivityViewControllerWrapper: UIViewControllerRepresentable {
    public let activityItems: [Any]

    public func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
    }

    public func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// MARK: - Log Detail Hosting Controller
@available(iOS 14.0, *)
public final class LogDetailHostingController: UIHostingController<AnyView> {

    public init(log: LogViewModel) {
        super.init(
            rootView: AnyView(
                NavigationView {
                    LogDetailScreen(log: log)
                }
                .navigationViewStyle(StackNavigationViewStyle())
                .preferredColorScheme(.dark)
            )
        )
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = LogViewTheme.uiBackground
    }

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}
