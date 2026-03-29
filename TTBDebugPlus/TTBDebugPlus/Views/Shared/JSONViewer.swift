//
//  JSONViewer.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Performance-optimized JSON viewer with syntax highlighting, collapsible tree, line numbers, copy, and search
//

import SwiftUI

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
    
    // Truncation for very large payloads
    private static let maxDisplayBytes = 512_000 // 512KB display limit
    private static let maxLines = 5_000 // Max lines to render
    
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
            
            // Content
            contentView
                .background(Color.ttBackground)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ttBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.ttBorder.opacity(0.3), lineWidth: 1)
                )
        )
        .task(id: taskKey) {
            await prepareContent()
        }
    }
    
    /// Task key changes when input or mode changes, triggering async re-preparation
    private var taskKey: String {
        "\(displayString.hashValue)_\(displayMode.rawValue)_\(searchText)"
    }
    
    // MARK: - Async Content Preparation
    private func prepareContent() async {
        switch displayMode {
        case .formatted:
            isFormatting = true
            let input = displayString
            let search = searchText
            let lines = await Task.detached(priority: .userInitiated) {
                JSONHighlighter.highlight(input, searchTerm: search, maxLines: Self.maxLines)
            }.value
            
            // Only update if still relevant
            if displayMode == .formatted {
                formattedLines = lines
                isFormatting = false
            }
            
        case .tree:
            if !isTreeParsed {
                let input = displayString
                let parsed = await Task.detached(priority: .userInitiated) {
                    guard let data = input.data(using: .utf8) else { return nil as Any? }
                    return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                }.value
                parsedTree = parsed
                isTreeParsed = true
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
            if isFormatting && formattedLines.isEmpty {
                loadingView
            } else {
                formattedView
            }
        case .tree:
            if !isTreeParsed {
                loadingView
            } else if let parsed = parsedTree {
                treeView(parsed)
            } else {
                rawContentView
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
                        displayMode = mode
                        // Reset tree parse state when switching modes
                        if mode == .tree { isTreeParsed = false }
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
    private var formattedView: some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(formattedLines) { line in
                    HStack(alignment: .top, spacing: 0) {
                        if showLineNumbers {
                            Text("\(line.lineNumber)")
                                .font(TTFont.codeSmall)
                                .foregroundColor(.ttTextMuted)
                                .frame(width: 36, alignment: .trailing)
                                .padding(.trailing, 12)
                        }
                        
                        line.content
                            .font(TTFont.codeMedium)
                            .textSelection(.enabled)
                    }
                    .padding(.vertical, 1)
                    .id(line.id)
                }
            }
            .padding(12)
        }
    }
    
    // MARK: - Tree View (Collapsible nodes with lazy rendering)
    private func treeView(_ parsed: Any) -> some View {
        ScrollView([.horizontal, .vertical]) {
            LazyVStack(alignment: .leading, spacing: 0) {
                let flatNodes = JSONTreeFlattener.flatten(parsed, collapsedPaths: collapsedPaths, searchTerm: searchText)
                ForEach(flatNodes) { node in
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
                    }
                }
                .padding(12)
            } else {
                Text(displayString)
                    .font(TTFont.codeMedium)
                    .foregroundColor(.ttTextPrimary)
                    .textSelection(.enabled)
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

// MARK: - Highlighted Line Model
struct HighlightedLine: Identifiable {
    let id: Int
    let lineNumber: Int
    let content: Text
}

// MARK: - JSON Syntax Highlighter (Optimized)
enum JSONHighlighter {
    
    /// Parse JSON string and return highlighted lines. Runs on background thread.
    static func highlight(_ jsonString: String, searchTerm: String = "", maxLines: Int = 5000) -> [HighlightedLine] {
        // Pretty-print JSON first
        let prettyJSON: String
        if let data = jsonString.data(using: .utf8),
           let obj = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: pretty, encoding: .utf8) {
            prettyJSON = str
        } else {
            prettyJSON = jsonString
        }
        
        let allLines = prettyJSON.components(separatedBy: "\n")
        let lines = Array(allLines.prefix(maxLines))
        
        var result: [HighlightedLine] = []
        result.reserveCapacity(lines.count)
        
        for (index, line) in lines.enumerated() {
            result.append(HighlightedLine(
                id: index,
                lineNumber: index + 1,
                content: highlightLine(line, searchTerm: searchTerm)
            ))
        }
        
        // Add truncation indicator if needed
        if allLines.count > maxLines {
            result.append(HighlightedLine(
                id: maxLines,
                lineNumber: maxLines + 1,
                content: Text("... (\(allLines.count - maxLines) more lines)")
                    .foregroundColor(.ttTextTertiary)
                    .italic()
            ))
        }
        
        return result
    }
    
    /// Highlight a single line of JSON
    private static func highlightLine(_ line: String, searchTerm: String) -> Text {
        var result = Text("")
        var remaining = line[line.startIndex...]
        
        while !remaining.isEmpty {
            let char = remaining[remaining.startIndex]
            
            // Whitespace (indentation)
            if char == " " {
                var spaces = ""
                while !remaining.isEmpty && remaining[remaining.startIndex] == " " {
                    spaces.append(" ")
                    remaining = remaining[remaining.index(after: remaining.startIndex)...]
                }
                result = result + Text(spaces)
                continue
            }
            
            // Braces and brackets
            if "{}[]".contains(char) {
                result = result + Text(String(char)).foregroundColor(.ttJsonBrace)
                remaining = remaining[remaining.index(after: remaining.startIndex)...]
                continue
            }
            
            // Colon
            if char == ":" {
                result = result + Text(" : ").foregroundColor(.ttJsonBrace)
                remaining = remaining[remaining.index(after: remaining.startIndex)...]
                // Skip trailing space if present
                if !remaining.isEmpty && remaining[remaining.startIndex] == " " {
                    remaining = remaining[remaining.index(after: remaining.startIndex)...]
                }
                continue
            }
            
            // Comma
            if char == "," {
                result = result + Text(",").foregroundColor(.ttJsonBrace)
                remaining = remaining[remaining.index(after: remaining.startIndex)...]
                continue
            }
            
            // String (key or value)
            if char == "\"" {
                if let endIdx = findEndOfString(in: remaining) {
                    let str = String(remaining[remaining.startIndex...endIdx])
                    remaining = remaining[remaining.index(after: endIdx)...]
                    
                    // Check if this is a key (followed by ':')
                    let trimmedRemaining = remaining.drop(while: { $0 == " " })
                    let isKey = !trimmedRemaining.isEmpty && trimmedRemaining.first == ":"
                    
                    let color: Color = isKey ? .ttJsonKey : .ttJsonString
                    
                    if !searchTerm.isEmpty && str.localizedCaseInsensitiveContains(searchTerm) {
                        result = result + Text(str)
                            .foregroundColor(color)
                            .bold()
                            .underline()
                    } else {
                        result = result + Text(str).foregroundColor(color)
                    }
                    continue
                }
            }
            
            // Number
            if char.isNumber || char == "-" {
                var num = ""
                while !remaining.isEmpty && (remaining[remaining.startIndex].isNumber || remaining[remaining.startIndex] == "." || remaining[remaining.startIndex] == "-" || remaining[remaining.startIndex] == "e" || remaining[remaining.startIndex] == "E" || remaining[remaining.startIndex] == "+") {
                    num.append(remaining[remaining.startIndex])
                    remaining = remaining[remaining.index(after: remaining.startIndex)...]
                }
                result = result + Text(num).foregroundColor(.ttJsonNumber)
                continue
            }
            
            // Boolean / null
            if remaining.hasPrefix("true") {
                result = result + Text("true").foregroundColor(.ttJsonBool)
                remaining = remaining[remaining.index(remaining.startIndex, offsetBy: 4)...]
                continue
            }
            if remaining.hasPrefix("false") {
                result = result + Text("false").foregroundColor(.ttJsonBool)
                remaining = remaining[remaining.index(remaining.startIndex, offsetBy: 5)...]
                continue
            }
            if remaining.hasPrefix("null") {
                result = result + Text("null").foregroundColor(.ttJsonNull).italic()
                remaining = remaining[remaining.index(remaining.startIndex, offsetBy: 4)...]
                continue
            }
            
            // Other characters
            result = result + Text(String(char)).foregroundColor(.ttTextPrimary)
            remaining = remaining[remaining.index(after: remaining.startIndex)...]
        }
        
        return result
    }
    
    /// Find the closing quote of a JSON string, handling escapes
    private static func findEndOfString(in str: Substring) -> String.Index? {
        guard str.first == "\"" else { return nil }
        var idx = str.index(after: str.startIndex)
        while idx < str.endIndex {
            if str[idx] == "\\" {
                // Skip escaped character
                idx = str.index(after: idx)
                if idx < str.endIndex {
                    idx = str.index(after: idx)
                }
                continue
            }
            if str[idx] == "\"" {
                return idx
            }
            idx = str.index(after: idx)
        }
        return nil
    }
}

// MARK: - Flat Tree Node (for LazyVStack rendering)
struct FlatTreeNode: Identifiable {
    let id: String
    let indent: Int
    let path: String
    let isCollapsible: Bool
    let isCollapsed: Bool
    let content: Text
}

// MARK: - JSON Tree Flattener (converts recursive tree to flat list for LazyVStack)
enum JSONTreeFlattener {
    
    static func flatten(_ value: Any, collapsedPaths: Set<String>, searchTerm: String) -> [FlatTreeNode] {
        var nodes: [FlatTreeNode] = []
        flattenValue(value, key: nil, indent: 0, path: "root", isLast: true,
                     collapsedPaths: collapsedPaths, searchTerm: searchTerm, nodes: &nodes)
        return nodes
    }
    
    private static func flattenValue(
        _ value: Any, key: String?, indent: Int, path: String, isLast: Bool,
        collapsedPaths: Set<String>, searchTerm: String, nodes: inout [FlatTreeNode]
    ) {
        if let dict = value as? [String: Any] {
            let isCollapsed = collapsedPaths.contains(path)
            
            // Opening line
            var openText = Text("")
            if let key = key {
                openText = Text("\"\(key)\"").foregroundColor(.ttJsonKey) +
                    Text(" : ").foregroundColor(.ttJsonBrace)
            }
            
            if isCollapsed {
                openText = openText +
                    Text("{ ").foregroundColor(.ttJsonBrace) +
                    Text("\(dict.count) keys").foregroundColor(.ttTextTertiary) +
                    Text(" }").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
            } else {
                openText = openText + Text("{").foregroundColor(.ttJsonBrace)
            }
            
            nodes.append(FlatTreeNode(id: path, indent: indent, path: path,
                                     isCollapsible: true, isCollapsed: isCollapsed, content: openText))
            
            if !isCollapsed {
                let sortedKeys = dict.keys.sorted()
                for (i, k) in sortedKeys.enumerated() {
                    if let childValue = dict[k] {
                        flattenValue(childValue, key: k, indent: indent + 1,
                                     path: "\(path).\(k)", isLast: i == sortedKeys.count - 1,
                                     collapsedPaths: collapsedPaths, searchTerm: searchTerm, nodes: &nodes)
                    }
                }
                
                // Closing brace
                let closeText = Text("}").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
                nodes.append(FlatTreeNode(id: "\(path)_close", indent: indent, path: "",
                                         isCollapsible: false, isCollapsed: false, content: closeText))
            }
            
        } else if let arr = value as? [Any] {
            let isCollapsed = collapsedPaths.contains(path)
            
            var openText = Text("")
            if let key = key {
                openText = Text("\"\(key)\"").foregroundColor(.ttJsonKey) +
                    Text(" : ").foregroundColor(.ttJsonBrace)
            }
            
            if isCollapsed {
                openText = openText +
                    Text("[ ").foregroundColor(.ttJsonBrace) +
                    Text("\(arr.count) items").foregroundColor(.ttTextTertiary) +
                    Text(" ]").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
            } else {
                openText = openText + Text("[").foregroundColor(.ttJsonBrace)
            }
            
            nodes.append(FlatTreeNode(id: path, indent: indent, path: path,
                                     isCollapsible: true, isCollapsed: isCollapsed, content: openText))
            
            if !isCollapsed {
                // Limit array rendering to prevent explosion
                let maxItems = min(arr.count, 500)
                for i in 0..<maxItems {
                    flattenValue(arr[i], key: nil, indent: indent + 1,
                                 path: "\(path)[\(i)]", isLast: i == maxItems - 1 && maxItems == arr.count,
                                 collapsedPaths: collapsedPaths, searchTerm: searchTerm, nodes: &nodes)
                }
                
                if arr.count > maxItems {
                    nodes.append(FlatTreeNode(
                        id: "\(path)_truncated", indent: indent + 1, path: "",
                        isCollapsible: false, isCollapsed: false,
                        content: Text("... (\(arr.count - maxItems) more items)")
                            .foregroundColor(.ttTextTertiary).italic()
                    ))
                }
                
                let closeText = Text("]").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
                nodes.append(FlatTreeNode(id: "\(path)_close", indent: indent, path: "",
                                         isCollapsible: false, isCollapsed: false, content: closeText))
            }
            
        } else {
            // Leaf node
            var leafContent = Text("")
            if let key = key {
                // Highlight matching keys
                if !searchTerm.isEmpty && key.localizedCaseInsensitiveContains(searchTerm) {
                    leafContent = Text("\"\(key)\"").foregroundColor(.ttJsonKey).bold().underline() +
                        Text(" : ").foregroundColor(.ttJsonBrace)
                } else {
                    leafContent = Text("\"\(key)\"").foregroundColor(.ttJsonKey) +
                        Text(" : ").foregroundColor(.ttJsonBrace)
                }
            }
            
            leafContent = leafContent + leafText(value, searchTerm: searchTerm)
            
            if !isLast {
                leafContent = leafContent + Text(",").foregroundColor(.ttJsonBrace)
            }
            
            nodes.append(FlatTreeNode(id: path, indent: indent, path: path,
                                     isCollapsible: false, isCollapsed: false, content: leafContent))
        }
    }
    
    private static func leafText(_ value: Any, searchTerm: String) -> Text {
        if let str = value as? String {
            let displayStr = "\"\(str)\""
            if !searchTerm.isEmpty && str.localizedCaseInsensitiveContains(searchTerm) {
                return Text(displayStr).foregroundColor(.ttJsonString).bold().underline()
            }
            return Text(displayStr).foregroundColor(.ttJsonString)
        } else if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return Text(num.boolValue ? "true" : "false").foregroundColor(.ttJsonBool)
            }
            return Text("\(num)").foregroundColor(.ttJsonNumber)
        } else if value is NSNull {
            return Text("null").foregroundColor(.ttJsonNull).italic()
        }
        return Text("\(value)").foregroundColor(.ttTextPrimary)
    }
}

