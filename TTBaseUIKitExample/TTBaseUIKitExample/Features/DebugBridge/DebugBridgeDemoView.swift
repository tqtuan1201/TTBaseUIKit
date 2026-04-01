//
//  DebugBridgeDemoView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 31/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - Models
struct JSONPlaceholderPost: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

struct JSONPlaceholderComment: Codable, Identifiable {
    let postId: Int
    let id: Int
    let name: String
    let email: String
    let body: String
}

struct JSONPlaceholderUser: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
}

struct JSONPlaceholderTodo: Codable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

// MARK: - Log Entry
struct DebugLogEntry: Identifiable {
    let id = UUID()
    let timestamp: Date
    let type: LogType
    let title: String
    let detail: String
    let statusCode: Int?
    let method: String?
    
    enum LogType {
        case api
        case console
        
        var icon: String {
            switch self {
            case .api: return "🌐"
            case .console: return "📋"
            }
        }
        
        var color: Color {
            switch self {
            case .api: return .blue
            case .console: return .green
            }
        }
    }
}

// MARK: - ViewModel
class DebugBridgeDemoViewModel: ObservableObject {
    @Published var logs: [DebugLogEntry] = []
    @Published var isLoading = false
    @Published var bridgeStatus: String = "Checking..."
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    
    init() {
        updateBridgeStatus()
    }
    
    func updateBridgeStatus() {
        let state = TTDebugBridge.shared.state
        bridgeStatus = state.rawValue
    }
    
    // MARK: - API Calls
    
    func fetchPosts() {
        let endpoint = "\(baseURL)/posts?_limit=5"
        sendConsoleLog(message: "📡 Fetching posts from JSONPlaceholder...", level: "info")
        performAPICall(method: "GET", url: endpoint, title: "GET /posts")
    }
    
    func fetchComments() {
        let endpoint = "\(baseURL)/posts/1/comments"
        sendConsoleLog(message: "📡 Fetching comments for post #1...", level: "info")
        performAPICall(method: "GET", url: endpoint, title: "GET /posts/1/comments")
    }
    
    func fetchUsers() {
        let endpoint = "\(baseURL)/users"
        sendConsoleLog(message: "📡 Fetching user directory...", level: "info")
        performAPICall(method: "GET", url: endpoint, title: "GET /users")
    }
    
    func fetchTodos() {
        let endpoint = "\(baseURL)/todos?_limit=10"
        sendConsoleLog(message: "📡 Fetching todo list...", level: "info")
        performAPICall(method: "GET", url: endpoint, title: "GET /todos")
    }
    
    func createPost() {
        let endpoint = "\(baseURL)/posts"
        let body: [String: Any] = [
            "title": "TTBaseUIKit Debug Bridge Test",
            "body": "This post was created via TTDebugBridge demo to test API logging on TTBDebugPlus macOS app.",
            "userId": 1
        ]
        sendConsoleLog(message: "📝 Creating a new post via POST request...", level: "info")
        performAPICall(method: "POST", url: endpoint, title: "POST /posts", requestBody: body)
    }
    
    func updatePost() {
        let endpoint = "\(baseURL)/posts/1"
        let body: [String: Any] = [
            "id": 1,
            "title": "Updated via TTDebugBridge",
            "body": "This post was updated via PUT request from TTBaseUIKitExample.",
            "userId": 1
        ]
        sendConsoleLog(message: "✏️ Updating post #1 via PUT request...", level: "info")
        performAPICall(method: "PUT", url: endpoint, title: "PUT /posts/1", requestBody: body)
    }
    
    func deletePost() {
        let endpoint = "\(baseURL)/posts/1"
        sendConsoleLog(message: "🗑 Deleting post #1 via DELETE request...", level: "warning")
        performAPICall(method: "DELETE", url: endpoint, title: "DELETE /posts/1")
    }
    
    func fetchSinglePost() {
        let postId = Int.random(in: 1...100)
        let endpoint = "\(baseURL)/posts/\(postId)"
        sendConsoleLog(message: "🔍 Fetching single post #\(postId)...", level: "info")
        performAPICall(method: "GET", url: endpoint, title: "GET /posts/\(postId)")
    }
    
