//
//  JSONEditorTreeView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  V3: Clean key:value tree view inspired by jsoneditoronline.org
//  No JSON syntax (braces, brackets, commas, quotes in values)
//

import SwiftUI

struct JSONEditorTreeView: View {
    let jsonString: String
    var searchText: String = ""
    
    @State private var collapsedPaths: Set<String> = []
    @State private var parsedTree: Any? = nil
    @State private var isParsed: Bool = false
    @State private var hoveredNodeId: String? = nil
    @State private var selectedNodePath: String = ""
    @State private var collapseLevel: Int = -1
    @State private var searchMatchCount: Int = 0
    @State private var currentMatchIndex: Int = 0
    @State private var matchedNodeIds: [String] = []
    
    var body: some View {
        VStack(spacing: 0) {
            if !isParsed {
                loadingState
            } else if let parsed = parsedTree {
                treeToolbar
                treeContent(parsed)
            } else {
                invalidState
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: jsonString.hashValue) {
            await parseJSON()
        }
        .onChange(of: searchText) { _ in
            Task { await updateSearchMatches() }
        }
    }
    
    // MARK: - Loading
    private var loadingState: some View {
        HStack(spacing: 8) {
            ProgressView().scaleEffect(0.6)
            Text("Parsing tree…")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Invalid JSON
    private var invalidState: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 28))
                .foregroundColor(.ttWarning)
            Text("Invalid JSON")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            Text("Fix syntax errors to see tree view")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Tree Toolbar
    private var treeToolbar: some View {
        HStack(spacing: 6) {
            // Level collapse buttons
            Text("Level:")
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
            
            ForEach([1, 2, 3], id: \.self) { level in
                levelButton("L\(level)", isActive: collapseLevel == level) {
                    collapseToLevel(level)
                }
                .help("Collapse to level \(level)")
            }
            
            levelButton("All", isActive: collapseLevel == -1) {
                collapseToLevel(-1)
            }
            .help("Expand all")
            
            levelButton("None", isActive: collapseLevel == 0) {
                collapseToLevel(0)
            }
            .help("Collapse all")
            
            Spacer()
            
            // Search match indicator (moved from breadcrumb)
            if !searchText.isEmpty {
                HStack(spacing: 3) {
                    Text("\(searchMatchCount)")
                        .font(TTFont.badge)
                        .foregroundColor(searchMatchCount > 0 ? .ttSuccess : .ttTextMuted)
                    Text("match\(searchMatchCount == 1 ? "" : "es")")
                        .font(TTFont.badge)
                        .foregroundColor(.ttTextTertiary)
                    
                    if searchMatchCount > 1 {
                        Button(action: { navigateMatch(-1) }) {
                            Image(systemName: "chevron.up")
                                .font(.system(size: 8, weight: .bold))
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.ttTextSecondary)
                        
                        Text("\(currentMatchIndex + 1)/\(searchMatchCount)")
                            .font(TTFont.badge)
                            .foregroundColor(.ttTextTertiary)
                        
                        Button(action: { navigateMatch(1) }) {
                            Image(systemName: "chevron.down")
                                .font(.system(size: 8, weight: .bold))
                        }
                        .buttonStyle(.plain)
                        .foregroundColor(.ttTextSecondary)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(
                    Capsule().fill(searchMatchCount > 0 ? Color.ttSuccess.opacity(0.06) : Color.ttSurface.opacity(0.3))
                )
            }
            
            // Node count
            if let parsed = parsedTree {
                let count = countNodes(parsed)
                HStack(spacing: 3) {
                    Image(systemName: "circle.grid.3x3")
                        .font(.system(size: 8))
                    Text("\(count)")
                }
                .font(TTFont.badge)
                .foregroundColor(.ttTextTertiary)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.ttSurface.opacity(0.2))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.15)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    private func levelButton(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(TTFont.badge)
                .foregroundColor(isActive ? .white : .ttTextSecondary)
                .padding(.horizontal, 7)
                .padding(.vertical, 2)
                .background(
                    Capsule().fill(isActive ? Color.ttPrimary.opacity(0.5) : Color.ttSurface.opacity(0.3))
                )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Tree Content
    private func treeContent(_ parsed: Any) -> some View {
        GeometryReader { geo in
            ScrollView([.horizontal, .vertical]) {
                LazyVStack(alignment: .leading, spacing: 0) {
                    let allNodes = JSONTreeFlattener.flatten(parsed, collapsedPaths: collapsedPaths, searchTerm: searchText)
                    let nodes = allNodes.filter { !$0.isClosingBracket }
                    ForEach(Array(nodes.enumerated()), id: \.element.id) { index, node in
                        treeNodeRow(node, rowIndex: index)
                            .frame(minWidth: geo.size.width - 12, alignment: .leading)
                            .id(node.id)
                    }
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 6)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    // MARK: - Node Row (jsoneditoronline-style)
    private func treeNodeRow(_ node: FlatTreeNode, rowIndex: Int) -> some View {
        HStack(spacing: 0) {
            // Indent guides
            ForEach(0..<node.indent, id: \.self) { level in
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(indentColor(for: level))
                        .frame(width: 1)
                    Spacer()
                }
                .frame(width: 20)
            }
            
            // Collapse toggle
            if node.isCollapsible {
                Button(action: { toggleCollapse(node.path) }) {
                    Image(systemName: node.isCollapsed ? "chevron.right" : "chevron.down")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundColor(.ttPrimaryLight)
                        .frame(width: 16, height: 16)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.ttPrimary.opacity(hoveredNodeId == node.id ? 0.15 : 0.05))
                        )
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            } else {
                Spacer().frame(width: 20)
            }
            
            // Key label
            if let key = node.key {
                Text(key)
                    .font(TTFont.codeMedium)
                    .foregroundColor(isSearchMatch(key) ? .ttPrimary : .ttJsonKey)
                    .fontWeight(isSearchMatch(key) ? .bold : .regular)
                    .fixedSize(horizontal: true, vertical: false)
            }
            
            // Separator
            if node.key != nil && (node.displayValue != nil || node.isCollapsible) {
                Text(" : ")
                    .font(TTFont.codeMedium)
                    .foregroundColor(.ttTextMuted)
            }
            
            // Type badge
            if let valueType = node.valueType {
                typeBadge(valueType)
                    .padding(.trailing, 5)
            }
            
            // Value or child count
            if let displayValue = node.displayValue {
                valueText(displayValue, type: node.valueType)
                    .fixedSize(horizontal: true, vertical: false)
            } else if let childCount = node.childCount {
                containerCount(childCount, type: node.valueType)
                    .fixedSize(horizontal: true, vertical: false)
            }
            
            Spacer(minLength: 8)
            
            // Copy button on hover
            if hoveredNodeId == node.id, let raw = node.rawValue ?? node.displayValue {
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(raw, forType: .string)
                }) {
                    Image(systemName: "doc.on.doc")
                        .font(.system(size: 9))
                        .foregroundColor(.ttTextTertiary)
                }
                .buttonStyle(.plain)
                .transition(.opacity)
                .padding(.trailing, 4)
            }
        }
        .frame(minHeight: 26)
        .padding(.horizontal, 6)
        .padding(.vertical, 1)
        .background(rowBackground(node, rowIndex: rowIndex))
        .contentShape(Rectangle())
        .onHover { isHovered in
            withAnimation(.easeInOut(duration: 0.1)) {
                hoveredNodeId = isHovered ? node.id : nil
            }
        }
        .onTapGesture {
            selectedNodePath = node.path
            if node.isCollapsible { toggleCollapse(node.path) }
        }
        .contextMenu { nodeContextMenu(node) }
    }
    
    // MARK: - Type Badge
    private func typeBadge(_ type: JSONValueType) -> some View {
        Text(type.badge)
            .font(.system(size: 9, weight: .bold, design: .monospaced))
            .foregroundColor(type.badgeColor)
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .background(
                RoundedRectangle(cornerRadius: 3)
                    .fill(type.badgeColor.opacity(0.1))
            )
    }
    
    // MARK: - Value Display
    private func valueText(_ value: String, type: JSONValueType?) -> some View {
        let color: Color = {
            guard let t = type else { return .ttTextPrimary }
            switch t {
            case .string: return .ttJsonString
            case .number: return .ttJsonNumber
            case .boolean: return .ttJsonBool
            case .null: return .ttJsonNull
            default: return .ttTextPrimary
            }
        }()
        
        let isMatch = isSearchMatch(value)
        
        return Text(value)
            .font(TTFont.codeMedium)
            .foregroundColor(isMatch ? .ttPrimary : color)
            .fontWeight(isMatch ? .bold : .regular)
            .textSelection(.enabled)
    }
    
    // MARK: - Container Count Badge
    private func containerCount(_ count: Int, type: JSONValueType?) -> some View {
        let label: String
        if case .array = type {
            label = "\(count) item\(count == 1 ? "" : "s")"
        } else {
            label = "\(count) key\(count == 1 ? "" : "s")"
        }
        
        return Text(label)
            .font(TTFont.codeSmall)
            .foregroundColor(.ttTextTertiary)
    }
    
    // MARK: - Row Background
    private func rowBackground(_ node: FlatTreeNode, rowIndex: Int) -> some View {
        Group {
            if selectedNodePath == node.path && !node.path.isEmpty {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.ttPrimary.opacity(0.1))
            } else if hoveredNodeId == node.id {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.ttSurface.opacity(0.6))
            } else if isNodeSearchMatch(node) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.ttWarning.opacity(0.06))
            } else if rowIndex % 2 == 1 {
                // Alternating row bg (zebra stripe)
                RoundedRectangle(cornerRadius: 0)
                    .fill(Color.ttSurface.opacity(0.08))
            } else {
                Color.clear
            }
        }
    }
    
