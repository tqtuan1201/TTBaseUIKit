//
//  JSONGraphLayoutEngine.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Hierarchical layout algorithm: positions JSON nodes in a top-down tree
//

import SwiftUI

enum JSONGraphLayoutEngine {
    
    // MARK: - Configuration
    private static let horizontalGap: CGFloat = 50
    private static let verticalGap: CGFloat = 70
    private static let maxDepth: Int = 8
    private static let maxNodes: Int = 300
    
    // MARK: - Public API
    
    /// Build graph layout from parsed JSON
    static func layout(from jsonString: String) -> GraphLayout {
        guard let data = jsonString.data(using: .utf8),
              let parsed = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            return .empty
        }
        
        var nodes: [GraphNode] = []
        var edges: [GraphEdge] = []
        var nodeCount = 0
        
        // Build nodes recursively
        buildNodes(value: parsed, key: "root", parentId: nil, depth: 0,
                   nodes: &nodes, edges: &edges, nodeCount: &nodeCount)
        
        guard !nodes.isEmpty else { return .empty }
        
        // Calculate positions using hierarchical layout
        positionNodes(&nodes)
        
        // Calculate total size
        let maxX = nodes.map { $0.position.x + $0.size.width }.max() ?? 0
        let maxY = nodes.map { $0.position.y + $0.size.height }.max() ?? 0
        let totalSize = CGSize(width: maxX + 60, height: maxY + 60)
        
