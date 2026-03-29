//
//  JSONGraphModels.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Data models for graph-based JSON visualization
//

import SwiftUI

// MARK: - Graph Node
struct GraphNode: Identifiable {
    let id: String
    let label: String               // Key name or array index
    let valueType: JSONValueType
    let entries: [(key: String, value: String, type: JSONValueType)]  // Key-value pairs for objects
    var position: CGPoint = .zero   // Calculated by layout engine
    var size: CGSize = .zero        // Based on content
    var isCollapsed: Bool = false
    var childIds: [String] = []     // Child node IDs
    var parentId: String?
    var depth: Int = 0
    
    // Display properties
    var headerColor: Color {
        valueType.badgeColor
    }
    
    var nodeWidth: CGFloat {
        let minWidth: CGFloat = 140
        let maxWidth: CGFloat = 280
        
        if entries.isEmpty {
            let textWidth = CGFloat(label.count * 8) + 60
            return max(minWidth, min(textWidth, maxWidth))
        }
        
        let maxEntryLen = entries.map { $0.key.count + $0.value.count + 4 }.max() ?? 10
        let contentWidth = CGFloat(maxEntryLen * 7) + 40
        return max(minWidth, min(contentWidth, maxWidth))
    }
    
    var nodeHeight: CGFloat {
        let headerHeight: CGFloat = 28
        let maxVisibleEntries = min(entries.count, 8)
        let entryHeight: CGFloat = CGFloat(maxVisibleEntries) * 22
        let padding: CGFloat = maxVisibleEntries > 0 ? 8 : 0
        let truncatedHeight: CGFloat = entries.count > 8 ? 18 : 0
        return headerHeight + entryHeight + padding + truncatedHeight
    }
}

// MARK: - Graph Edge
struct GraphEdge: Identifiable {
    let id: String
    let fromId: String      // Parent node ID
    let toId: String        // Child node ID
}

// MARK: - Graph Layout Result
struct GraphLayout {
    var nodes: [GraphNode]
    var edges: [GraphEdge]
    var totalSize: CGSize   // Bounding rect of entire graph
    
    static let empty = GraphLayout(nodes: [], edges: [], totalSize: .zero)
}
