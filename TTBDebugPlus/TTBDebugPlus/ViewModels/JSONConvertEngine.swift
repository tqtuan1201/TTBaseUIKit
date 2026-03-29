//
//  JSONConvertEngine.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Format conversion: JSON ↔ YAML, XML, CSV
//

import Foundation

enum JSONConvertEngine {
    
    // MARK: - JSON → YAML
    static func toYAML(_ jsonString: String) -> ConvertResult {
        guard let data = jsonString.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            return ConvertResult(output: "", error: "Invalid JSON input")
        }
        return ConvertResult(output: yamlValue(obj, indent: 0), error: nil)
    }
    
    private static func yamlValue(_ value: Any, indent: Int) -> String {
        let prefix = String(repeating: "  ", count: indent)
        
        if let dict = value as? [String: Any] {
            if dict.isEmpty { return "{}" }
            var lines: [String] = []
            for key in dict.keys.sorted() {
                guard let val = dict[key] else { continue }
                if val is [String: Any] || val is [Any] {
                    lines.append("\(prefix)\(key):")
                    lines.append(yamlValue(val, indent: indent + 1))
                } else {
                    lines.append("\(prefix)\(key): \(yamlScalar(val))")
                }
            }
            return lines.joined(separator: "\n")
        }
        
        if let arr = value as? [Any] {
            if arr.isEmpty { return "[]" }
            var lines: [String] = []
            for item in arr {
                if item is [String: Any] {
                    let yaml = yamlValue(item, indent: indent + 1)
                    let firstLine = yaml.trimmingCharacters(in: .whitespaces)
                    lines.append("\(prefix)- \(firstLine)")
                    let remaining = yaml.components(separatedBy: "\n").dropFirst()
                    for line in remaining {
                        lines.append("  \(line)")
                    }
                } else {
                    lines.append("\(prefix)- \(yamlScalar(item))")
                }
            }
            return lines.joined(separator: "\n")
        }
        
        return "\(prefix)\(yamlScalar(value))"
    }
    
    private static func yamlScalar(_ value: Any) -> String {
        if let str = value as? String {
            if str.contains("\n") || str.contains(":") || str.contains("#") || str.contains("\"") {
                return "\"\(str.replacingOccurrences(of: "\"", with: "\\\""))\""
            }
            return str.isEmpty ? "\"\"" : str
        }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        }
        if value is NSNull { return "null" }
        return "\(value)"
    }
    
    // MARK: - JSON → XML
    static func toXML(_ jsonString: String, rootElement: String = "root") -> ConvertResult {
        guard let data = jsonString.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            return ConvertResult(output: "", error: "Invalid JSON input")
        }
        
        var xml = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        xml += "<\(rootElement)>\n"
        xml += xmlValue(obj, indent: 1, elementName: nil)
        xml += "</\(rootElement)>\n"
        
        return ConvertResult(output: xml, error: nil)
    }
    
    private static func xmlValue(_ value: Any, indent: Int, elementName: String?) -> String {
        let prefix = String(repeating: "  ", count: indent)
        
        if let dict = value as? [String: Any] {
            var lines: [String] = []
            for key in dict.keys.sorted() {
                guard let val = dict[key] else { continue }
                let safeName = xmlSafeName(key)
                if val is [String: Any] || val is [Any] {
                    lines.append("\(prefix)<\(safeName)>")
                    lines.append(xmlValue(val, indent: indent + 1, elementName: safeName))
                    lines.append("\(prefix)</\(safeName)>")
                } else {
                    lines.append("\(prefix)<\(safeName)>\(xmlEscape(val))</\(safeName)>")
                }
            }
            return lines.joined(separator: "\n") + "\n"
        }
        
        if let arr = value as? [Any] {
            let itemName = elementName.map { singularize($0) } ?? "item"
            var lines: [String] = []
            for item in arr {
                if item is [String: Any] || item is [Any] {
                    lines.append("\(prefix)<\(itemName)>")
                    lines.append(xmlValue(item, indent: indent + 1, elementName: itemName))
                    lines.append("\(prefix)</\(itemName)>")
                } else {
                    lines.append("\(prefix)<\(itemName)>\(xmlEscape(item))</\(itemName)>")
                }
            }
            return lines.joined(separator: "\n") + "\n"
        }
        
        return "\(prefix)\(xmlEscape(value))\n"
    }
    
    private static func xmlSafeName(_ name: String) -> String {
        var safe = name.replacingOccurrences(of: " ", with: "_")
        if safe.first?.isNumber == true { safe = "_" + safe }
        return safe
    }
    
    private static func xmlEscape(_ value: Any) -> String {
        let str: String
        if let s = value as? String { str = s }
        else if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                str = num.boolValue ? "true" : "false"
            } else { str = "\(num)" }
        }
        else if value is NSNull { str = "" }
        else { str = "\(value)" }
        
        return str
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
            .replacingOccurrences(of: "\"", with: "&quot;")
    }
    
    private static func singularize(_ name: String) -> String {
        if name.hasSuffix("ies") { return String(name.dropLast(3)) + "y" }
        if name.hasSuffix("ses") || name.hasSuffix("xes") { return String(name.dropLast(2)) }
        if name.hasSuffix("s") && !name.hasSuffix("ss") { return String(name.dropLast()) }
        return name
    }
    
    // MARK: - JSON → CSV
    static func toCSV(_ jsonString: String) -> ConvertResult {
        guard let data = jsonString.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
            return ConvertResult(output: "", error: "Invalid JSON input")
        }
        
        // Must be an array of objects
        guard let arr = obj as? [[String: Any]], !arr.isEmpty else {
            return ConvertResult(output: "", error: "CSV conversion requires an array of objects")
        }
        
        // Collect all keys
        var allKeys = Set<String>()
        for item in arr { allKeys.formUnion(item.keys) }
        let sortedKeys = allKeys.sorted()
        
        // Header
        var csv = sortedKeys.map { csvEscape($0) }.joined(separator: ",") + "\n"
        
        // Rows
        for item in arr {
            let row = sortedKeys.map { key -> String in
                if let val = item[key] {
                    return csvEscape(scalarToString(val))
                }
                return ""
            }
            csv += row.joined(separator: ",") + "\n"
        }
        
        return ConvertResult(output: csv, error: nil)
    }
    
    private static func csvEscape(_ value: String) -> String {
        if value.contains(",") || value.contains("\"") || value.contains("\n") {
            return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
        }
        return value
    }
    
    private static func scalarToString(_ value: Any) -> String {
        if let str = value as? String { return str }
        if let num = value as? NSNumber {
            if CFBooleanGetTypeID() == CFGetTypeID(num) {
                return num.boolValue ? "true" : "false"
            }
            return "\(num)"
        }
        if value is NSNull { return "" }
        // For nested objects/arrays, serialize back to JSON
        if JSONSerialization.isValidJSONObject(value),
           let data = try? JSONSerialization.data(withJSONObject: value, options: []),
           let str = String(data: data, encoding: .utf8) {
            return str
        }
        return "\(value)"
    }
}

// MARK: - Convert Result
struct ConvertResult {
    let output: String
    let error: String?
    
    var isSuccess: Bool { error == nil && !output.isEmpty }
}
