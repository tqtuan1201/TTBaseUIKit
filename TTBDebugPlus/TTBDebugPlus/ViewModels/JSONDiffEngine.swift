//
//  JSONDiffEngine.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Structural JSON diff: recursive tree comparison
//

import Foundation

enum JSONDiffEngine {
    
    /// Compare two JSON strings and return diff nodes
    static func diff(left: String, right: String) -> DiffResult {
        guard let leftData = left.data(using: .utf8),
              let leftObj = try? JSONSerialization.jsonObject(with: leftData, options: .fragmentsAllowed) else {
            return DiffResult(nodes: [], stats: DiffStats(), error: "Invalid JSON on left side")
        }
        
        guard let rightData = right.data(using: .utf8),
              let rightObj = try? JSONSerialization.jsonObject(with: rightData, options: .fragmentsAllowed) else {
            return DiffResult(nodes: [], stats: DiffStats(), error: "Invalid JSON on right side")
        }
        
        var nodes: [DiffNode] = []
        var stats = DiffStats()
        compareValues(leftObj, rightObj, path: "$", key: "root", indent: 0, nodes: &nodes, stats: &stats)
        
        return DiffResult(nodes: nodes, stats: stats, error: nil)
    }
    
    private static func compareValues(
        _ left: Any, _ right: Any,
        path: String, key: String, indent: Int,
        nodes: inout [DiffNode], stats: inout DiffStats
    ) {
        // Both dictionaries
        if let leftDict = left as? [String: Any], let rightDict = right as? [String: Any] {
            compareDicts(leftDict, rightDict, path: path, indent: indent, nodes: &nodes, stats: &stats)
            return
        }
        
        // Both arrays
        if let leftArr = left as? [Any], let rightArr = right as? [Any] {
            compareArrays(leftArr, rightArr, path: path, indent: indent, nodes: &nodes, stats: &stats)
            return
        }
        
        // Leaf comparison
        let leftStr = JSONQueryEngine.stringify(left)
        let rightStr = JSONQueryEngine.stringify(right)
        
        if leftStr == rightStr {
            nodes.append(DiffNode(path: path, key: key, type: .unchanged, indent: indent,
                                  leftValue: leftStr, rightValue: rightStr))
            stats.unchanged += 1
        } else {
            nodes.append(DiffNode(path: path, key: key, type: .changed(old: leftStr, new: rightStr),
                                  indent: indent, leftValue: leftStr, rightValue: rightStr))
            stats.changed += 1
        }
    }
    
    private static func compareDicts(
        _ left: [String: Any], _ right: [String: Any],
        path: String, indent: Int,
        nodes: inout [DiffNode], stats: inout DiffStats
    ) {
        let allKeys = Set(left.keys).union(right.keys).sorted()
        
        for key in allKeys {
            let childPath = "\(path).\(key)"
            
            if let leftVal = left[key], let rightVal = right[key] {
                // Both sides have this key
                compareValues(leftVal, rightVal, path: childPath, key: key, indent: indent + 1,
                             nodes: &nodes, stats: &stats)
            } else if let leftVal = left[key] {
                // Only in left (removed)
                let leftStr = JSONQueryEngine.stringify(leftVal)
                nodes.append(DiffNode(path: childPath, key: key, type: .removed, indent: indent + 1,
                                      leftValue: leftStr, rightValue: nil))
                stats.removed += 1
            } else if let rightVal = right[key] {
                // Only in right (added)
                let rightStr = JSONQueryEngine.stringify(rightVal)
                nodes.append(DiffNode(path: childPath, key: key, type: .added, indent: indent + 1,
                                      leftValue: nil, rightValue: rightStr))
                stats.added += 1
            }
        }
    }
    
    private static func compareArrays(
        _ left: [Any], _ right: [Any],
        path: String, indent: Int,
        nodes: inout [DiffNode], stats: inout DiffStats
    ) {
        let maxLen = max(left.count, right.count)
        
        for i in 0..<maxLen {
            let childPath = "\(path)[\(i)]"
            
            if i < left.count && i < right.count {
                compareValues(left[i], right[i], path: childPath, key: "[\(i)]", indent: indent + 1,
                             nodes: &nodes, stats: &stats)
            } else if i < left.count {
                let leftStr = JSONQueryEngine.stringify(left[i])
                nodes.append(DiffNode(path: childPath, key: "[\(i)]", type: .removed, indent: indent + 1,
                                      leftValue: leftStr, rightValue: nil))
                stats.removed += 1
            } else {
                let rightStr = JSONQueryEngine.stringify(right[i])
                nodes.append(DiffNode(path: childPath, key: "[\(i)]", type: .added, indent: indent + 1,
                                      leftValue: nil, rightValue: rightStr))
                stats.added += 1
            }
        }
    }
}

// MARK: - Diff Result
struct DiffResult {
    let nodes: [DiffNode]
    let stats: DiffStats
    let error: String?
}

struct DiffStats {
    var added: Int = 0
    var removed: Int = 0
    var changed: Int = 0
    var unchanged: Int = 0
    
    var total: Int { added + removed + changed }
    var hasChanges: Bool { total > 0 }
}
