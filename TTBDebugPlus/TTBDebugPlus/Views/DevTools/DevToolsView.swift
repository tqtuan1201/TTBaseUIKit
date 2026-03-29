//
//  DevToolsView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Container for Dev Tools (JSON Editor, and future tools)
//

import SwiftUI

struct DevToolsView: View {
    @Environment(AppState.self) var appState
    @State private var selectedTool: DevTool = .jsonEditor
    @State private var viewModel = JSONEditorViewModel()
    @State private var selectedEditorTab: JSONEditorTab = .editor
    
    var body: some View {
        VStack(spacing: 0) {
            // Tool selector + Editor tab picker
            toolHeader
            
            // Content
            switch selectedTool {
            case .jsonEditor:
                jsonEditorContent
            default:
                comingSoonView(selectedTool)
            }
        }
        .background(Color.ttBackground)
        .onAppear {
            loadPayloadIfNeeded()
        }
        .onChange(of: appState.jsonEditorPayload) { _, _ in
            loadPayloadIfNeeded()
        }
    }
    
    // MARK: - Tool Header
    private var toolHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                // Tool picker
                HStack(spacing: 2) {
                    ForEach(DevTool.allCases) { tool in
                        Button(action: {
                            if tool.isAvailable {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedTool = tool
                                }
                            }
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: tool.icon)
                                    .font(.ttIcon(TTIcon.md))
                                Text(tool.rawValue)
                                    .font(TTFont.tabLabel)
                            }
                            .foregroundColor(
                                !tool.isAvailable ? .ttTextMuted :
                                (selectedTool == tool ? .ttPrimary : .ttTextSecondary)
                            )
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .overlay(
                                Rectangle()
                                    .fill(selectedTool == tool ? Color.ttPrimary : Color.clear)
                                    .frame(height: 2),
                                alignment: .bottom
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(!tool.isAvailable)
                        .help(tool.isAvailable ? tool.rawValue : "\(tool.rawValue) — Coming Soon")
                    }
                }
                
                Spacer()
                
                // Editor sub-tabs (only for JSON Editor)
                if selectedTool == .jsonEditor {
                    HStack(spacing: 2) {
                        ForEach(JSONEditorTab.allCases) { tab in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.12)) {
                                    selectedEditorTab = tab
                                }
                            }) {
                                HStack(spacing: 4) {
                                    Image(systemName: tab.icon)
                                        .font(.ttIcon(TTIcon.sm))
                                    Text(tab.rawValue)
                                        .font(TTFont.labelSmall)
                                }
                                .foregroundColor(selectedEditorTab == tab ? .white : .ttTextTertiary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    Capsule()
                                        .fill(selectedEditorTab == tab ? Color.ttPrimary.opacity(0.4) : Color.clear)
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.trailing, 12)
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.ttSurface.opacity(0.2))
            .overlay(
                Rectangle().fill(Color.ttBorder.opacity(0.2)).frame(height: 1),
                alignment: .bottom
            )
        }
    }
    
    // MARK: - JSON Editor Content
    @ViewBuilder
    private var jsonEditorContent: some View {
        switch selectedEditorTab {
        case .editor:
            JSONEditorView(viewModel: viewModel)
        case .query:
            JSONQueryView(jsonString: viewModel.rawJSON)
        case .diff:
            JSONDiffView(initialLeft: viewModel.rawJSON)
        case .convert:
            JSONConvertView(jsonString: viewModel.rawJSON)
        }
    }
    
    // MARK: - Coming Soon
    private func comingSoonView(_ tool: DevTool) -> some View {
        VStack(spacing: 16) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.ttSurface.opacity(0.5))
                    .frame(width: 80, height: 80)
                Image(systemName: tool.icon)
                    .font(TTFont.displayLarge)
                    .foregroundColor(.ttTextTertiary)
            }
            
            Text(tool.rawValue)
                .font(TTFont.heading2)
                .foregroundColor(.ttTextPrimary)
            
            Text("Coming Soon")
                .font(TTFont.bodyMedium)
                .foregroundColor(.ttTextTertiary)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.ttSurface)
                )
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Payload Loading
    private func loadPayloadIfNeeded() {
        if let payload = appState.jsonEditorPayload {
            viewModel.loadJSON(payload.json, source: payload.sourceLabel)
            selectedTool = .jsonEditor
            selectedEditorTab = .editor
            appState.jsonEditorPayload = nil
        }
    }
}

#Preview {
    DevToolsView()
        .environment(AppState())
        .frame(width: 1100, height: 700)
        .preferredColorScheme(.dark)
}
