//
//  JSONEditorTreeView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Interactive tree view with type badges, collapse/expand, node count
//

import SwiftUI

struct JSONEditorTreeView: View {
    let jsonString: String
    var searchText: String = ""
    
    @State private var collapsedPaths: Set<String> = []
    @State private var parsedTree: Any? = nil
    @State private var isParsed: Bool = false
    @State private var hoveredNodeId: String? = nil
    
    var body: some View {
        Group {
            if !isParsed {
                loadingState
            } else if let parsed = parsedTree {
                treeContent(parsed)
            } else {
                invalidState
            }
        }
        .task(id: jsonString.hashValue) {
            await parseJSON()
        }
    }
    
    // MARK: - Loading
    private var loadingState: some View {
        HStack(spacing: 8) {
            ProgressView()
                .scaleEffect(0.6)
            Text("Parsing tree...")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Invalid JSON
    private var invalidState: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(TTFont.heading1)
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
    
    // MARK: - Tree Content
    private func treeContent(_ parsed: Any) -> some View {
        ScrollView([.horizontal, .vertical]) {
            VStack(spacing: 0) {
                // Toolbar
                treeToolbar
                
                // Tree nodes
                LazyVStack(alignment: .leading, spacing: 0) {
                    let nodes = JSONTreeFlattener.flatten(parsed, collapsedPaths: collapsedPaths, searchTerm: searchText)
                    ForEach(nodes) { node in
                        treeNodeRow(node)
                            .id(node.id)
                    }
                }
                .padding(8)
            }
        }
    }
    
    // MARK: - Tree Toolbar
    private var treeToolbar: some View {
        HStack(spacing: 12) {
            Button(action: { collapsedPaths.removeAll() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.down.right.and.arrow.up.left")
                        .font(.ttIcon(TTIcon.sm))
                    Text("Expand All")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(.ttTextSecondary)
            }
            .buttonStyle(.plain)
            
            Button(action: { collapseAll() }) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.ttIcon(TTIcon.sm))
                    Text("Collapse All")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(.ttTextSecondary)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            if let parsed = parsedTree {
                let nodeCount = countNodes(parsed)
                Text("\(nodeCount) nodes")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.ttSurface.opacity(0.2))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.15)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Node Row
    private func treeNodeRow(_ node: FlatTreeNode) -> some View {
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
                        .font(.ttIcon(TTIcon.xxs))
                        .foregroundColor(.ttPrimaryLight)
                        .frame(width: 16, height: 16)
                        .background(
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.ttPrimary.opacity(hoveredNodeId == node.id ? 0.15 : 0.05))
                        )
                }
                .buttonStyle(.plain)
            } else {
                Spacer().frame(width: 16)
            }
            
            // Content
            HStack(spacing: 4) {
                node.content
                    .font(TTFont.codeMedium)
                    .textSelection(.enabled)
            }
            .padding(.leading, 4)
            
            Spacer(minLength: 0)
        }
        .frame(height: 24)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(hoveredNodeId == node.id ? Color.ttSurface.opacity(0.5) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { isHovered in
            hoveredNodeId = isHovered ? node.id : nil
        }
        .onTapGesture {
            if node.isCollapsible { toggleCollapse(node.path) }
        }
    }
    
    // MARK: - Helpers
    
    private func parseJSON() async {
        let input = jsonString
        let parsed = await Task.detached(priority: .userInitiated) {
            guard let data = input.data(using: .utf8) else { return nil as Any? }
            return try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
        }.value
        parsedTree = parsed
        isParsed = true
    }
    
    private func toggleCollapse(_ path: String) {
        if collapsedPaths.contains(path) {
            collapsedPaths.remove(path)
        } else {
            collapsedPaths.insert(path)
        }
    }
    
    private func collapseAll() {
        guard let parsed = parsedTree else { return }
        var paths = Set<String>()
        collectPaths(parsed, path: "root", paths: &paths)
        collapsedPaths = paths
    }
    
    private func collectPaths(_ value: Any, path: String, paths: inout Set<String>) {
        if let dict = value as? [String: Any] {
            paths.insert(path)
            for (k, v) in dict {
                collectPaths(v, path: "\(path).\(k)", paths: &paths)
            }
        } else if let arr = value as? [Any] {
            paths.insert(path)
            for (i, v) in arr.enumerated() {
                collectPaths(v, path: "\(path)[\(i)]", paths: &paths)
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
