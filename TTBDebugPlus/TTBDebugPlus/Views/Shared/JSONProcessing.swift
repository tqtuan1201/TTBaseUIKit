//
//  JSONProcessing.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  JSON syntax highlighting, tree flattening, and cURL/Postman generation
//

import SwiftUI
import AppKit

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
    let valueType: JSONValueType?
    let rawValue: String?
    
    // Structured fields for tree view (Phase V3)
    let key: String?            // "name", "[0]", nil for closing brackets
    let displayValue: String?   // "John Doe", "42", nil for containers
    let childCount: Int?        // For objects/arrays: number of children
    let isClosingBracket: Bool  // true for "}" and "]" rows
    
    // Legacy content for backward compat (JSONViewer uses this)
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
            
            // Legacy content for JSONViewer compat
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
            
            nodes.append(FlatTreeNode(
                id: path, indent: indent, path: path,
                isCollapsible: true, isCollapsed: isCollapsed,
                valueType: .object(keyCount: dict.count), rawValue: nil,
                key: key ?? (indent == 0 ? "root" : nil),
                displayValue: nil, childCount: dict.count,
                isClosingBracket: false, content: openText
            ))
            
            if !isCollapsed {
                let sortedKeys = dict.keys.sorted()
                for (i, k) in sortedKeys.enumerated() {
                    if let childValue = dict[k] {
                        flattenValue(childValue, key: k, indent: indent + 1,
                                     path: "\(path).\(k)", isLast: i == sortedKeys.count - 1,
                                     collapsedPaths: collapsedPaths, searchTerm: searchTerm, nodes: &nodes)
                    }
                }
                
                // Closing brace (legacy compat)
                let closeText = Text("}").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
                nodes.append(FlatTreeNode(
                    id: "\(path)_close", indent: indent, path: "",
                    isCollapsible: false, isCollapsed: false,
                    valueType: nil, rawValue: nil,
                    key: nil, displayValue: nil, childCount: nil,
                    isClosingBracket: true, content: closeText
                ))
            }
            
        } else if let arr = value as? [Any] {
            let isCollapsed = collapsedPaths.contains(path)
            
            // Legacy content
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
            
            nodes.append(FlatTreeNode(
                id: path, indent: indent, path: path,
                isCollapsible: true, isCollapsed: isCollapsed,
                valueType: .array(itemCount: arr.count), rawValue: nil,
                key: key ?? (indent == 0 ? "root" : nil),
                displayValue: nil, childCount: arr.count,
                isClosingBracket: false, content: openText
            ))
            
            if !isCollapsed {
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
                        valueType: nil, rawValue: nil,
                        key: "...", displayValue: "+\(arr.count - maxItems) more",
                        childCount: nil, isClosingBracket: false,
                        content: Text("... (\(arr.count - maxItems) more items)")
                            .foregroundColor(.ttTextTertiary).italic()
                    ))
                }
                
                // Closing bracket (legacy compat)
                let closeText = Text("]").foregroundColor(.ttJsonBrace) +
                    Text(isLast ? "" : ",").foregroundColor(.ttJsonBrace)
                nodes.append(FlatTreeNode(
                    id: "\(path)_close", indent: indent, path: "",
                    isCollapsible: false, isCollapsed: false,
                    valueType: nil, rawValue: nil,
                    key: nil, displayValue: nil, childCount: nil,
                    isClosingBracket: true, content: closeText
                ))
            }
            
        } else {
            // Leaf node
            let leafType = detectValueType(value)
            let rawStr = leafRawValue(value)
            let displayStr = leafDisplayValue(value)
            
            // Determine key for array items
            let nodeKey: String?
            if let key = key {
                nodeKey = key
            } else {
                // Array item — extract index from path
                if let bracketRange = path.range(of: "[", options: .backwards) {
                    nodeKey = String(path[bracketRange.lowerBound...])
                } else {
                    nodeKey = nil
                }
            }
            
            // Legacy content for JSONViewer compat
            var leafContent = Text("")
            if let key = key {
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
            
            nodes.append(FlatTreeNode(
                id: path, indent: indent, path: path,
                isCollapsible: false, isCollapsed: false,
                valueType: leafType, rawValue: rawStr,
                key: nodeKey, displayValue: displayStr,
                childCount: nil, isClosingBracket: false,
                content: leafContent
            ))
        }
    }
    
    private static func detectValueType(_ value: Any) -> JSONValueType {
        if value is String { return .string }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return .boolean(num.boolValue)
            }
            return .number
        }
        if value is NSNull { return .null }
        return .string // fallback
    }
    
    private static func leafRawValue(_ value: Any) -> String {
        if let str = value as? String { return str }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        }
        if value is NSNull { return "null" }
        return "\(value)"
    }
    
    private static func leafDisplayValue(_ value: Any) -> String {
        if let str = value as? String { return str }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        }
        if value is NSNull { return "null" }
        return "\(value)"
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