        return GraphLayout(nodes: nodes, edges: edges, totalSize: totalSize)
    }
    
    // MARK: - Node Building
    
    private static func buildNodes(
        value: Any, key: String, parentId: String?, depth: Int,
        nodes: inout [GraphNode], edges: inout [GraphEdge], nodeCount: inout Int
    ) {
        guard nodeCount < maxNodes, depth <= maxDepth else { return }
        
        let nodeId = parentId.map { "\($0).\(key)" } ?? key
        nodeCount += 1
        
        if let dict = value as? [String: Any] {
            // Object node
            var entries: [(key: String, value: String, type: JSONValueType)] = []
            var childKeys: [String] = []
            
            let sortedKeys = dict.keys.sorted()
            for k in sortedKeys {
                guard let v = dict[k] else { continue }
                if v is [String: Any] || v is [Any] {
                    // Complex value → child node
                    childKeys.append(k)
                } else {
                    // Primitive value → inline entry
                    let (displayValue, valueType) = primitiveDisplay(v)
                    entries.append((key: k, value: displayValue, type: valueType))
                }
            }
            
            var node = GraphNode(
                id: nodeId,
                label: key,
                valueType: .object(keyCount: dict.count),
                entries: entries,
                parentId: parentId,
                depth: depth
            )
            node.size = CGSize(width: node.nodeWidth, height: node.nodeHeight)
            
            // Build child nodes for complex values
            var childNodeIds: [String] = []
            for childKey in childKeys {
                guard let childValue = dict[childKey] else { continue }
                let childId = "\(nodeId).\(childKey)"
                childNodeIds.append(childId)
                edges.append(GraphEdge(id: "\(nodeId)->\(childId)", fromId: nodeId, toId: childId))
                buildNodes(value: childValue, key: childKey, parentId: nodeId, depth: depth + 1,
                          nodes: &nodes, edges: &edges, nodeCount: &nodeCount)
            }
            node.childIds = childNodeIds
            nodes.append(node)
            
        } else if let arr = value as? [Any] {
            // Array node
            let limitedCount = min(arr.count, 20) // Limit rendered children
            var entries: [(key: String, value: String, type: JSONValueType)] = []
            var childNodeIds: [String] = []
            
            for i in 0..<limitedCount {
                let item = arr[i]
                if item is [String: Any] || item is [Any] {
                    let childId = "\(nodeId)[\(i)]"
                    childNodeIds.append(childId)
                    edges.append(GraphEdge(id: "\(nodeId)->\(childId)", fromId: nodeId, toId: childId))
                    buildNodes(value: item, key: "[\(i)]", parentId: nodeId, depth: depth + 1,
                              nodes: &nodes, edges: &edges, nodeCount: &nodeCount)
                } else {
                    let (displayValue, valueType) = primitiveDisplay(item)
                    entries.append((key: "[\(i)]", value: displayValue, type: valueType))
                }
            }
            
            if arr.count > limitedCount {
                entries.append((key: "...", value: "+\(arr.count - limitedCount) more", type: .string))
            }
            
            var node = GraphNode(
                id: nodeId,
                label: key,
                valueType: .array(itemCount: arr.count),
                entries: entries,
                parentId: parentId,
                depth: depth
            )
            node.size = CGSize(width: node.nodeWidth, height: node.nodeHeight)
            node.childIds = childNodeIds
            nodes.append(node)
            
        } else {
            // Leaf/primitive — should not normally be root, but handle it
            let (displayValue, valueType) = primitiveDisplay(value)
            var node = GraphNode(
                id: nodeId,
                label: key,
                valueType: valueType,
                entries: [(key: key, value: displayValue, type: valueType)],
                parentId: parentId,
                depth: depth
            )
            node.size = CGSize(width: node.nodeWidth, height: node.nodeHeight)
            nodes.append(node)
        }
    }
    
    // MARK: - Positioning (Hierarchical Top-Down)
    
    private static func positionNodes(_ nodes: inout [GraphNode]) {
        guard !nodes.isEmpty else { return }
        
        // Build lookup
        var nodeMap: [String: Int] = [:]
        for (i, node) in nodes.enumerated() {
            nodeMap[node.id] = i
        }
        
        // Find root (node without parent)
        guard let rootIdx = nodes.firstIndex(where: { $0.parentId == nil }) else { return }
        let rootId = nodes[rootIdx].id
        
        // Calculate subtree widths bottom-up
        var subtreeWidths: [String: CGFloat] = [:]
        calculateSubtreeWidth(rootId, nodes: nodes, nodeMap: nodeMap, widths: &subtreeWidths)
        
        // Position top-down
        let startX: CGFloat = 40
        let startY: CGFloat = 40
        positionSubtree(rootId, x: startX, y: startY, nodes: &nodes, nodeMap: nodeMap, subtreeWidths: subtreeWidths)
    }
    
    private static func calculateSubtreeWidth(_ nodeId: String, nodes: [GraphNode], nodeMap: [String: Int], widths: inout [String: CGFloat]) -> CGFloat {
        guard let idx = nodeMap[nodeId] else { return 0 }
        let node = nodes[idx]
        
        if node.childIds.isEmpty {
            let width = node.size.width
            widths[nodeId] = width
            return width
        }
        
        var totalChildWidth: CGFloat = 0
        for (i, childId) in node.childIds.enumerated() {
            if nodeMap[childId] != nil {
                totalChildWidth += calculateSubtreeWidth(childId, nodes: nodes, nodeMap: nodeMap, widths: &widths)
                if i < node.childIds.count - 1 {
                    totalChildWidth += horizontalGap
                }
            }
        }
        
        let width = max(node.size.width, totalChildWidth)
        widths[nodeId] = width
        return width
    }
    
    private static func positionSubtree(_ nodeId: String, x: CGFloat, y: CGFloat, nodes: inout [GraphNode], nodeMap: [String: Int], subtreeWidths: [String: CGFloat]) {
        guard let idx = nodeMap[nodeId] else { return }
        let node = nodes[idx]
        let subtreeWidth = subtreeWidths[nodeId] ?? node.size.width
        
        // Center this node in its subtree
        let nodeX = x + (subtreeWidth - node.size.width) / 2
        nodes[idx].position = CGPoint(x: nodeX, y: y)
        
        // Position children
        let childY = y + node.size.height + verticalGap
        var childX = x
        
        for childId in node.childIds {
            guard nodeMap[childId] != nil else { continue }
            let childSubtreeWidth = subtreeWidths[childId] ?? 0
            positionSubtree(childId, x: childX, y: childY, nodes: &nodes, nodeMap: nodeMap, subtreeWidths: subtreeWidths)
            childX += childSubtreeWidth + horizontalGap
        }
    }
    
    // MARK: - Helpers
    
    private static func primitiveDisplay(_ value: Any) -> (String, JSONValueType) {
        if let str = value as? String {
            let truncated = str.count > 30 ? String(str.prefix(30)) + "…" : str
            return ("\"\(truncated)\"", .string)
        }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return (num.boolValue ? "true" : "false", .boolean(num.boolValue))
            }
            return ("\(num)", .number)
        }
        if value is NSNull {
            return ("null", .null)
        }
        return ("\(value)", .string)
    }
}
