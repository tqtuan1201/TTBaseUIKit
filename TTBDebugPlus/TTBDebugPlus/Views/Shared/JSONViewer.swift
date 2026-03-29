//
//  JSONViewer.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Performance-optimized JSON viewer with syntax highlighting, collapsible tree, line numbers, copy, and search
//

import SwiftUI
import AppKit

// MARK: - JSON Viewer
/// A full-featured JSON viewer with syntax highlighting, collapsible nodes, line numbers, and copy.
/// Optimized for large payloads: async formatting, truncated display, lazy rendering.
struct JSONViewer: View {
    let jsonString: String
    var showLineNumbers: Bool = true
    var showToolbar: Bool = true
    var onOpenInEditor: ((String) -> Void)? = nil
    
    @State private var displayMode: DisplayMode = .formatted
    @State private var isCopied: Bool = false
    @State private var searchText: String = ""
    @State private var collapsedPaths: Set<String> = []
    
    // Async-loaded formatted lines (prevents main thread blocking)
    @State private var formattedLines: [HighlightedLine] = []
    @State private var isFormatting: Bool = false
    @State private var parsedTree: Any? = nil
    @State private var isTreeParsed: Bool = false
    @State private var flattenedTreeNodes: [FlatTreeNode] = []
    @State private var isTreeFlattening: Bool = false
    
    // Large payload NSAttributedString (for NSTextView rendering)
    @State private var largePayloadAttrString: NSAttributedString?
    
    // Truncation for very large payloads
    private static let maxDisplayBytes = 2_000_000 // 2MB display limit (NSTextView can handle it)
    private static let maxLines = 5_000 // Max lines to render in SwiftUI mode
    private static let largePayloadThreshold = 50_000 // 50KB: above this, use NSTextView
    
    /// Whether payload is large enough to require NSTextView rendering
    private var isLargePayload: Bool {
        displayString.count >= Self.largePayloadThreshold
    }
    
    private var isTruncated: Bool {
        jsonString.count > Self.maxDisplayBytes
    }
    
    private var displayString: String {
        if isTruncated {
            return String(jsonString.prefix(Self.maxDisplayBytes))
        }
        return jsonString
    }
    
    enum DisplayMode: String, CaseIterable {
        case formatted = "Pretty"
        case tree = "Tree"
        case raw = "Raw"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            if showToolbar {
                jsonToolbar
            }
            
            // Truncation warning
            if isTruncated {
                truncationBanner
            }
            
