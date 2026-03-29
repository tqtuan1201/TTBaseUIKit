//
//  HighPerformanceTextView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  NSViewRepresentable wrapper for NSTextView — handles large JSON without freezing
//  Used when payload exceeds SwiftUI Text concatenation performance threshold
//

import SwiftUI
import AppKit

// MARK: - High Performance Text View (AppKit-backed)
/// Uses NSTextView for rendering large attributed strings.
/// SwiftUI's Text concatenation creates one view node per fragment,
/// causing freeze/crash for 50KB+ payloads. NSTextView handles megabytes efficiently.
struct HighPerformanceTextView: NSViewRepresentable {
    let attributedString: NSAttributedString
    let showLineNumbers: Bool
    var backgroundColor: NSColor = NSColor(Color.ttBackground)
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeNSView(context: Context) -> NSScrollView {
        let scrollView = NSScrollView()
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = true
        scrollView.drawsBackground = false
        scrollView.autohidesScrollers = true
        scrollView.borderType = .noBorder
        
        let textView = NSTextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.drawsBackground = true
        textView.backgroundColor = backgroundColor
        textView.isRichText = true
        textView.usesFontPanel = false
        textView.usesRuler = false
        textView.allowsUndo = false
        textView.textContainerInset = NSSize(width: 12, height: 12)
        
        // Performance: allow horizontal scrolling for long lines
        textView.isHorizontallyResizable = true
        textView.textContainer?.widthTracksTextView = false
        textView.textContainer?.containerSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        textView.maxSize = NSSize(
            width: CGFloat.greatestFiniteMagnitude,
            height: CGFloat.greatestFiniteMagnitude
        )
        
        // IMPORTANT: Add textView to scrollView BEFORE creating ruler
        // (ruler needs enclosingScrollView to be non-nil)
        scrollView.documentView = textView
        
        // Line numbers — reuse existing JSONLineNumberRulerView from JSONEditorCodeView
        if showLineNumbers {
            let rulerView = JSONLineNumberRulerView(textView: textView, scrollView: scrollView)
            scrollView.verticalRulerView = rulerView
            scrollView.hasVerticalRuler = true
            scrollView.rulersVisible = true
        }
        
        context.coordinator.textView = textView
        
        return scrollView
    }
    
    func updateNSView(_ scrollView: NSScrollView, context: Context) {
        guard let textView = context.coordinator.textView else { return }
        
        // Only update if content actually changed
        let newHash = attributedString.string.hashValue
        if context.coordinator.lastContentHash != newHash {
            textView.textStorage?.setAttributedString(attributedString)
            textView.backgroundColor = backgroundColor
            context.coordinator.lastContentHash = newHash
        }
    }
    
    class Coordinator {
        weak var textView: NSTextView?
        var lastContentHash: Int = 0
    }
}