    // MARK: - Context Menu
    @ViewBuilder
    private func nodeContextMenu(_ node: FlatTreeNode) -> some View {
        if !node.path.isEmpty {
            if let key = node.key {
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(key, forType: .string)
                }) {
                    Label("Copy Key", systemImage: "textformat")
                }
            }
            
            if let rawValue = node.rawValue ?? node.displayValue {
                Button(action: {
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(rawValue, forType: .string)
                }) {
                    Label("Copy Value", systemImage: "doc.on.doc")
                }
            }
            
            Button(action: {
                let jsonPath = "$" + node.path.replacingOccurrences(of: "root", with: "")
                NSPasteboard.general.clearContents()
                NSPasteboard.general.setString(jsonPath.isEmpty ? "$" : jsonPath, forType: .string)
            }) {
                Label("Copy JSONPath", systemImage: "point.topleft.down.to.point.bottomright.curvepath")
            }
            
            Divider()
            
            if node.isCollapsible {
                Button(action: { expandChildren(node.path) }) {
                    Label("Expand Children", systemImage: "arrow.down.right.and.arrow.up.left")
                }
                Button(action: { collapseChildren(node.path) }) {
                    Label("Collapse Children", systemImage: "arrow.up.left.and.arrow.down.right")
                }
                Divider()
                Button(action: { collapseSiblings(of: node.path) }) {
                    Label("Collapse Siblings", systemImage: "line.3.horizontal.decrease")
                }
            }
        }
    }
    
    // MARK: - Search Helpers
    
    private func isSearchMatch(_ text: String) -> Bool {
        guard !searchText.isEmpty else { return false }
        return text.localizedCaseInsensitiveContains(searchText)
    }
    
    private func isNodeSearchMatch(_ node: FlatTreeNode) -> Bool {
        guard !searchText.isEmpty else { return false }
        if let key = node.key, key.localizedCaseInsensitiveContains(searchText) { return true }
        if let val = node.displayValue, val.localizedCaseInsensitiveContains(searchText) { return true }
        if let raw = node.rawValue, raw.localizedCaseInsensitiveContains(searchText) { return true }
        return false
    }
    
    // MARK: - Data Actions
    
    private func parseJSON() async {
        let input = jsonString
        let parsed = await Task.detached(priority: .userInitiated) {
            guard let data = input.data(using: .utf8) else { return nil as Any? }
            return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        }.value
        parsedTree = parsed
        isParsed = true
        await updateSearchMatches()
    }
    
    private func updateSearchMatches() async {
        guard !searchText.isEmpty, let parsed = parsedTree else {
            searchMatchCount = 0
            matchedNodeIds = []
            return
        }
        let nodes = JSONTreeFlattener.flatten(parsed, collapsedPaths: [], searchTerm: searchText)
        let matches = nodes.filter { isNodeSearchMatch($0) }
        searchMatchCount = matches.count
        matchedNodeIds = matches.map(\.id)
        currentMatchIndex = 0
    }
    
    private func toggleCollapse(_ path: String) {
        if collapsedPaths.contains(path) {
            collapsedPaths.remove(path)
        } else {
            collapsedPaths.insert(path)
        }
        collapseLevel = -2
    }
    
    private func collapseToLevel(_ level: Int) {
        guard let parsed = parsedTree else { return }
        collapseLevel = level
        
        if level == -1 {
            collapsedPaths.removeAll()
        } else {
            var allPaths = Set<String>()
            collectPaths(parsed, path: "root", depth: 0, paths: &allPaths)
            
            if level == 0 {
                collapsedPaths = allPaths
            } else {
                var toCollapse = Set<String>()
                collectPathsAtDepth(parsed, path: "root", depth: 0, maxDepth: level, paths: &toCollapse)
                collapsedPaths = toCollapse
            }
        }
    }
    
    private func expandChildren(_ parentPath: String) {
        collapsedPaths = collapsedPaths.filter { !$0.hasPrefix(parentPath) }
    }
    
    private func collapseChildren(_ parentPath: String) {
        guard let parsed = parsedTree else { return }
        var childPaths = Set<String>()
        collectPaths(parsed, path: "root", depth: 0, paths: &childPaths)
        let children = childPaths.filter { $0.hasPrefix(parentPath) && $0 != parentPath }
        collapsedPaths.formUnion(children)
    }
    
    private func collapseSiblings(of path: String) {
        let components = path.components(separatedBy: ".")
        guard components.count > 1 else { return }
        let parentPath = components.dropLast().joined(separator: ".")
        
        guard let parsed = parsedTree else { return }
        var allPaths = Set<String>()
        collectPaths(parsed, path: "root", depth: 0, paths: &allPaths)
        
        let siblings = allPaths.filter { p in
            let pComponents = p.components(separatedBy: ".")
            return pComponents.count == components.count &&
                   pComponents.dropLast().joined(separator: ".") == parentPath &&
                   p != path
        }
        collapsedPaths.formUnion(siblings)
    }
    
    private func navigateMatch(_ direction: Int) {
        guard !matchedNodeIds.isEmpty else { return }
        currentMatchIndex = (currentMatchIndex + direction + matchedNodeIds.count) % matchedNodeIds.count
    }
    
    // MARK: - Path Helpers
    
    private func collectPaths(_ value: Any, path: String, depth: Int, paths: inout Set<String>) {
        if let dict = value as? [String: Any] {
            paths.insert(path)
            for (k, v) in dict {
                collectPaths(v, path: "\(path).\(k)", depth: depth + 1, paths: &paths)
            }
        } else if let arr = value as? [Any] {
            paths.insert(path)
            for (i, v) in arr.enumerated() {
                collectPaths(v, path: "\(path)[\(i)]", depth: depth + 1, paths: &paths)
            }
        }
    }
    
    private func collectPathsAtDepth(_ value: Any, path: String, depth: Int, maxDepth: Int, paths: inout Set<String>) {
        if let dict = value as? [String: Any] {
            if depth >= maxDepth { paths.insert(path) }
            for (k, v) in dict {
                collectPathsAtDepth(v, path: "\(path).\(k)", depth: depth + 1, maxDepth: maxDepth, paths: &paths)
            }
        } else if let arr = value as? [Any] {
            if depth >= maxDepth { paths.insert(path) }
            for (i, v) in arr.enumerated() {
                collectPathsAtDepth(v, path: "\(path)[\(i)]", depth: depth + 1, maxDepth: maxDepth, paths: &paths)
            }
        }
    }
    
    private func countNodes(_ value: Any) -> Int {
        JSONEditorViewModel.countNodes(value)
    }
    
    private func indentColor(for level: Int) -> Color {
        let colors: [Color] = [
            .ttPrimary.opacity(0.15),
            .ttSuccess.opacity(0.12),
            .ttWarning.opacity(0.12),
            .ttJsonString.opacity(0.12),
            .ttJsonBool.opacity(0.12),
            .ttInfo.opacity(0.12),
        ]
        return colors[level % colors.count]
    }
}
