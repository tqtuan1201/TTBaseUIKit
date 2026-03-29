//
//  JSONEditorToolbar.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Professional toolbar for JSON Editor actions
//

import SwiftUI

struct JSONEditorToolbar: View {
    @Bindable var viewModel: JSONEditorViewModel
    @State private var isCopied = false
    @State private var isFormatted = false
    @State private var isMinified = false
    
    var body: some View {
        HStack(spacing: 0) {
            // Left: Mode Picker
            editModePicker
            
            divider
            
            // Center: Actions
            actionButtons
            
            Spacer()
            
            // Right: Search + Stats
            searchField
            
            divider
            
            statsInfo
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.ttSurface.opacity(0.4))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Mode Picker
    private var editModePicker: some View {
        HStack(spacing: 2) {
            ForEach(JSONEditMode.allCases) { mode in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        viewModel.editMode = mode
                    }
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: mode.icon)
                            .font(.ttIcon(TTIcon.sm))
                        Text(mode.rawValue)
                            .font(TTFont.labelSmall)
                    }
                    .foregroundColor(viewModel.editMode == mode ? .white : .ttTextTertiary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(viewModel.editMode == mode ? Color.ttPrimary.opacity(0.5) : Color.clear)
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 4) {
            // Format
            toolbarButton(
                icon: isFormatted ? "checkmark" : "text.alignleft",
                label: isFormatted ? "Done!" : "Format",
                color: isFormatted ? .ttSuccess : .ttTextSecondary,
                shortcut: "⌥⇧F"
            ) {
                viewModel.format()
                flashState($isFormatted)
            }
            .disabled(!viewModel.isValid)
            
            // Minify
            toolbarButton(
                icon: isMinified ? "checkmark" : "arrow.right.arrow.left",
                label: isMinified ? "Done!" : "Minify",
                color: isMinified ? .ttSuccess : .ttTextSecondary,
                shortcut: nil
            ) {
                viewModel.minify()
                flashState($isMinified)
            }
            .disabled(!viewModel.isValid)
            
            divider
            
            // Undo
            toolbarButton(icon: "arrow.uturn.backward", label: nil, color: .ttTextSecondary) {
                viewModel.undo()
            }
            .disabled(!viewModel.canUndo)
            .help("Undo (⌘Z)")
            
            // Redo
            toolbarButton(icon: "arrow.uturn.forward", label: nil, color: .ttTextSecondary) {
                viewModel.redo()
            }
            .disabled(!viewModel.canRedo)
            .help("Redo (⇧⌘Z)")
            
            divider
            
            // Copy
            toolbarButton(
                icon: isCopied ? "checkmark" : "doc.on.doc",
                label: isCopied ? "Copied" : "Copy",
                color: isCopied ? .ttSuccess : .ttTextSecondary
            ) {
                viewModel.copy()
                flashState($isCopied)
            }
            
            // Paste
            toolbarButton(icon: "doc.on.clipboard", label: "Paste", color: .ttTextSecondary) {
                viewModel.paste()
            }
            
            // Clear
            toolbarButton(icon: "trash", label: "Clear", color: .ttTextTertiary) {
                viewModel.clear()
            }
            
            divider
            
            // File Open
            toolbarButton(icon: "folder", label: nil, color: .ttTextSecondary) {
                viewModel.openFile()
            }
            .help("Open File (⌘O)")
            
            // File Save
            toolbarButton(icon: "square.and.arrow.down", label: nil, color: .ttTextSecondary) {
                viewModel.saveFile()
            }
            .help("Save File (⌘S)")
            
            divider
            
            // Sample
            toolbarButton(icon: "doc.text.fill", label: "Sample", color: .ttPrimaryLight) {
                viewModel.loadSample()
            }
        }
    }
    
    // MARK: - Search
    private var searchField: some View {
        HStack(spacing: 6) {
            Image(systemName: "magnifyingglass")
                .font(.ttIcon(TTIcon.sm))
                .foregroundColor(.ttTextTertiary)
            
            TextField("Search...", text: $viewModel.searchText)
                .textFieldStyle(.plain)
                .font(TTFont.codeSmall)
                .frame(maxWidth: 120)
            
            if !viewModel.searchText.isEmpty {
                Button(action: { viewModel.searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.ttIcon(TTIcon.sm))
                        .foregroundColor(.ttTextTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.ttSurface)
        )
    }
    
    // MARK: - Stats
    private var statsInfo: some View {
        HStack(spacing: 12) {
            // Validation indicator
            HStack(spacing: 4) {
                Circle()
                    .fill(viewModel.rawJSON.isEmpty ? Color.ttTextMuted : (viewModel.isValid ? Color.ttSuccess : Color.ttError))
                    .frame(width: 6, height: 6)
                Text(viewModel.rawJSON.isEmpty ? "Empty" : (viewModel.isValid ? "Valid" : "Invalid"))
                    .font(TTFont.labelSmall)
                    .foregroundColor(viewModel.rawJSON.isEmpty ? .ttTextMuted : (viewModel.isValid ? .ttSuccess : .ttError))
            }
            
            // Size
            Text(viewModel.formattedSize)
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            // Lines
            Text("\(viewModel.lineCount) lines")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            // Nodes
            if viewModel.nodeCount > 0 {
                Text("\(viewModel.nodeCount) nodes")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
            }
        }
    }
    
    // MARK: - Helpers
    
    private var divider: some View {
        Divider()
            .frame(height: 16)
            .padding(.horizontal, 6)
    }
    
    private func toolbarButton(
        icon: String,
        label: String? = nil,
        color: Color = .ttTextSecondary,
        shortcut: String? = nil,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.ttIcon(TTIcon.md))
                if let label {
                    Text(label)
                        .font(TTFont.labelSmall)
                }
            }
            .foregroundColor(color)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
        }
        .buttonStyle(.ttGhost)
        .help(shortcut.map { "\(label ?? "") (\($0))" } ?? (label ?? ""))
    }
    
    private func flashState(_ binding: Binding<Bool>) {
        binding.wrappedValue = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            binding.wrappedValue = false
        }
    }
}
