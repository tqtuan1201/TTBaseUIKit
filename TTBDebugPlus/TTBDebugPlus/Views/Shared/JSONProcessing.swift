//
//  JSONProcessing.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  JSON syntax highlighting, tree flattening, and cURL/Postman generation
//

import SwiftUI

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
