//
//  JSONEditorViewModel.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Core state management for JSON Editor — validate, format, minify, undo/redo, search
//

import SwiftUI

@Observable
class JSONEditorViewModel {
    // MARK: - Editor State
    var rawJSON: String = "" {
        didSet {
            if rawJSON != oldValue {
                isDirty = true
                validateDebounced()
                updateStatsDebounced()
            }
        }
    }
    
    var editMode: JSONEditMode = .split
    var activeTab: JSONEditorTab = .editor
    var isValid: Bool = true
    var validationErrors: [JSONValidationError] = []
    var sourceLabel: String? = nil
    
    // MARK: - Search
    var searchText: String = ""
    var searchMatchCount: Int = 0
    var currentMatchIndex: Int = 0
    
    // MARK: - Stats
    var characterCount: Int = 0
    var lineCount: Int = 0
    var nodeCount: Int = 0
    var isDirty: Bool = false
    
    // MARK: - Undo/Redo
    private var undoStack: [String] = []
    private var redoStack: [String] = []
    private let maxHistory = 50
    
    // MARK: - Debounce
    private var validateTask: Task<Void, Never>?
    private var statsTask: Task<Void, Never>?
    
    // MARK: - Indentation
    var indentation: Int {
        get {
            let stored = UserDefaults.standard.integer(forKey: "jsonIndentation")
            return stored == 0 ? 2 : max(1, min(stored, 8))
        }
        set { UserDefaults.standard.set(newValue, forKey: "jsonIndentation") }
    }
    
    // MARK: - Actions
    
    func loadJSON(_ json: String, source: String? = nil) {
        pushUndo()
        rawJSON = json
        sourceLabel = source
        validate()
    }
    
    func format() {
        guard let data = rawJSON.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
              let pretty = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
              var str = String(data: pretty, encoding: .utf8) else {
            return
        }
        
        // Apply custom indentation if != 4 (JSONSerialization defaults to 4 spaces)
        if indentation != 4 {
            let indent = String(repeating: " ", count: indentation)
            str = str.components(separatedBy: "\n").map { line in
                let leadingSpaces = line.prefix(while: { $0 == " " }).count
                let levels = leadingSpaces / 4
                return String(repeating: indent, count: levels) + line.dropFirst(leadingSpaces)
            }.joined(separator: "\n")
        }
        
        pushUndo()
        rawJSON = str
    }
    
