//
//  JSONQueryEngine.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  JSONPath query parser + evaluator
//  Supports: $, .key, [n], [*], ..key (recursive descent)
//

import Foundation

enum JSONQueryEngine {
    
    /// Execute a JSONPath query against a JSON string
    static func query(_ jsonString: String, path: String) -> QueryResult {
        guard let data = jsonString.data(using: .utf8),
              let root = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            return QueryResult(matches: [], error: "Invalid JSON input")
        }
        
        let segments = parsePath(path)
        guard !segments.isEmpty else {
            return QueryResult(matches: [], error: "Invalid JSONPath expression")
        }
        
        var results: [QueryMatch] = []
        evaluate(root, segments: Array(segments.dropFirst()), // Drop '$' root
                 currentPath: "$", results: &results)
        
        return QueryResult(matches: results, error: nil)
    }
    
    /// Parse JSONPath into segments
    private static func parsePath(_ path: String) -> [PathSegment] {
        var segments: [PathSegment] = []
        var remaining = path.trimmingCharacters(in: .whitespaces)
        
        guard remaining.hasPrefix("$") else { return [] }
        segments.append(.root)
        remaining = String(remaining.dropFirst())
        
        while !remaining.isEmpty {
            // Recursive descent ..
            if remaining.hasPrefix("..") {
                remaining = String(remaining.dropFirst(2))
                let key = consumeKey(&remaining)
                if !key.isEmpty {
                    segments.append(.recursive(key))
                }
                continue
            }
            
            // Dot accessor
            if remaining.hasPrefix(".") {
                remaining = String(remaining.dropFirst())
                let key = consumeKey(&remaining)
                if !key.isEmpty {
                    segments.append(.key(key))
                }
                continue
            }
            
            // Bracket accessor
            if remaining.hasPrefix("[") {
                remaining = String(remaining.dropFirst())
                if remaining.hasPrefix("*") {
                    remaining = String(remaining.dropFirst())
                    if remaining.hasPrefix("]") { remaining = String(remaining.dropFirst()) }
                    segments.append(.wildcard)
                } else if let idx = consumeNumber(&remaining) {
                    if remaining.hasPrefix("]") { remaining = String(remaining.dropFirst()) }
                    segments.append(.index(idx))
                } else {
                    // Quoted key ["key"]
                    let key = consumeQuotedKey(&remaining)
                    if !key.isEmpty {
                        if remaining.hasPrefix("]") { remaining = String(remaining.dropFirst()) }
                        segments.append(.key(key))
                    } else {
                        break // Can't parse this bracket notation
                    }
                }
                continue
            }
            
            break // Can't parse further
        }
        
        return segments
    }
    
    private static func consumeKey(_ str: inout String) -> String {
        var key = ""
        while let c = str.first {
            if c == "." || c == "[" { break }
            key.append(c)
            str = String(str.dropFirst())
        }
        return key
    }
    
    private static func consumeQuotedKey(_ str: inout String) -> String {
        guard let quoteChar = str.first, (quoteChar == "\"" || quoteChar == "'") else {
            return consumeKey(&str)
        }
        str = String(str.dropFirst())
        var key = ""
        while let c = str.first, c != quoteChar {
            key.append(c)
            str = String(str.dropFirst())
        }
        // Consume closing quote if present
        if str.first == quoteChar {
            str = String(str.dropFirst())
        }
        return key
    }
    
    private static func consumeNumber(_ str: inout String) -> Int? {
        var numStr = ""
        while let c = str.first, c.isNumber {
            numStr.append(c)
            str = String(str.dropFirst())
        }
        return numStr.isEmpty ? nil : Int(numStr)
    }
    
    // MARK: - Evaluation
    
    private static func evaluate(
        _ value: Any,
        segments: [PathSegment],
        currentPath: String,
        results: inout [QueryMatch]
    ) {
        guard !segments.isEmpty else {
            results.append(QueryMatch(path: currentPath, value: stringify(value)))
            return
        }
        
        let segment = segments[0]
        let rest = Array(segments.dropFirst())
        
        switch segment {
        case .root:
            evaluate(value, segments: rest, currentPath: currentPath, results: &results)
            
        case .key(let key):
            if let dict = value as? [String: Any], let child = dict[key] {
                evaluate(child, segments: rest, currentPath: "\(currentPath).\(key)", results: &results)
            }
            
        case .index(let idx):
            if let arr = value as? [Any], idx >= 0 && idx < arr.count {
                evaluate(arr[idx], segments: rest, currentPath: "\(currentPath)[\(idx)]", results: &results)
            }
            
        case .wildcard:
            if let dict = value as? [String: Any] {
                for (k, v) in dict.sorted(by: { $0.key < $1.key }) {
                    evaluate(v, segments: rest, currentPath: "\(currentPath).\(k)", results: &results)
                }
            } else if let arr = value as? [Any] {
                for (i, v) in arr.enumerated() {
                    evaluate(v, segments: rest, currentPath: "\(currentPath)[\(i)]", results: &results)
                }
            }
            
        case .recursive(let key):
            // Search recursively through all children
            recursiveSearch(value, key: key, rest: rest, currentPath: currentPath, results: &results)
        }
    }
    
    private static func recursiveSearch(
        _ value: Any,
        key: String,
        rest: [PathSegment],
        currentPath: String,
        results: inout [QueryMatch]
    ) {
        if let dict = value as? [String: Any] {
            if let match = dict[key] {
                evaluate(match, segments: rest, currentPath: "\(currentPath).\(key)", results: &results)
            }
            for (k, v) in dict {
                recursiveSearch(v, key: key, rest: rest, currentPath: "\(currentPath).\(k)", results: &results)
            }
        } else if let arr = value as? [Any] {
            for (i, v) in arr.enumerated() {
                recursiveSearch(v, key: key, rest: rest, currentPath: "\(currentPath)[\(i)]", results: &results)
            }
        }
    }
    
    // MARK: - Stringify
    
    static func stringify(_ value: Any) -> String {
        if let str = value as? String { return "\"\(str)\"" }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        }
        if value is NSNull { return "null" }
        
        // Try to pretty-print objects/arrays
        if JSONSerialization.isValidJSONObject(value),
           let data = try? JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        
        return "\(value)"
    }
}

// MARK: - Path Segment
enum PathSegment {
    case root
    case key(String)
    case index(Int)
    case wildcard
    case recursive(String)
}

// MARK: - Query Result
struct QueryResult {
    let matches: [QueryMatch]
    let error: String?
    
    var count: Int { matches.count }
    var isEmpty: Bool { matches.isEmpty }
}

struct QueryMatch: Identifiable {
    let id = UUID()
    let path: String
    let value: String
}
