//
//  JSONEditorView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Main JSON Editor container: split code + tree, toolbar, error panel
//

import SwiftUI

struct JSONEditorView: View {
    @Bindable var viewModel: JSONEditorViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Toolbar
            JSONEditorToolbar(viewModel: viewModel)
            
            // Source label (when opened from Console/Network)
            if let source = viewModel.sourceLabel {
                sourceBanner(source)
            }
            
            // Validation errors
            if !viewModel.validationErrors.isEmpty {
                errorPanel
            }
            
            // Main content area
            editorContent
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Status bar
            statusBar
        }
        .background(Color.ttBackground)
    }
    
    // MARK: - Source Banner
    private func sourceBanner(_ source: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "arrow.turn.right.down")
                .font(.ttIcon(TTIcon.sm))
                .foregroundColor(.ttPrimaryLight)
            Text("From: \(source)")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttPrimaryLight)
            
            Spacer()
            
            Button(action: { viewModel.sourceLabel = nil }) {
                Image(systemName: "xmark")
                    .font(.ttIcon(TTIcon.xs))
                    .foregroundColor(.ttTextTertiary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 5)
        .background(Color.ttPrimary.opacity(0.06))
        .overlay(
            Rectangle().fill(Color.ttPrimary.opacity(0.15)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Error Panel
    private var errorPanel: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(viewModel.validationErrors) { error in
                HStack(spacing: 8) {
                    Image(systemName: error.severity.icon)
                        .font(.ttIcon(TTIcon.md))
                        .foregroundColor(error.severity.color)
                    
                    Text("Line \(error.line), Col \(error.column)")
                        .font(TTFont.codeMedium)
                        .foregroundColor(error.severity.color)
                        .fontWeight(.semibold)
                    
                    Text(error.message)
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttTextSecondary)
                        .lineLimit(2)
                    
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
            }
        }
        .background(Color.ttError.opacity(0.06))
        .overlay(
            Rectangle().fill(Color.ttError.opacity(0.2)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Editor Content
    @ViewBuilder
    private var editorContent: some View {
        if viewModel.rawJSON.isEmpty && viewModel.sourceLabel == nil {
            emptyState
        } else {
            switch viewModel.editMode {
            case .code:
                codeOnlyView
            case .tree:
                treeOnlyView
            case .split:
                splitView
            case .graph:
                graphView
            }
        }
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 24) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.ttPrimary.opacity(0.08), Color.ttPrimary.opacity(0.02)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 100, height: 100)
                
                Image(systemName: "curlybraces")
                    .font(TTFont.displayLarge)
                    .foregroundColor(.ttPrimary.opacity(0.5))
            }
            
            VStack(spacing: 8) {
                Text("JSON Editor")
                    .font(TTFont.heading2)
                    .foregroundColor(.ttTextPrimary)
                
                Text("Paste, type, or open a JSON file to get started")
                    .font(TTFont.bodyMedium)
                    .foregroundColor(.ttTextTertiary)
            }
            
            HStack(spacing: 12) {
                Button(action: { viewModel.paste() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.on.clipboard")
                        Text("Paste from Clipboard")
                    }
                }
                .buttonStyle(.ttSecondaryCompact)
                
                Button(action: { viewModel.openFile() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "folder")
                        Text("Open File")
                    }
                }
                .buttonStyle(.ttSecondaryCompact)
                
                Button(action: { viewModel.loadSample() }) {
                    HStack(spacing: 6) {
                        Image(systemName: "doc.text.fill")
                        Text("Load Sample")
                    }
                }
                .buttonStyle(.ttPrimaryCompact)
            }
            
            // Quick tips
            VStack(alignment: .leading, spacing: 6) {
                tipRow(icon: "keyboard", text: "⌘V to paste JSON from clipboard")
                tipRow(icon: "text.alignleft", text: "⌥⇧F to format/beautify")
                tipRow(icon: "magnifyingglass", text: "Use the Query tab for JSONPath queries")
                tipRow(icon: "rectangle.on.rectangle", text: "Use the Diff tab to compare two JSONs")
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.ttSurface.opacity(0.3))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.ttBorder.opacity(0.15), lineWidth: 1)
                    )
            )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func tipRow(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.ttIcon(TTIcon.sm))
                .foregroundColor(.ttPrimary)
                .frame(width: 16)
            Text(text)
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextSecondary)
        }
    }
    
    // MARK: - Code Only
    private var codeOnlyView: some View {
        JSONEditorCodeView(text: $viewModel.rawJSON)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Tree Only
    private var treeOnlyView: some View {
        JSONEditorTreeView(jsonString: viewModel.rawJSON, searchText: viewModel.searchText)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Split View
    private var splitView: some View {
        HSplitView {
            JSONEditorCodeView(text: $viewModel.rawJSON)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
            
            JSONEditorTreeView(jsonString: viewModel.rawJSON, searchText: viewModel.searchText)
                .frame(minWidth: 200, maxWidth: .infinity, maxHeight: .infinity)
                .overlay(
                    Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(width: 1),
                    alignment: .leading
                )
        }
    }
    
    // MARK: - Graph View
    private var graphView: some View {
        JSONGraphView(jsonString: viewModel.rawJSON)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Status Bar
    private var statusBar: some View {
        HStack(spacing: 12) {
            // Encoding
            Text("UTF-8")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            Divider().frame(height: 12)
            
            // Indentation
            HStack(spacing: 4) {
                Text("Indent:")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
                Text("\(viewModel.indentation) spaces")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextSecondary)
            }
            
            Spacer()
            
            // Character count
            Text("\(viewModel.characterCount) chars")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            Divider().frame(height: 12)
            
            // Line count
            Text("Ln \(viewModel.lineCount)")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
        .background(Color.ttSurface.opacity(0.3))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(height: 1),
            alignment: .top
        )
    }
}

#Preview {
    JSONEditorView(viewModel: {
        let vm = JSONEditorViewModel()
        vm.loadSample()
        return vm
    }())
    .frame(width: 1000, height: 700)
    .preferredColorScheme(.dark)
}
