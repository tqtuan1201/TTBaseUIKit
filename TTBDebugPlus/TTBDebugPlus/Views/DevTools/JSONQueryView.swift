//
//  JSONQueryView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  JSONPath query panel: input + live results with syntax highlighting
//

import SwiftUI

struct JSONQueryView: View {
    let jsonString: String
    @State private var queryPath: String = "$"
    @State private var result: QueryResult = QueryResult(matches: [], error: nil)
    @State private var isQuerying: Bool = false
    
    // Common path suggestions
    private let suggestions = [
        ("$", "Root object"),
        ("$.*", "All top-level values"),
        ("$.data", "Access 'data' key"),
        ("$.data[0]", "First item in 'data' array"),
        ("$.data[*].id", "All 'id' values in 'data' array"),
        ("$..name", "All 'name' values (recursive)"),
        ("$..id", "All 'id' values (recursive)"),
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            // Query input bar
            queryInputBar
            
            Divider().background(Color.ttBorder.opacity(0.2))
            
            // Results
            if jsonString.isEmpty {
                emptyJSONState
            } else if isQuerying {
                loadingState
            } else if let error = result.error {
                errorState(error)
            } else if result.isEmpty {
                noResultsState
            } else {
                resultsList
            }
        }
        .background(Color.ttBackground)
        .onChange(of: queryPath) { _, _ in
            executeQuery()
        }
        .onAppear {
            executeQuery()
        }
    }
    
    // MARK: - Query Input
    private var queryInputBar: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                // JSONPath icon
                Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                    .font(.ttIcon(TTIcon.lg))
                    .foregroundColor(.ttPrimary)
                
                // Input
                TextField("Enter JSONPath (e.g., $.data[0].name)", text: $queryPath)
                    .textFieldStyle(.plain)
                    .font(TTFont.codeMedium)
                    .foregroundColor(.ttTextPrimary)
                
                // Result count
                if !result.isEmpty {
                    Text("\(result.count) match\(result.count == 1 ? "" : "es")")
                        .font(TTFont.badge)
                        .foregroundColor(.ttSuccess)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(Color.ttSuccess.opacity(0.12)))
                }
                
                // Clear
                if queryPath != "$" {
                    Button(action: { queryPath = "$" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.ttIcon(TTIcon.lg))
                            .foregroundColor(.ttTextTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ttSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.ttPrimary.opacity(0.3), lineWidth: 1)
                    )
            )
            
            // Suggestions
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(suggestions, id: \.0) { path, desc in
                        Button(action: { queryPath = path }) {
                            Text(path)
                                .font(TTFont.codeSmall)
                                .foregroundColor(queryPath == path ? .white : .ttPrimaryLight)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(queryPath == path ? Color.ttPrimary.opacity(0.5) : Color.ttPrimary.opacity(0.08))
                                )
                        }
                        .buttonStyle(.plain)
                        .help(desc)
                    }
                }
            }
        }
        .padding(12)
    }
    
    // MARK: - Results
    private var resultsList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(result.matches) { match in
                    VStack(alignment: .leading, spacing: 4) {
                        // Path
                        HStack(spacing: 6) {
                            Image(systemName: "arrow.right")
                                .font(.ttIcon(TTIcon.xxs))
                                .foregroundColor(.ttPrimary)
                            Text(match.path)
                                .font(TTFont.codeSmall)
                                .foregroundColor(.ttPrimaryLight)
                                .textSelection(.enabled)
                            
                            Spacer()
                            
                            // Copy button
                            Button(action: {
                                NSPasteboard.general.clearContents()
                                NSPasteboard.general.setString(match.value, forType: .string)
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .font(.ttIcon(TTIcon.xs))
                                    .foregroundColor(.ttTextTertiary)
                            }
                            .buttonStyle(.plain)
                        }
                        
                        // Value
                        Text(match.value)
                            .font(TTFont.codeMedium)
                            .foregroundColor(.ttJsonString)
                            .textSelection(.enabled)
                            .lineLimit(10)
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(Color.ttSurface.opacity(0.3))
                            )
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .overlay(
                        Rectangle().fill(Color.ttBorder.opacity(0.1)).frame(height: 1),
                        alignment: .bottom
                    )
                }
            }
        }
    }
    
    // MARK: - States
    
    private var emptyJSONState: some View {
        VStack(spacing: 12) {
            Image(systemName: "doc.text")
                .font(TTFont.heading1)
                .foregroundColor(.ttTextTertiary)
            Text("No JSON data")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            Text("Enter or paste JSON in the Editor tab first")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var loadingState: some View {
        HStack(spacing: 8) {
            ProgressView().scaleEffect(0.6)
            Text("Querying...")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func errorState(_ error: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle")
                .font(.ttIcon(TTIcon.xxxl))
                .foregroundColor(.ttWarning)
            Text(error)
                .font(TTFont.codeSmall)
                .foregroundColor(.ttWarning)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var noResultsState: some View {
        VStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.ttIcon(TTIcon.xxxl))
                .foregroundColor(.ttTextTertiary)
            Text("No matches found")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            Text("Try a different JSONPath expression")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Execute
    private func executeQuery() {
        guard !jsonString.isEmpty, !queryPath.isEmpty else { return }
        isQuerying = true
        
        let input = jsonString
        let path = queryPath
        Task.detached(priority: .userInitiated) {
            let queryResult = JSONQueryEngine.query(input, path: path)
            await MainActor.run {
                result = queryResult
                isQuerying = false
            }
        }
    }
}