// MARK: - cURL Generator
enum CURLGenerator {
    /// Generate a cURL command from an API log payload
    static func generate(from log: APILogPayload) -> String {
        var parts: [String] = ["curl"]
        
        // Method
        if log.method.uppercased() != "GET" {
            parts.append("-X \(log.method.uppercased())")
        }
        
        // URL
        parts.append("'\(log.url)'")
        
        // Headers
        for (key, value) in log.requestHeaders {
            parts.append("-H '\(key): \(value)'")
        }
        
        // Body
        if !log.requestBody.isEmpty {
            let escaped = log.requestBody.replacingOccurrences(of: "'", with: "'\\''")
            parts.append("-d '\(escaped)'")
        }
        
        return parts.joined(separator: " \\\n  ")
    }
    
    /// Generate Postman collection JSON from API logs
    static func generatePostmanCollection(from logs: [APILogPayload], name: String = "TTBDebugPlus Export") -> String {
        var items: [[String: Any]] = []
        
        for log in logs {
            var headers: [[String: String]] = []
            for (key, value) in log.requestHeaders {
                headers.append(["key": key, "value": value, "type": "text"])
            }
            
            let urlComponents = URLComponents(string: log.url)
            var queryParams: [[String: String]] = []
            for item in urlComponents?.queryItems ?? [] {
                queryParams.append(["key": item.name, "value": item.value ?? ""])
            }
            
            var request: [String: Any] = [
                "method": log.method.uppercased(),
                "header": headers,
                "url": [
                    "raw": log.url,
                    "protocol": urlComponents?.scheme ?? "https",
                    "host": (urlComponents?.host ?? "").components(separatedBy: "."),
                    "path": (urlComponents?.path ?? "").components(separatedBy: "/").filter { !$0.isEmpty },
                    "query": queryParams
                ] as [String: Any]
            ]
            
            if !log.requestBody.isEmpty {
                request["body"] = [
                    "mode": "raw",
                    "raw": log.requestBody,
                    "options": ["raw": ["language": "json"]]
                ] as [String: Any]
            }
            
            let urlPath = urlComponents?.path ?? log.url
            items.append([
                "name": "\(log.method.uppercased()) \(urlPath)",
                "request": request,
                "response": []
            ] as [String: Any])
        }
        
        let collection: [String: Any] = [
            "info": [
                "_postman_id": UUID().uuidString,
                "name": name,
                "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json",
                "description": "Exported from TTBDebugPlus"
            ] as [String: Any],
            "item": items
        ]
        
        if let data = try? JSONSerialization.data(withJSONObject: collection, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "{}"
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
