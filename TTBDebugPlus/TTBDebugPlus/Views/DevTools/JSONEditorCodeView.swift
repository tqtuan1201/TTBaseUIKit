//
//  JSONEditorCodeView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  NSTextView wrapper: editable code editor with JSON syntax highlighting, line numbers
//

import SwiftUI
import AppKit

// MARK: - NSTextView Code Editor
struct JSONEditorCodeView: NSViewRepresentable {
    @Binding var text: String
    var isEditable: Bool = true
    var fontSize: CGFloat = 13
    var onTextChange: ((String) -> Void)? = nil
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        scrollView.drawsBackground = true
        scrollView.backgroundColor = NSColor(Color.ttBackground)
        
        let textView = JSONTextView()
        textView.delegate = context.coordinator
        textView.isEditable = isEditable
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = false
        textView.usesFontPanel = false
        textView.drawsBackground = true
        textView.backgroundColor = NSColor(Color.ttBackground)
        textView.insertionPointColor = NSColor(Color.ttPrimary)
        textView.selectedTextAttributes = [
            .backgroundColor: NSColor(Color.ttPrimary.opacity(0.3)),
            .foregroundColor: NSColor.white
        ]
        // Left padding for line numbers (ruler adds 44px, add small text inset)
        textView.textContainerInset = NSSize(width: 8, height: 12)
        textView.isAutomaticQuoteSubstitutionEnabled = false
        textView.isAutomaticDashSubstitutionEnabled = false
        textView.isAutomaticTextReplacementEnabled = false
        textView.isAutomaticSpellingCorrectionEnabled = false
        textView.isAutomaticTextCompletionEnabled = false
        
        // Configure text container
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        textView.isHorizontallyResizable = true
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        
        // Font
        let font = NSFont.monospacedSystemFont(ofSize: fontSize, weight: .regular)
        textView.font = font
        textView.typingAttributes = [
            .font: font,
            .foregroundColor: NSColor(Color.ttTextPrimary)
        ]
        
        // IMPORTANT: Add textView to scrollView BEFORE creating ruler
        // (ruler needs enclosingScrollView to be non-nil)
        scrollView.documentView = textView
        
        // Line number ruler — now safe because textView.enclosingScrollView exists
        let rulerView = JSONLineNumberRulerView(textView: textView, scrollView: scrollView)
        scrollView.verticalRulerView = rulerView
        scrollView.hasVerticalRuler = true
        scrollView.rulersVisible = true
        
        // Store reference
        context.coordinator.textView = textView
        context.coordinator.rulerView = rulerView
        
        // Initial content
        textView.string = text
        context.coordinator.applyHighlighting(textView)
        
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = scrollView.documentView as? JSONTextView else { return }
        
        // Avoid re-setting text if coordinator update is in progress
        if !context.coordinator.isUpdating && textView.string != text {
            context.coordinator.isUpdating = true
            let selectedRange = textView.selectedRange()
            textView.string = text
            context.coordinator.applyHighlighting(textView)
            // Restore cursor position safely
            let maxLoc = (textView.string as NSString).length
            let safeLoc = min(selectedRange.location, maxLoc)
            textView.setSelectedRange(NSRange(location: safeLoc, length: 0))
            context.coordinator.isUpdating = false
        }
        
        textView.isEditable = isEditable
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: JSONEditorCodeView
        weak var textView: JSONTextView?
        weak var rulerView: JSONLineNumberRulerView?
        var isUpdating = false
        private var highlightTask: DispatchWorkItem?
        
        init(_ parent: JSONEditorCodeView) {
            self.parent = parent
        }
        
        func textDidChange(_ notification: Notification) {
            guard !isUpdating, let textView = notification.object as? NSTextView else { return }
            isUpdating = true
            parent.text = textView.string
            parent.onTextChange?(textView.string)
            
            // Debounced highlighting
            highlightTask?.cancel()
            let task = DispatchWorkItem { [weak self] in
                guard let self = self, let tv = self.textView else { return }
                self.applyHighlighting(tv)
            }
            highlightTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15, execute: task)
            