    func patchPost() {
        let endpoint = "\(baseURL)/posts/1"
        let body: [String: Any] = [
            "title": "Patched via TTDebugBridge"
        ]
        sendConsoleLog(message: "🩹 Patching post #1 title via PATCH request...", level: "info")
        performAPICall(method: "PATCH", url: endpoint, title: "PATCH /posts/1", requestBody: body)
    }
    
    func runAllAPIs() {
        sendConsoleLog(message: "🚀 Running ALL API demos sequentially...", level: "info")
        
        fetchPosts()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.fetchComments() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { self.fetchUsers() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { self.fetchTodos() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { self.createPost() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { self.updatePost() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { self.patchPost() }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { self.deletePost() }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            self.sendConsoleLog(message: "✅ All API demos completed! Check TTBDebugPlus on macOS.", level: "info")
        }
    }
    
    func clearLogs() {
        logs.removeAll()
        sendConsoleLog(message: "🧹 Local log view cleared.", level: "debug")
    }
    
    // MARK: - Private
    
    private func performAPICall(method: String, url: String, title: String, requestBody: [String: Any]? = nil) {
        isLoading = true
        let startTime = Date()
        
        guard let requestURL = URL(string: url) else {
            sendConsoleLog(message: "❌ Invalid URL: \(url)", level: "error")
            isLoading = false
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = method
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("TTBaseUIKitExample/1.0", forHTTPHeaderField: "User-Agent")
        
        var requestBodyString = ""
        if let body = requestBody {
            if let data = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted) {
                request.httpBody = data
                requestBodyString = String(data: data, encoding: .utf8) ?? ""
            }
        }
        
        let requestHeaders = request.allHTTPHeaderFields ?? [:]
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            let duration = Date().timeIntervalSince(startTime) * 1000
            
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false
                
                if let error = error {
                    self.sendConsoleLog(message: "❌ \(title) failed: \(error.localizedDescription)", level: "error")
                    
                    TTDebugBridge.shared.sendAPILog(
                        method: method,
                        url: url,
                        statusCode: 0,
                        requestHeaders: requestHeaders,
                        requestBody: requestBodyString,
                        responseHeaders: [:],
                        responseBody: "Error: \(error.localizedDescription)",
                        durationMs: duration,
                        sizeBytes: 0
                    )
                    
                    self.addLogEntry(type: .api, title: title, detail: "Error: \(error.localizedDescription)", statusCode: 0, method: method)
                    return
                }
                
                let httpResponse = response as? HTTPURLResponse
                let statusCode = httpResponse?.statusCode ?? 0
                let responseHeaders = (httpResponse?.allHeaderFields as? [String: String]) ?? [:]
                let responseBody = String(data: data ?? Data(), encoding: .utf8) ?? ""
                let sizeBytes = data?.count ?? 0
                
                // Send API log to TTBDebugPlus via Debug Bridge
                TTDebugBridge.shared.sendAPILog(
                    method: method,
                    url: url,
                    statusCode: statusCode,
                    requestHeaders: requestHeaders,
                    requestBody: requestBodyString,
                    responseHeaders: responseHeaders,
                    responseBody: responseBody,
                    durationMs: duration,
                    sizeBytes: sizeBytes
                )
                
                // Send console log summarizing the result
                let sizeStr = ByteCountFormatter.string(fromByteCount: Int64(sizeBytes), countStyle: .file)
                let durationStr = String(format: "%.0fms", duration)
                self.sendConsoleLog(
                    message: "✅ \(title) → \(statusCode) | \(durationStr) | \(sizeStr)",
                    level: statusCode >= 400 ? "error" : "info"
                )
                
                // Local log
                let detail = "Status: \(statusCode) | Duration: \(durationStr) | Size: \(sizeStr)"
                self.addLogEntry(type: .api, title: title, detail: detail, statusCode: statusCode, method: method)
            }
        }.resume()
    }
    
    private func sendConsoleLog(message: String, level: String) {
        TTDebugBridge.shared.sendConsoleLog(
            level: level,
            subsystem: "DebugBridgeDemo",
            message: message,
            sourceFile: "DebugBridgeDemoView.swift",
            sourceLine: 0
        )
        
        addLogEntry(type: .console, title: message, detail: "Level: \(level)", statusCode: nil, method: nil)
    }
    
    private func addLogEntry(type: DebugLogEntry.LogType, title: String, detail: String, statusCode: Int?, method: String?) {
        let entry = DebugLogEntry(timestamp: Date(), type: type, title: title, detail: detail, statusCode: statusCode, method: method)
        logs.insert(entry, at: 0)
        // Keep last 100 entries
        if logs.count > 100 {
            logs = Array(logs.prefix(100))
        }
    }
}

// MARK: - DebugBridgeDemoView
struct DebugBridgeDemoView: View {
    
