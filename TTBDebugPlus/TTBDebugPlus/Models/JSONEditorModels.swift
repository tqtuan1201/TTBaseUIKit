//
//  JSONEditorModels.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Models for the JSON Editor feature
//

import SwiftUI

// MARK: - Editor Mode
enum JSONEditMode: String, CaseIterable, Identifiable {
    case code = "Code"
    case tree = "Tree"
    case split = "Split"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .code: return "chevron.left.forwardslash.chevron.right"
        case .tree: return "list.bullet.indent"
        case .split: return "rectangle.split.2x1"
        }
    }
}

// MARK: - Editor Sub-Tab (tools within editor)
enum JSONEditorTab: String, CaseIterable, Identifiable {
    case editor = "Editor"
    case query = "Query"
    case diff = "Diff"
    case convert = "Convert"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .editor: return "doc.text"
        case .query: return "magnifyingglass"
        case .diff: return "rectangle.on.rectangle"
        case .convert: return "arrow.triangle.swap"
        }
    }
}

// MARK: - Dev Tools Category
enum DevTool: String, CaseIterable, Identifiable {
    case jsonEditor = "JSON Editor"
    case base64 = "Base64"
    case urlEncode = "URL Encode"
    case hashGenerator = "Hash"
    case timestamp = "Timestamp"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .jsonEditor: return "curlybraces"
        case .base64: return "textformat.abc"
        case .urlEncode: return "link"
        case .hashGenerator: return "number"
        case .timestamp: return "clock"
        }
    }
    
    var isAvailable: Bool {
        switch self {
        case .jsonEditor: return true
        default: return false
        }
    }
}

// MARK: - Validation Error
struct JSONValidationError: Identifiable {
    let id = UUID()
    let line: Int
    let column: Int
    let message: String
    let severity: Severity
    
    enum Severity {
        case error, warning
        
        var color: Color {
            switch self {
            case .error: return .ttError
            case .warning: return .ttWarning
            }
        }
        
        var icon: String {
            switch self {
            case .error: return "xmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            }
        }
    }
}

// MARK: - Editor Payload (from external views)
struct JSONEditorPayload: Equatable {
    let json: String
    let sourceLabel: String
    
    static func == (lhs: JSONEditorPayload, rhs: JSONEditorPayload) -> Bool {
        lhs.json == rhs.json && lhs.sourceLabel == rhs.sourceLabel
    }
}

// MARK: - Diff Result
enum DiffNodeType {
    case unchanged
    case added
    case removed
    case changed(old: String, new: String)
    
    var color: Color {
        switch self {
        case .unchanged: return .ttTextPrimary
        case .added: return .ttSuccess
        case .removed: return .ttError
        case .changed: return .ttWarning
        }
    }
    
    var icon: String {
        switch self {
        case .unchanged: return "equal"
        case .added: return "plus.circle"
        case .removed: return "minus.circle"
        case .changed: return "arrow.triangle.2.circlepath"
        }
    }
}

struct DiffNode: Identifiable {
    let id = UUID()
    let path: String
    let key: String
    let type: DiffNodeType
    let indent: Int
    let leftValue: String?
    let rightValue: String?
}

// MARK: - Convert Format
enum ConvertFormat: String, CaseIterable, Identifiable {
    case json = "JSON"
    case yaml = "YAML"
    case xml = "XML"
    case csv = "CSV"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .json: return "curlybraces"
        case .yaml: return "doc.plaintext"
        case .xml: return "chevron.left.forwardslash.chevron.right"
        case .csv: return "tablecells"
        }
    }
    
    var fileExtension: String { rawValue.lowercased() }
}