            rulerView?.needsDisplay = true
            isUpdating = false
        }
        
        func applyHighlighting(_ textView: NSTextView) {
            guard let textStorage = textView.textStorage else { return }
            let length = textStorage.length
            guard length > 0 else { return }
            
            let fullRange = NSRange(location: 0, length: length)
            let source = textStorage.string
            
            // Limit highlighting to first 100KB for performance
            let highlightLimit = min(length, 100_000)
            let highlightRange = NSRange(location: 0, length: highlightLimit)
            
            textStorage.beginEditing()
            
            // Reset to default
            let font = NSFont.monospacedSystemFont(ofSize: parent.fontSize, weight: .regular)
            textStorage.addAttribute(.foregroundColor, value: NSColor(Color.ttTextPrimary), range: fullRange)
            textStorage.addAttribute(.font, value: font, range: fullRange)
            
            let nsString = source as NSString
            
            // Highlight strings (keys and values)
            highlightStrings(in: nsString, textStorage: textStorage, range: highlightRange)
            
            // Numbers
            let numPattern = "(?<=[:\\[,\\s])(-?\\d+\\.?\\d*(?:[eE][+-]?\\d+)?)"
            highlightPattern(numPattern, in: nsString, textStorage: textStorage, range: highlightRange, color: NSColor(Color.ttJsonNumber))
            
            // Booleans
            highlightPattern("\\b(true|false)\\b", in: nsString, textStorage: textStorage, range: highlightRange, color: NSColor(Color.ttJsonBool))
            
            // Null
            highlightPattern("\\bnull\\b", in: nsString, textStorage: textStorage, range: highlightRange, color: NSColor(Color.ttJsonNull))
            
            // Braces, brackets, colons, commas
            let structChars = CharacterSet(charactersIn: "{}[]:,")
            for i in 0..<highlightLimit {
                let char = nsString.character(at: i)
                if let scalar = Unicode.Scalar(char), structChars.contains(scalar) {
                    textStorage.addAttribute(.foregroundColor, value: NSColor(Color.ttJsonBrace), range: NSRange(location: i, length: 1))
                }
            }
            
            textStorage.endEditing()
        }
        
        private func highlightStrings(in nsString: NSString, textStorage: NSTextStorage, range: NSRange) {
            guard let regex = try? NSRegularExpression(pattern: "\"(?:[^\"\\\\]|\\\\.)*\"", options: []) else { return }
            let matches = regex.matches(in: nsString as String, options: [], range: range)
            
            for match in matches {
                let matchRange = match.range
                
                // Check if this is a key (followed by whitespace + colon)
                let afterEnd = matchRange.location + matchRange.length
                var isKey = false
                if afterEnd < nsString.length {
                    // Scan forward for colon without creating full substring
                    let scanLimit = min(afterEnd + 10, nsString.length)
                    for idx in afterEnd..<scanLimit {
                        let ch = nsString.character(at: idx)
                        if ch == 0x3A { // ':' character
                            isKey = true
                            break
                        } else if ch != 0x20 && ch != 0x09 { // Not space or tab
                            break
                        }
                    }
                }
                
                let color = isKey ? NSColor(Color.ttJsonKey) : NSColor(Color.ttJsonString)
                textStorage.addAttribute(.foregroundColor, value: color, range: matchRange)
            }
        }
        
        private func highlightPattern(_ pattern: String, in nsString: NSString, textStorage: NSTextStorage, range: NSRange, color: NSColor) {
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return }
            let matches = regex.matches(in: nsString as String, options: [], range: range)
            for match in matches {
                textStorage.addAttribute(.foregroundColor, value: color, range: match.range)
            }
        }
    }
}

// MARK: - Custom NSTextView with bracket handling
class JSONTextView: NSTextView {
    override func insertText(_ string: Any, replacementRange: NSRange) {
        guard let str = string as? String else {
            super.insertText(string, replacementRange: replacementRange)
            return
        }
        
        // Auto-close brackets (but not quotes if already inside a string)
        let bracketPairs: [String: String] = ["{": "}", "[": "]"]
        if let closing = bracketPairs[str] {
            super.insertText(str + closing, replacementRange: replacementRange)
            let newPos = selectedRange().location - closing.count
            if newPos >= 0 {
                setSelectedRange(NSRange(location: newPos, length: 0))
            }
            return
        }
        
        // Auto-close quotes only if not already adjacent to a quote
        if str == "\"" {
            let cursorLoc = selectedRange().location
            let nsStr = self.string as NSString
            let len = nsStr.length
            
            // Don't auto-close if next character is already a quote
            if cursorLoc < len {
                let nextChar = nsStr.character(at: cursorLoc)
                if nextChar == 0x22 { // '"'
                    // Just move cursor past existing quote
                    setSelectedRange(NSRange(location: cursorLoc + 1, length: 0))
                    return
                }
            }
            
            // Don't auto-close if we're inside a string (odd number of unescaped quotes before cursor)
            let textBefore = cursorLoc > 0 ? nsStr.substring(to: cursorLoc) : ""
            let unescapedQuoteCount = textBefore.reduce(into: (count: 0, escaped: false)) { result, ch in
                if ch == "\\" { result.escaped = !result.escaped }
                else {
                    if ch == "\"" && !result.escaped { result.count += 1 }
                    result.escaped = false
                }
            }.count
            
            if unescapedQuoteCount % 2 == 1 {
                // Inside a string — just insert single quote
                super.insertText(str, replacementRange: replacementRange)
                return
            }
            
            // Auto-close
            super.insertText("\"\"", replacementRange: replacementRange)
            let newPos = selectedRange().location - 1
            if newPos >= 0 {
                setSelectedRange(NSRange(location: newPos, length: 0))
            }
            return
        }
        
        // Auto-indent after { or [
        if str == "\n" {
            let currentLine = currentLineContent()
            let indent = currentLine.prefix(while: { $0 == " " })
            let trimmed = currentLine.trimmingCharacters(in: .whitespaces)
            
            var newIndent = String(indent)
            if trimmed.hasSuffix("{") || trimmed.hasSuffix("[") {
                newIndent += "  "
            }
            
            super.insertText("\n" + newIndent, replacementRange: replacementRange)
            return
        }
        
        super.insertText(string, replacementRange: replacementRange)
    }
    