    @StateObject private var viewModel = DebugBridgeDemoViewModel()
    @State private var showAbout = true
    private let docsURL = "https://tqtuan1201.github.io/public/docs/ttbaseuikit/ttbdebugplus.html"
    
    var body: some View {
        NavigationView {
            TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
                TTBaseSUIVStack(alignment: .leading, spacing: 16, bg: .clear) {
                    
                    // Status Card
                    statusCard
                    
                    // About TTBDebugPlus
                    aboutSection
                    
                    // API Actions Section
                    sectionHeader(title: "📡 API Requests", subtitle: "Tap to call JSONPlaceholder API & send logs to TTBDebugPlus")
                    apiActionsGrid
                    
                    // Quick Actions
                    sectionHeader(title: "⚡ Quick Actions", subtitle: "Batch operations & utilities")
                    quickActionsRow
                    
                    // Log Feed
                    sectionHeader(title: "📜 Live Log Feed", subtitle: "\(viewModel.logs.count) entries")
                    logFeed
                }
                .pAll(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitle("DebugBridge", displayMode: .inline)
            .onAppear {
                UITabBar.showTabBar(animated: true)
                viewModel.updateBridgeStatus()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            UINavigationBarAppearance().setColor(title: .white, background: XView.viewBgNavColor)
        }
    }
    
    // MARK: - Status Card
    private var statusCard: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
            // Status Indicator
            Circle()
                .fill(statusColor)
                .frame(width: 12, height: 12)
                .overlay(
                    Circle()
                        .stroke(statusColor.opacity(0.3), lineWidth: 3)
                )
            
            TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                TTBaseSUIText(withBold: .TITLE, text: "TTDebugBridge", align: .leading)
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "State: \(viewModel.bridgeStatus)", align: .leading, color: .secondary)
            }
            .maxWidth(alignment: .leading)
            