// MARK: - NSAttributedString-based JSON Highlighter (for NSTextView, large payloads)
/// Uses regex-based token matching on pretty-printed JSON.
/// Produces a single NSAttributedString — no SwiftUI view nodes, O(n) performance.
enum JSONAttributedHighlighter {
    
    /// Highlight JSON string and return NSAttributedString. Safe for background thread.
    static func highlight(_ jsonString: String, searchTerm: String = "") -> NSAttributedString {
        // Pretty-print JSON first
        let prettyJSON: String
        if let data = jsonString.data(using: .utf8),
           let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
           let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
           let str = String(data: pretty, encoding: .utf8) {
            prettyJSON = str
        } else {
            prettyJSON = jsonString
        }
        
        let defaultAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.monospacedSystemFont(ofSize: 12, weight: .regular),
            .foregroundColor: NSColor(Color.ttTextPrimary)
        ]
        
        let result = NSMutableAttributedString(string: prettyJSON, attributes: defaultAttrs)
        let fullRange = NSRange(location: 0, length: result.length)
        
        // 1. Highlight strings (keys and values)
        applyRegex("\"(?:[^\"\\\\]|\\\\.)*\"", to: result, in: fullRange) { matchRange in
            // Check if this string is a key (followed by ' :')
            let afterMatch = matchRange.location + matchRange.length
            let isKey: Bool
            if afterMatch + 2 <= result.length {
                let afterStr = (result.string as NSString).substring(with: NSRange(location: afterMatch, length: min(3, result.length - afterMatch)))
                isKey = afterStr.hasPrefix(" :")
            } else {
                isKey = false
            }
            return [.foregroundColor: isKey ? NSColor(Color.ttJsonKey) : NSColor(Color.ttJsonString)]
        }
        
        // 2. Highlight numbers (standalone, not inside strings)
        applyRegex("(?<=[ :\\[,])(-?\\d+\\.?\\d*(?:[eE][+-]?\\d+)?)(?=[,\\s\\]\\}])", to: result, in: fullRange) { _ in
            [.foregroundColor: NSColor(Color.ttJsonNumber)]
        }
        
        // 3. Highlight booleans
        applyRegex("(?<=[ :\\[,])(true|false)(?=[,\\s\\]\\}])", to: result, in: fullRange) { _ in
            [.foregroundColor: NSColor(Color.ttJsonBool)]
        }
        
        // 4. Highlight null
        applyRegex("(?<=[ :\\[,])(null)(?=[,\\s\\]\\}])", to: result, in: fullRange) { _ in
            [
                .foregroundColor: NSColor(Color.ttJsonNull),
                .obliqueness: 0.15 as NSNumber  // Italic effect
            ]
        }
        
        // 5. Highlight braces/brackets
        applyRegex("[{}\\[\\]]", to: result, in: fullRange) { _ in
            [.foregroundColor: NSColor(Color.ttJsonBrace)]
        }
        
        // 6. Highlight colons and commas
        applyRegex("[,:]", to: result, in: fullRange) { _ in
            [.foregroundColor: NSColor(Color.ttJsonBrace)]
        }
        
        // 7. Search term highlighting
        if !searchTerm.isEmpty {
            highlightSearchTerm(searchTerm, in: result)
        }
        
        return result
    }
    
    // MARK: - Regex Helper
    
    private static func applyRegex(
        _ pattern: String,
        to attrStr: NSMutableAttributedString,
        in range: NSRange,
        attributes: (NSRange) -> [NSAttributedString.Key: Any]
    ) {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return }
        let matches = regex.matches(in: attrStr.string, options: [], range: range)
        for match in matches {
            let attrs = attributes(match.range)
            attrStr.addAttributes(attrs, range: match.range)
        }
    }
    
    // MARK: - Search Highlight
    
    private static func highlightSearchTerm(_ term: String, in attrStr: NSMutableAttributedString) {
        let searchStr = attrStr.string as NSString
        var searchRange = NSRange(location: 0, length: searchStr.length)
        
        while searchRange.location < searchStr.length {
            let foundRange = searchStr.range(
                of: term,
                options: .caseInsensitive,
                range: searchRange
            )
            
            if foundRange.location == NSNotFound { break }
            
            attrStr.addAttributes([
                .backgroundColor: NSColor(Color.ttPrimary).withAlphaComponent(0.3),
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ], range: foundRange)
            
            searchRange.location = foundRange.location + foundRange.length
            searchRange.length = searchStr.length - searchRange.location
        }
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