    private func currentLineContent() -> String {
        let text = string
        let nsString = text as NSString
        let length = nsString.length
        
        // Handle empty string
        guard length > 0 else { return "" }
        
        let cursorPos = selectedRange().location
        let safeCursor = max(0, min(cursorPos, length - 1))
        let lineRange = nsString.lineRange(for: NSRange(location: safeCursor, length: 0))
        return nsString.substring(with: lineRange)
    }
}

// MARK: - Line Number Ruler View
class JSONLineNumberRulerView: NSRulerView {
    private weak var associatedTextView: NSTextView?
    
    init(textView: NSTextView, scrollView: NSScrollView) {
        self.associatedTextView = textView
        super.init(scrollView: scrollView, orientation: .verticalRuler)
        self.clientView = textView
        self.ruleThickness = 50
        
        // Observe text changes
        NotificationCenter.default.addObserver(
            self, selector: #selector(textDidChange(_:)),
            name: NSText.didChangeNotification, object: textView
        )
        NotificationCenter.default.addObserver(
            self, selector: #selector(boundsDidChange(_:)),
            name: NSView.boundsDidChangeNotification,
            object: scrollView.contentView
        )
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        needsDisplay = true
    }
    
    @objc private func boundsDidChange(_ notification: Notification) {
        needsDisplay = true
    }
    
    override func drawHashMarksAndLabels(in rect: NSRect) {
        guard let textView = associatedTextView,
              let layoutManager = textView.layoutManager,
              let textContainer = textView.textContainer else { return }
        
        // Background
        NSColor(Color.ttSurface.opacity(0.3)).setFill()
        rect.fill()
        
        // Right border
        NSColor(Color.ttBorder.opacity(0.2)).setStroke()
        let borderPath = NSBezierPath()
        borderPath.move(to: NSPoint(x: bounds.maxX - 0.5, y: rect.minY))
        borderPath.line(to: NSPoint(x: bounds.maxX - 0.5, y: rect.maxY))
        borderPath.lineWidth = 1
        borderPath.stroke()
        
        let font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        let attrs: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor(Color.ttTextMuted)
        ]
        
        let visibleRect = textView.visibleRect
        let totalGlyphs = layoutManager.numberOfGlyphs
        guard totalGlyphs > 0 else {
            // Draw line 1 for empty content
            let lineStr = "1" as NSString
            let strSize = lineStr.size(withAttributes: attrs)
            let drawPoint = NSPoint(x: ruleThickness - strSize.width - 8, y: textView.textContainerInset.height)
            lineStr.draw(at: drawPoint, withAttributes: attrs)
            return
        }
        
        let visibleGlyphRange = layoutManager.glyphRange(forBoundingRect: visibleRect, in: textContainer)
        guard visibleGlyphRange.length > 0 else { return }
        let visibleCharRange = layoutManager.characterRange(forGlyphRange: visibleGlyphRange, actualGlyphRange: nil)
        
        let text = textView.string as NSString
        guard visibleCharRange.location + visibleCharRange.length <= text.length else { return }
        
        var lineNumber = 1
        
        // Count lines before visible range
        if visibleCharRange.location > 0 {
            let preRange = NSRange(location: 0, length: min(visibleCharRange.location, text.length))
            text.enumerateSubstrings(in: preRange, options: [.byLines, .substringNotRequired]) { _, _, _, _ in
                lineNumber += 1
            }
        }
        
        // Draw line numbers for visible lines
        text.enumerateSubstrings(in: visibleCharRange, options: [.byLines, .substringNotRequired]) { [weak self] _, substringRange, _, _ in
            guard let self = self else { return }
            
            let glyphRange = layoutManager.glyphRange(forCharacterRange: substringRange, actualCharacterRange: nil)
            guard glyphRange.location < totalGlyphs else { return }
            
            var lineRect = layoutManager.lineFragmentRect(forGlyphAt: glyphRange.location, effectiveRange: nil)
            lineRect.origin.y -= visibleRect.origin.y
            lineRect.origin.y += textView.textContainerInset.height
            
            let lineStr = "\(lineNumber)" as NSString
            let strSize = lineStr.size(withAttributes: attrs)
            let drawPoint = NSPoint(
                x: self.ruleThickness - strSize.width - 8,
                y: lineRect.origin.y + (lineRect.height - strSize.height) / 2
            )
            lineStr.draw(at: drawPoint, withAttributes: attrs)
            
            lineNumber += 1
        }
    }
}