            // Refresh Button
            Button(action: { viewModel.updateBridgeStatus() }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(XView.viewBgNavColor))
            }
        }
        .pAll(16)
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    private var statusColor: Color {
        switch viewModel.bridgeStatus {
        case "Connected": return .green
        case "Browsing", "Connecting": return .orange
        case "Idle": return .gray
        default: return .red
        }
    }
    
    // MARK: - About TTBDebugPlus
    private var aboutSection: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
            // Header — always visible, tappable to toggle
            Button(action: { withAnimation(.easeInOut(duration: 0.25)) { showAbout.toggle() } }) {
                TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                    Text("🖥")
                        .font(.system(size: 28))
                        .frame(width: 44, height: 44)
                        .background(Color(XView.viewBgNavColor).opacity(0.1))
                        .cornerRadius(12)
                    
                    TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                        TTBaseSUIText(withBold: .TITLE, text: "About TTBDebugPlus", align: .leading)
                        TTBaseSUIText(withType: .SUB_SUB_TILE, text: "macOS Companion Debugger for iOS Apps", align: .leading, color: .secondary)
                    }
                    .maxWidth(alignment: .leading)
                    
                    Image(systemName: showAbout ? "chevron.up" : "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .pAll(14)
            }
            .buttonStyle(PlainButtonStyle())
            
            if showAbout {
                Divider().padding(.horizontal, 14)
                
                TTBaseSUIVStack(alignment: .leading, spacing: 14, bg: .clear) {
                    // Description
                    Text("TTBDebugPlus is a professional-grade macOS app for debugging iOS applications in real-time. View console logs, inspect network requests, export to Postman/cURL, capture remote screenshots, and monitor performance — all from your Mac.")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Quick Start Steps
                    TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                        TTBaseSUIText(withBold: .SUB_TITLE, text: "⚡ Quick Start", align: .leading)
                        
                        stepRow(number: "1", icon: "arrow.down.circle.fill", color: .blue,
                                title: "Download & Install",
                                detail: "Download TTBDebugPlus-Installer.dmg (5.8 MB), drag to Applications.")
                        
                        stepRow(number: "2", icon: "wifi", color: .green,
                                title: "Same Wi-Fi Network",
                                detail: "Ensure Mac & iPhone/Simulator are on the same Wi-Fi. Open TTBDebugPlus on Mac.")
                        
                        stepRow(number: "3", icon: "play.circle.fill", color: .orange,
                                title: "Run iOS App",
                                detail: "Build & Run your iOS app. TTDebugBridge auto-discovers macOS via Bonjour in < 2 seconds.")
                    }
                    
                    // Features Grid
                    TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
                        TTBaseSUIText(withBold: .SUB_TITLE, text: "✨ Key Features", align: .leading)
                        
                        featureChipsView
                    }
                    
                    // Action Buttons
                    TTBaseSUIVStack(alignment: .leading, spacing: 8, bg: .clear) {
                        // Full Docs
                        Button(action: { openURL(docsURL) }) {
                            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 14, weight: .semibold))
                                Text("Full Documentation & SDK Guide")
                                    .font(.system(size: 13, weight: .semibold))
                            }
                            .foregroundColor(Color(XView.viewBgNavColor))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(XView.viewBgNavColor).opacity(0.1))
                            .cornerRadius(12)
                        }
                    }
                    
                    // Requirements Note
                    TTBaseSUIHStack(alignment: .top, spacing: 6, bg: .clear) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        Text("Requires TTBaseUIKit v2.3.0+ • macOS 14+ • Bonjour (same Wi-Fi)")
                            .font(.system(size: 11))
                            .foregroundColor(.secondary)
                    }
                }
                .pAll(14)
                .pTop(0)
            }
        }
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - About Helpers
    
    private func stepRow(number: String, icon: String, color: Color, title: String, detail: String) -> some View {
        TTBaseSUIHStack(alignment: .top, spacing: 10, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(color)
                .frame(width: 30, height: 30)
                .background(color.opacity(0.1))
                .cornerRadius(8)
            
            TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.primary)
                Text(detail)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .maxWidth(alignment: .leading)
        }
    }
    
    private var featureChipsView: some View {
        let features: [(String, String)] = [
            ("📋", "Live Console"),
            ("🌐", "Network Inspector"),
            ("📱", "Remote Screenshot"),
            ("📊", "Performance Monitor"),
            ("📦", "Postman Export"),
            ("🔧", "cURL Export"),
        ]
        
        return LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 6),
            GridItem(.flexible(), spacing: 6),
            GridItem(.flexible(), spacing: 6)
        ], spacing: 6) {
            ForEach(Array(features.enumerated()), id: \.offset) { _, feature in
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Text(feature.0).font(.system(size: 11))
                    Text(feature.1)
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                }
                .pHorizontal(6)
                .pVertical(6)
                .maxWidth()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    // MARK: - Section Header
    private func sectionHeader(title: String, subtitle: String) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
            TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: subtitle, align: .leading, color: .secondary)
        }
        .pTop(4)
    }
    
    // MARK: - API Actions Grid
    private var apiActionsGrid: some View {
        let actions: [(String, String, String, Color, () -> Void)] = [
            ("doc.text.fill", "GET Posts", "Fetch 5 posts", .blue, viewModel.fetchPosts),
            ("bubble.left.and.bubble.right.fill", "GET Comments", "Post #1 comments", .purple, viewModel.fetchComments),
            ("person.3.fill", "GET Users", "All users", Color(red: 0.29, green: 0.0, blue: 0.51), viewModel.fetchUsers),
            ("checklist", "GET Todos", "10 todo items", Color(red: 0.18, green: 0.56, blue: 0.59), viewModel.fetchTodos),
            ("plus.circle.fill", "POST Create", "Create new post", .green, viewModel.createPost),
            ("pencil.circle.fill", "PUT Update", "Update post #1", .orange, viewModel.updatePost),
            ("bandage.fill", "PATCH", "Patch post #1", Color(red: 0.0, green: 0.78, blue: 0.74), viewModel.patchPost),
            ("trash.fill", "DELETE", "Delete post #1", .red, viewModel.deletePost),
        ]
        
        return LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ], spacing: 10) {
            ForEach(Array(actions.enumerated()), id: \.offset) { _, action in
                apiActionCard(icon: action.0, title: action.1, subtitle: action.2, color: action.3, action: action.4)
            }
        }
    }
    
    private func apiActionCard(icon: String, title: String, subtitle: String, color: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(color)
                    .frame(width: 36, height: 36)
                    .background(color.opacity(0.12))
                    .cornerRadius(10)
                
                TTBaseSUIVStack(alignment: .leading, spacing: 1, bg: .clear) {
                    Text(title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                .maxWidth(alignment: .leading)
            }
            .pAll(10)
            .cornerRadius(12)
            .bg(byDef: Color.white)
            .baseShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(viewModel.isLoading)
        .opacity(viewModel.isLoading ? 0.6 : 1.0)
    }
    
    // MARK: - Quick Actions
    private var quickActionsRow: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
            // Run All
            Button(action: { viewModel.runAllAPIs() }) {
                Label("Run All", systemImage: "play.fill")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(XView.viewBgNavColor), Color(XView.viewBgNavColor).opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            
            // Random Post
            Button(action: { viewModel.fetchSinglePost() }) {
                Label("Random", systemImage: "shuffle")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(Color(XView.viewBgNavColor))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color(XView.viewBgNavColor).opacity(0.1))
                    .cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            
            // Clear
            Button(action: { viewModel.clearLogs() }) {
                Label("Clear", systemImage: "trash")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(12)
            }
        }
    }
    
    // MARK: - Log Feed
    private var logFeed: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
            if viewModel.logs.isEmpty {
                emptyLogState
            } else {
                ForEach(viewModel.logs) { entry in
                    logRow(entry)
                    if entry.id != viewModel.logs.last?.id {
                        Divider().padding(.leading, 40)
                    }
                }
            }
        }
        .cornerRadius(14)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    
    private var emptyLogState: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 8, bg: .clear) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 36))
                .foregroundColor(.secondary.opacity(0.4))
            TTBaseSUIText(withType: .SUB_TITLE, text: "No logs yet", align: .center, color: .secondary)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "Tap an API button above to start sending\nlogs to TTBDebugPlus on macOS", align: .center, color: .secondary)
        }
        .maxWidth()
        .pAll(32)
    }
    
    private func logRow(_ entry: DebugLogEntry) -> some View {
        TTBaseSUIHStack(alignment: .top, spacing: 10, bg: .clear) {
            // Type indicator
            Text(entry.type.icon)
                .font(.system(size: 16))
                .frame(width: 28, height: 28)
                .background(entry.type.color.opacity(0.1))
                .cornerRadius(8)
            
            // Content
            TTBaseSUIVStack(alignment: .leading, spacing: 3, bg: .clear) {
                Text(entry.title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                
                TTBaseSUIHStack(alignment: .center, spacing: 6, bg: .clear) {
                    if let method = entry.method {
                        Text(method)
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 1)
                            .background(methodColor(method))
                            .cornerRadius(4)
                    }
                    
                    if let status = entry.statusCode, status > 0 {
                        Text("\(status)")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundColor(status >= 400 ? .red : .green)
                    }
                    
                    Text(entry.detail)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
                
                Text(timeFormatter.string(from: entry.timestamp))
                    .font(.system(size: 9))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            .maxWidth(alignment: .leading)
        }
        .pAll(10)
    }
    
    private func methodColor(_ method: String) -> Color {
        switch method.uppercased() {
        case "GET": return .blue
        case "POST": return .green
        case "PUT": return .orange
        case "PATCH": return .purple
        case "DELETE": return .red
        default: return .gray
        }
    }
    
    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss.SSS"
        return f
    }
}

// MARK: - Preview
#Preview {
    DebugBridgeDemoView()
}
