//
//  AnnotationHelpers.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Reusable helpers extracted from AnnotationEditorView
//

import SwiftUI

// MARK: - NSTextField-backed TextField
struct AnnotationTextField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    var onCommit: () -> Void = {}
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.stringValue = text
        textField.delegate = context.coordinator
        textField.font = NSFont.systemFont(ofSize: 14)
        textField.isBordered = true
        textField.bezelStyle = .roundedBezel
        textField.backgroundColor = NSColor(Color.ttBackground)
        textField.textColor = NSColor(Color.ttTextPrimary)
        textField.focusRingType = .none
        DispatchQueue.main.async {
            textField.window?.makeFirstResponder(textField)
        }
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: AnnotationTextField
        init(_ parent: AnnotationTextField) { self.parent = parent }
        
        func controlTextDidChange(_ obj: Notification) {
            if let tf = obj.object as? NSTextField { parent.text = tf.stringValue }
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onCommit()
                return true
            }
            return false
        }
    }
}

// MARK: - Scroll Wheel Gesture (macOS)
struct ScrollGestureModifier: ViewModifier {
    let action: (CGFloat) -> Void
    func body(content: Content) -> some View {
        content.background(ScrollGestureView(action: action))
    }
}

struct ScrollGestureView: NSViewRepresentable {
    let action: (CGFloat) -> Void
    func makeNSView(context: Context) -> ScrollGestureNSView {
        let view = ScrollGestureNSView()
        view.action = action
        return view
    }
    func updateNSView(_ nsView: ScrollGestureNSView, context: Context) {
        nsView.action = action
    }
}

class ScrollGestureNSView: NSView {
    var action: ((CGFloat) -> Void)?
    override func scrollWheel(with event: NSEvent) {
        let delta = event.scrollingDeltaY
        if abs(delta) > 0.1 { action?(delta) }
    }
}

extension View {
    func onScrollGesture(action: @escaping (CGFloat) -> Void) -> some View {
        modifier(ScrollGestureModifier(action: action))
    }
}
