//
//  QuickNoteTextField.swift
//  TTBDebugPlus
//
//  NSTextField-backed text input that properly handles spaces,
//  auto-focuses, and commits on Enter.
//

import SwiftUI

struct QuickNoteTextField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void
    
    func makeNSView(context: Context) -> NSTextField {
        let field = NSTextField()
        field.placeholderString = placeholder
        field.font = .systemFont(ofSize: 12, weight: .medium)
        field.textColor = .white
        field.backgroundColor = .clear
        field.isBordered = false
        field.focusRingType = .none
        field.drawsBackground = false
        field.delegate = context.coordinator
        field.cell?.lineBreakMode = .byTruncatingTail
        field.cell?.isScrollable = true
        
        // Auto-focus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            field.window?.makeFirstResponder(field)
        }
        
        return field
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: QuickNoteTextField
        
        init(_ parent: QuickNoteTextField) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ obj: Notification) {
            if let field = obj.object as? NSTextField {
                parent.text = field.stringValue
            }
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onCommit()
                return true
            }
            if commandSelector == #selector(NSResponder.cancelOperation(_:)) {
                parent.text = ""
                parent.onCommit()
                return true
            }
            return false
        }
    }
}
