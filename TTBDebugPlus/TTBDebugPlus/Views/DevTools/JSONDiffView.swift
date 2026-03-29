//
//  JSONDiffView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Side-by-side JSON diff with color-coded markers
//

import SwiftUI

struct JSONDiffView: View {
    var initialLeft: String = ""
    @State private var leftJSON: String = ""
    @State private var rightJSON: String = ""
    @State private var diffResult: DiffResult?
    @State private var isComputing: Bool = false
    @State private var currentDiffIndex: Int = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            diffHeader
            
            Divider().background(Color.ttBorder.opacity(0.2))
            
            // Input panes
            HSplitView {
                // Left pane
                diffInputPane(title: "Left (Original)", text: $leftJSON, side: .left)
                    .frame(minWidth: 300)
                
                // Right pane
                diffInputPane(title: "Right (Modified)", text: $rightJSON, side: .right)
                    .frame(minWidth: 300)
                    .overlay(
                        Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(width: 1),
                        alignment: .leading
                    )
            }
            .frame(maxHeight: 200)
            
            Divider().background(Color.ttBorder.opacity(0.2))
            
            // Diff results
            diffResultsView
        }
        .background(Color.ttBackground)
        .onAppear {
            if !initialLeft.isEmpty {
                leftJSON = initialLeft
            }
        }
    }
    
    // MARK: - Header
    private var diffHeader: some View {
        HStack(spacing: 12) {
            Image(systemName: "rectangle.on.rectangle")
                .font(.ttIcon(TTIcon.lg))
                .foregroundColor(.ttPrimary)
            
            Text("JSON Compare")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextPrimary)
            
            Spacer()
            
            if let result = diffResult {
                // Stats
                HStack(spacing: 8) {
                    statBadge(count: result.stats.added, label: "Added", color: .ttSuccess)
                    statBadge(count: result.stats.removed, label: "Removed", color: .ttError)
                    statBadge(count: result.stats.changed, label: "Changed", color: .ttWarning)
                }
                
                Divider().frame(height: 14)
                
                // Navigate diffs
                if result.stats.hasChanges {
                    HStack(spacing: 4) {
                        Button(action: { navigateDiff(-1) }) {
                            Image(systemName: "chevron.up")
                                .font(.ttIcon(TTIcon.sm))
                        }
                        .buttonStyle(.ttGhost)
                        
                        Text("\(currentDiffIndex + 1)/\(result.stats.total)")
                            .font(TTFont.codeSmall)
                            .foregroundColor(.ttTextTertiary)
                        
                        Button(action: { navigateDiff(1) }) {
                            Image(systemName: "chevron.down")
                                .font(.ttIcon(TTIcon.sm))
                        }
                        .buttonStyle(.ttGhost)
                    }
                }
            }
            
            // Compare button
            Button(action: executeDiff) {
                HStack(spacing: 4) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .font(.ttIcon(TTIcon.md))
                    Text("Compare")
                        .font(TTFont.labelSmall)
                }
            }
            .buttonStyle(.ttPrimaryCompact)
            .disabled(leftJSON.isEmpty || rightJSON.isEmpty)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
    }
    
    private func statBadge(count: Int, label: String, color: Color) -> some View {
        HStack(spacing: 3) {
            Text("\(count)")
                .font(TTFont.badge)
                .foregroundColor(color)
            Text(label)
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
        }
    }
    
    // MARK: - Input Panes
    private func diffInputPane(title: String, text: Binding<String>, side: DiffSide) -> some View {
        VStack(spacing: 0) {
            // Pane header
            HStack {
                Text(title)
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextSecondary)
                    .tracking(0.8)
                
                Spacer()
                
                Button(action: {
                    if let str = NSPasteboard.general.string(forType: .string) {
                        text.wrappedValue = str
                    }
                }) {
                    HStack(spacing: 3) {
                        Image(systemName: "doc.on.clipboard")
                            .font(.ttIcon(TTIcon.xs))
                        Text("Paste")
                            .font(TTFont.labelSmall)
                    }
                    .foregroundColor(.ttTextTertiary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.ttSurface.opacity(0.2))
            
            // Text input
            TextEditor(text: text)
                .font(Font.system(size: 11, design: .monospaced))
                .scrollContentBackground(.hidden)
                .foregroundColor(.ttTextPrimary)
                .background(Color.ttBackground)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    enum DiffSide { case left, right }
    
    // MARK: - Results
    @ViewBuilder
    private var diffResultsView: some View {
        if isComputing {
            HStack(spacing: 8) {
                ProgressView().scaleEffect(0.6)
                Text("Computing diff...")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if let result = diffResult {
            if !result.stats.hasChanges && result.error == nil {
                VStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(TTFont.heading1)
                        .foregroundColor(.ttSuccess)
                    Text("No differences found")
                        .font(TTFont.labelMedium)
                        .foregroundColor(.ttSuccess)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if let error = result.error {
                VStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.ttIcon(TTIcon.xxxl))
                        .foregroundColor(.ttWarning)
                    Text(error)
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttWarning)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                diffNodesList(result.nodes)
            }
        } else {
            VStack(spacing: 12) {
                Image(systemName: "rectangle.on.rectangle")
                    .font(TTFont.heading1)
                    .foregroundColor(.ttTextTertiary)
                Text("Paste JSON on both sides and click Compare")
                    .font(TTFont.bodySmall)
                    .foregroundColor(.ttTextTertiary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    private func diffNodesList(_ nodes: [DiffNode]) -> some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                let changedNodes = nodes.filter { node in
                    switch node.type {
                    case .unchanged: return false
                    default: return true
                    }
                }
                
                ForEach(changedNodes) { node in
                    HStack(spacing: 0) {
                        // Indent
                        ForEach(0..<node.indent, id: \.self) { _ in
                            Rectangle()
                                .fill(Color.ttBorder.opacity(0.08))
                                .frame(width: 1)
                                .padding(.horizontal, 8)
                        }
                        
                        // Icon
                        Image(systemName: node.type.icon)
                            .font(.ttIcon(TTIcon.sm))
                            .foregroundColor(node.type.color)
                            .frame(width: 18)
                        
                        // Path
                        Text(node.path)
                            .font(TTFont.codeSmall)
                            .foregroundColor(.ttTextTertiary)
                            .frame(width: 200, alignment: .leading)
                            .lineLimit(1)
                        
                        // Values
                        switch node.type {
                        case .added:
                            Text(node.rightValue ?? "")
                                .font(TTFont.codeMedium)
                                .foregroundColor(.ttSuccess)
                                .lineLimit(2)
                                .textSelection(.enabled)
                        case .removed:
                            Text(node.leftValue ?? "")
                                .font(TTFont.codeMedium)
                                .foregroundColor(.ttError)
                                .strikethrough()
                                .lineLimit(2)
                                .textSelection(.enabled)
                        case .changed(let old, let new):
                            HStack(spacing: 8) {
                                Text(old)
                                    .font(TTFont.codeMedium)
                                    .foregroundColor(.ttError)
                                    .strikethrough()
                                    .lineLimit(1)
                                Image(systemName: "arrow.right")
                                    .font(.ttIcon(TTIcon.xxs))
                                    .foregroundColor(.ttWarning)
                                Text(new)
                                    .font(TTFont.codeMedium)
                                    .foregroundColor(.ttSuccess)
                                    .lineLimit(1)
                            }
                            .textSelection(.enabled)
                        case .unchanged:
                            EmptyView()
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(diffRowBackground(node.type))
                    .overlay(
                        Rectangle().fill(Color.ttBorder.opacity(0.08)).frame(height: 1),
                        alignment: .bottom
                    )
                }
            }
        }
    }
    
    private func diffRowBackground(_ type: DiffNodeType) -> Color {
        switch type {
        case .added: return Color.ttSuccess.opacity(0.04)
        case .removed: return Color.ttError.opacity(0.04)
        case .changed: return Color.ttWarning.opacity(0.04)
        case .unchanged: return Color.clear
        }
    }
    
    // MARK: - Actions
    
    private func executeDiff() {
        isComputing = true
        currentDiffIndex = 0
        
        let left = leftJSON
        let right = rightJSON
        Task.detached(priority: .userInitiated) {
            let result = JSONDiffEngine.diff(left: left, right: right)
            await MainActor.run {
                diffResult = result
                isComputing = false
            }
        }
    }
    
    private func navigateDiff(_ direction: Int) {
        guard let result = diffResult else { return }
        let total = result.stats.total
        guard total > 0 else { return }
        currentDiffIndex = (currentDiffIndex + direction + total) % total
    }
}