    func minify() {
        guard let data = rawJSON.data(using: .utf8),
              let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed),
              let compact = try? JSONSerialization.data(withJSONObject: obj, options: [.sortedKeys]),
              let str = String(data: compact, encoding: .utf8) else {
            return
        }
        pushUndo()
        rawJSON = str
    }
    
    func validate() {
        validationErrors = []
        guard !rawJSON.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            isValid = true
            return
        }
        
        guard let data = rawJSON.data(using: .utf8) else {
            validationErrors = [JSONValidationError(line: 1, column: 1, message: "Invalid UTF-8 encoding", severity: .error)]
            isValid = false
            return
        }
        
        do {
            _ = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            isValid = true
        } catch let error as NSError {
            let desc = error.localizedDescription
            // Try to extract line/column from error
            let (line, col) = extractPosition(from: rawJSON, errorDesc: desc)
            validationErrors = [JSONValidationError(line: line, column: col, message: desc, severity: .error)]
            isValid = false
        }
    }
    
    func clear() {
        pushUndo()
        rawJSON = ""
        sourceLabel = nil
    }
    
    func copy() {
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(rawJSON, forType: .string)
        #endif
    }
    
    func paste() {
        #if os(macOS)
        if let str = NSPasteboard.general.string(forType: .string) {
            pushUndo()
            rawJSON = str
        }
        #endif
    }
    
    // MARK: - Undo/Redo
    
    func pushUndo() {
        undoStack.append(rawJSON)
        if undoStack.count > maxHistory {
            undoStack.removeFirst()
        }
        redoStack.removeAll()
    }
    
    func undo() {
        guard let prev = undoStack.popLast() else { return }
        redoStack.append(rawJSON)
        rawJSON = prev
    }
    
    func redo() {
        guard let next = redoStack.popLast() else { return }
        undoStack.append(rawJSON)
        rawJSON = next
    }
    
    var canUndo: Bool { !undoStack.isEmpty }
    var canRedo: Bool { !redoStack.isEmpty }
    
    // MARK: - File I/O
    
    func openFile() {
        #if os(macOS)
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.json, .plainText]
        panel.canChooseFiles = true
        panel.canChooseDirectories = false
        panel.begin { response in
            if response == .OK, let url = panel.url {
                if let content = try? String(contentsOf: url, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.loadJSON(content, source: url.lastPathComponent)
                    }
                }
            }
        }
        #endif
    }
    
    func saveFile() {
        #if os(macOS)
        let panel = NSSavePanel()
        panel.nameFieldStringValue = "data.json"
        panel.allowedContentTypes = [.json]
        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? self.rawJSON.write(to: url, atomically: true, encoding: .utf8)
            }
        }
        #endif
    }
    
    // MARK: - Sample Data
    
    func loadSample() {
        let sample = """
        {
          "name": "TTBDebugPlus",
          "version": "1.0.0",
          "description": "Professional iOS debugging companion for macOS",
          "features": [
            "Console Logs",
            "Network Inspector",
            "Device Management",
            "Performance Monitor",
            "JSON Editor"
          ],
          "config": {
            "theme": "dark",
            "indentation": 2,
            "maxLogEntries": 10000,
            "autoConnect": true
          },
          "devices": [
            {
              "id": "device-001",
              "name": "iPhone 15 Pro",
              "os": "iOS 18.0",
              "isConnected": true,
              "metrics": {
                "cpu": 23.5,
                "memory": 156.2,
                "battery": 87
              }
            }
          ],
          "stats": {
            "totalRequests": 1250,
            "avgResponseTime": 245.6,
            "errorRate": 0.02,
            "uptime": null
          }
        }
        """
        loadJSON(sample, source: "Sample Data")
    }
    
    // MARK: - Private Helpers
    
    private func validateDebounced() {
        validateTask?.cancel()
        validateTask = Task { @MainActor in
            try? await Task.sleep(nanoseconds: 200_000_000) // 200ms
            guard !Task.isCancelled else { return }
            validate()
        }
    }
    
    private func updateStatsDebounced() {
        characterCount = rawJSON.count
        lineCount = rawJSON.isEmpty ? 0 : rawJSON.components(separatedBy: "\n").count
        
        // Async node counting for large payloads
        statsTask?.cancel()
        statsTask = Task { @MainActor in
            let input = rawJSON
            let count = await Task.detached(priority: .utility) {
                guard let data = input.data(using: .utf8),
                      let obj = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) else {
                    return 0
                }
                return Self.countNodes(obj)
            }.value
            guard !Task.isCancelled else { return }
            nodeCount = count
        }
    }
    
    static func countNodes(_ value: Any) -> Int {
        if let dict = value as? [String: Any] {
            return 1 + dict.values.reduce(0) { $0 + countNodes($1) }
        } else if let arr = value as? [Any] {
            return 1 + arr.reduce(0) { $0 + countNodes($1) }
        }
        return 1
    }
    
    private func extractPosition(from json: String, errorDesc: String) -> (Int, Int) {
        // NSJSONSerialization errors sometimes include byte offset
        // "...around line X, column Y" or "...at character X"
        let lines = json.components(separatedBy: "\n")
        
        // Try to find "character" mention
        if let range = errorDesc.range(of: "character (\\d+)", options: .regularExpression) {
            let numStr = errorDesc[range].filter { $0.isNumber }
            if let charOffset = Int(numStr), charOffset > 0 {
                var currentOffset = 0
                for (lineIdx, line) in lines.enumerated() {
                    if currentOffset + line.count >= charOffset {
                        return (lineIdx + 1, charOffset - currentOffset + 1)
                    }
                    currentOffset += line.count + 1 // +1 for newline
                }
            }
        }
        
        return (1, 1) // Default to first position
    }
    
    // MARK: - Formatted Size
    var formattedSize: String {
        let bytes = rawJSON.utf8.count
        if bytes < 1024 { return "\(bytes) B" }
        if bytes < 1024 * 1024 { return String(format: "%.1f KB", Double(bytes) / 1024) }
        return String(format: "%.1f MB", Double(bytes) / (1024 * 1024))
    }
}