            // Content — fills all available space
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.ttBackground)
        }
        .task(id: taskKey) {
            await prepareContent()
        }
    }
    
    /// Task key changes when input, mode, search, or collapse state changes → triggers async re-preparation
    private var taskKey: String {
        "\(displayString.hashValue)_\(displayMode.rawValue)_\(searchText)_\(collapsedPaths.hashValue)"
    }
    
    // MARK: - Async Content Preparation
    private func prepareContent() async {
        switch displayMode {
        case .formatted:
            if isLargePayload {
                // Large payload: use NSAttributedString for NSTextView
                isFormatting = true
                let input = displayString
                let search = searchText
                let attrStr = await Task.detached(priority: .userInitiated) {
                    JSONAttributedHighlighter.highlight(input, searchTerm: search)
                }.value
                
                if displayMode == .formatted {
                    largePayloadAttrString = attrStr
                    isFormatting = false
                }
            } else {
                // Small payload: use SwiftUI Text
                isFormatting = true
                let input = displayString
                let search = searchText
                let lines = await Task.detached(priority: .userInitiated) {
                    JSONHighlighter.highlight(input, searchTerm: search, maxLines: Self.maxLines)
                }.value
                
                if displayMode == .formatted {
                    formattedLines = lines
                    isFormatting = false
                }
            }
            
        case .tree:
            if isLargePayload {
                // Large payload tree: use NSTextView with pretty-printed JSON
                isFormatting = true
                let input = displayString
                let search = searchText
                let attrStr = await Task.detached(priority: .userInitiated) {
                    JSONAttributedHighlighter.highlight(input, searchTerm: search)
                }.value
                
                if displayMode == .tree {
                    largePayloadAttrString = attrStr
                    isFormatting = false
                }
            } else {
                // Small payload: parse and flatten async
                isTreeFlattening = true
                let input = displayString
                let collapsed = collapsedPaths
                let search = searchText
                
                let result = await Task.detached(priority: .userInitiated) { () -> (Any?, [FlatTreeNode]) in
                    guard let data = input.data(using: .utf8),
                          let parsed = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
                        return (nil, [])
                    }
                    let nodes = JSONTreeFlattener.flatten(parsed, collapsedPaths: collapsed, searchTerm: search)
                    return (parsed, nodes)
                }.value
                
                if displayMode == .tree {
                    parsedTree = result.0
                    flattenedTreeNodes = result.1
                    isTreeParsed = true
                    isTreeFlattening = false
                }
            }
            
        case .raw:
            break // No preparation needed
        }
    }
    
    // MARK: - Content Router
    @ViewBuilder
    private var contentView: some View {
        switch displayMode {
        case .formatted:
            if isLargePayload {
                // Large payload: NSTextView path
                if isFormatting && largePayloadAttrString == nil {
                    loadingView
                } else if let attrString = largePayloadAttrString {
                    HighPerformanceTextView(
                        attributedString: attrString,
                        showLineNumbers: showLineNumbers,
                        backgroundColor: NSColor(Color.ttBackground)
                    )
                } else {
                    loadingView
                }
            } else {
                // Small payload: SwiftUI Text path
                if isFormatting && formattedLines.isEmpty {
                    loadingView
                } else {
                    formattedView
                }
            }
        case .tree:
            if isLargePayload {
                // Large payload tree: use NSTextView with highlighted JSON
                if isFormatting && largePayloadAttrString == nil {
                    loadingView
                } else if let attrString = largePayloadAttrString {
                    HighPerformanceTextView(
                        attributedString: attrString,
                        showLineNumbers: showLineNumbers,
                        backgroundColor: NSColor(Color.ttBackground)
                    )
                } else {
                    loadingView
                }
            } else {
                // Small payload: SwiftUI tree view
                if isTreeFlattening && flattenedTreeNodes.isEmpty {
                    loadingView
                } else {
                    treeView
                }
            }
        case .raw:
            rawContentView
        }
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        HStack(spacing: 8) {
            ProgressView()
                .scaleEffect(0.6)
            Text("Formatting \(formatBytes(jsonString.count))...")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, minHeight: 60)
    }
    
    // MARK: - Truncation Banner
    private var truncationBanner: some View {
        HStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.ttIcon(TTIcon.sm))
                .foregroundColor(.ttWarning)
            Text("Response truncated: showing first \(formatBytes(Self.maxDisplayBytes)) of \(formatBytes(jsonString.count))")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttWarning)
            Spacer()
            Button("Copy Full") {
                copyJSON(full: true)
            }
            .font(TTFont.labelSmall)
            .buttonStyle(.plain)
            .foregroundColor(.ttPrimary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.ttWarning.opacity(0.08))
        .overlay(
            Rectangle().fill(Color.ttWarning.opacity(0.2)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Toolbar
    private var jsonToolbar: some View {
        HStack(spacing: 8) {
            // Search
            HStack(spacing: 6) {
                Image(systemName: "magnifyingglass")
                    .font(.ttIcon(TTIcon.sm))
                    .foregroundColor(.ttTextTertiary)
                TextField("Search JSON...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(TTFont.codeSmall)
                    .frame(maxWidth: 150)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.ttIcon(TTIcon.sm))
                            .foregroundColor(.ttTextTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.ttSurface)
            )
            
            Spacer()
            
            // Display mode picker
            HStack(spacing: 2) {
                ForEach(DisplayMode.allCases, id: \.self) { mode in
                    Button(action: {
                        // Reset stale state when switching modes
                        if mode != displayMode {
                            largePayloadAttrString = nil
                        }
                        displayMode = mode
                    }) {
                        Text(mode.rawValue)
                            .font(TTFont.labelSmall)
                            .foregroundColor(displayMode == mode ? .white : .ttTextTertiary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(displayMode == mode ? Color.ttPrimary.opacity(0.5) : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            Divider().frame(height: 14)
            
            // Size
            Text(formatBytes(jsonString.count))
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            // Copy
            Button(action: { copyJSON(full: false) }) {
                HStack(spacing: 3) {
                    Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                        .font(.ttIcon(TTIcon.sm))
                    Text(isCopied ? "Copied" : "Copy")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(isCopied ? .ttSuccess : .ttTextSecondary)
            }
            .buttonStyle(.plain)
            
            // Open in JSON Editor
            if let onOpenInEditor {
                Button(action: { onOpenInEditor(jsonString) }) {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.up.forward.square")
                            .font(.ttIcon(TTIcon.sm))
                        Text("Edit")
                            .font(TTFont.labelSmall)
                    }
                    .foregroundColor(.ttPrimaryLight)
                }
                .buttonStyle(.plain)
                .help("Open in JSON Editor")
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.ttSurface.opacity(0.3))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Formatted View (Virtualized line rendering)
    
    /// Dynamic width for line numbers based on total line count
    private var lineNumberWidth: CGFloat {
        let digitCount = max(2, "\(formattedLines.count)".count)
        return CGFloat(digitCount) * 8 + 16
    }
    
    private var formattedView: some View {
        ZStack {
            ScrollView([.horizontal, .vertical]) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(formattedLines) { line in
                        HStack(alignment: .top, spacing: 0) {
                            if showLineNumbers {
                                Text("\(line.lineNumber)")
                                    .font(TTFont.codeSmall)
                                    .foregroundColor(.ttTextMuted)
                                    .frame(width: lineNumberWidth, alignment: .trailing)
                                    .padding(.trailing, 12)
                            }
                            
                            line.content
                                .font(TTFont.codeMedium)
                                .textSelection(.enabled)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .padding(.vertical, 1)
                        .id(line.id)
                    }
                }
                .padding(12)
            }
            
            // Loading overlay (shown during re-formatting, keeps previous content visible)
            if isFormatting && !formattedLines.isEmpty {
                VStack {
                    HStack(spacing: 6) {
                        ProgressView()
                            .scaleEffect(0.5)
                        Text("Updating...")
                            .font(TTFont.codeSmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.ttSurface.opacity(0.95))
                            .shadow(color: .black.opacity(0.2), radius: 4)
                    )
                    Spacer()
                }
                .padding(.top, 8)
                .transition(.opacity)
            }
        }
    }
    
    // MARK: - Tree View (pre-flattened, uses async-computed nodes)
    private var treeView: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(flattenedTreeNodes) { node in
                    treeNodeRow(node)
                        .id(node.id)
                }
            }
            .padding(12)
        }
    }
    
    private func treeNodeRow(_ node: FlatTreeNode) -> some View {
        HStack(spacing: 0) {
            // Indentation guides
            ForEach(0..<node.indent, id: \.self) { _ in
                Rectangle()
                    .fill(Color.ttBorder.opacity(0.12))
                    .frame(width: 1)
                    .padding(.horizontal, 10)
            }
            
            // Collapse toggle (if applicable)
            if node.isCollapsible {
                Button(action: { toggleCollapse(node.path) }) {
                    Image(systemName: node.isCollapsed ? "chevron.right" : "chevron.down")
                        .font(.ttIcon(TTIcon.xxs))
                        .foregroundColor(.ttTextTertiary)
                        .frame(width: 14, height: 14)
                }
                .buttonStyle(.plain)
            } else {
                Spacer().frame(width: 14)
            }
            
            // Content
            node.content
                .font(TTFont.codeMedium)
                .textSelection(.enabled)
                .fixedSize(horizontal: true, vertical: false)
            
            Spacer(minLength: 0)
        }
        .frame(height: 22)
        .contentShape(Rectangle())
        .onTapGesture {
            if node.isCollapsible { toggleCollapse(node.path) }
        }
    }
    
    // MARK: - Raw View (Chunked for large data)
    private var rawContentView: some View {
        ScrollView([.horizontal, .vertical]) {
            if displayString.count > 50_000 {
                // For very large raw data, split into chunks
                LazyVStack(alignment: .leading, spacing: 0) {
                    let chunks = chunkString(displayString, size: 10_000)
                    ForEach(Array(chunks.enumerated()), id: \.offset) { _, chunk in
                        Text(chunk)
                            .font(TTFont.codeMedium)
                            .foregroundColor(.ttTextPrimary)
                            .textSelection(.enabled)
                            .fixedSize(horizontal: true, vertical: false)
                    }
                }
                .padding(12)
            } else {
                Text(displayString)
                    .font(TTFont.codeMedium)
                    .foregroundColor(.ttTextPrimary)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: true, vertical: false)
                    .padding(12)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func toggleCollapse(_ path: String) {
        if collapsedPaths.contains(path) {
            collapsedPaths.remove(path)
        } else {
            collapsedPaths.insert(path)
        }
    }
    
    private func copyJSON(full: Bool) {
        #if os(macOS)
        let source = full ? jsonString : displayString
        let output: String
        if let data = source.data(using: .utf8),
           let obj = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: pretty, encoding: .utf8) {
            output = str
        } else {
            output = source
        }
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(output, forType: .string)
        #endif
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isCopied = false
        }
    }
    
    private func formatBytes(_ bytes: Int) -> String {
        if bytes < 1024 { return "\(bytes) B" }
        if bytes < 1024 * 1024 { return String(format: "%.1f KB", Double(bytes) / 1024) }
        return String(format: "%.1f MB", Double(bytes) / (1024 * 1024))
    }
    
    private func chunkString(_ str: String, size: Int) -> [String] {
        var chunks: [String] = []
        var start = str.startIndex
        while start < str.endIndex {
            let end = str.index(start, offsetBy: size, limitedBy: str.endIndex) ?? str.endIndex
            chunks.append(String(str[start..<end]))
            start = end
        }
        return chunks
    }
}

#Preview {
    JSONViewer(jsonString: """
    {
      "events": [
        {
          "type": "ui_interaction",
          "element_id": "submit_btn",
          "timestamp": 1694203199,
          "metadata": {
            "origin": "settings_page",
            "is_active": true,
            "count": 42
          }
        }
      ],
      "status": "processed",
      "debug_info": null
    }
    """)
    .frame(width: 500, height: 400)
    .preferredColorScheme(.dark)
}
