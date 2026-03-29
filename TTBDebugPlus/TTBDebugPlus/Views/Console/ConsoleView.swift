//
//  ConsoleView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Console log viewer matching design4.png with live data, filtering, JSON payloads
//

import SwiftUI

struct ConsoleView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    @State private var viewModel = ConsoleViewModel()
    @State private var showDetail: Bool = true
    
    var body: some View {
        HSplitView {
            // MARK: - Log Table (Left)
            VStack(spacing: 0) {
                consoleFilterBar
                columnHeaders
                logTable
            }
            .frame(minWidth: 500)
            .background(Color.ttBackground)
            
            // MARK: - Entry Detail (Right)
            if showDetail, let entry = viewModel.selectedEntry {
                EntryDetailPanel(
                    entry: entry,
                    onClose: { showDetail = false },
                    onOpenInEditor: { json, source in
                        appState.openInJSONEditor(json: json, source: source)
                    }
                )
                    .frame(minWidth: 350, idealWidth: 420)
            }
        }
        .onAppear {
            viewModel.syncFromConnectionManager(connectionManager)
        }
        .onChange(of: connectionManager.totalConsoleLogs) {
            viewModel.syncFromConnectionManager(connectionManager)
        }
        .onReceive(NotificationCenter.default.publisher(for: .clearConsole)) { _ in
            viewModel.clearAll()
            connectionManager.clearAllLogs()
        }
        // Keyboard navigation
        .onKeyPress(.upArrow) { selectPrevious(); return .handled }
        .onKeyPress(.downArrow) { selectNext(); return .handled }
        .onKeyPress(.escape) { showDetail = false; return .handled }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Console Log Viewer")
    }
    
    // MARK: - Keyboard Selection
    private func selectNext() {
        let entries = viewModel.filteredEntries
        guard !entries.isEmpty else { return }
        if let current = viewModel.selectedEntry,
           let idx = entries.firstIndex(where: { $0.id == current.id }) {
            let nextIdx = min(idx + 1, entries.count - 1)
            viewModel.selectedEntry = entries[nextIdx]
        } else {
            viewModel.selectedEntry = entries.first
        }
        showDetail = true
    }
    
    private func selectPrevious() {
        let entries = viewModel.filteredEntries
        guard !entries.isEmpty else { return }
        if let current = viewModel.selectedEntry,
           let idx = entries.firstIndex(where: { $0.id == current.id }) {
            let prevIdx = max(idx - 1, 0)
            viewModel.selectedEntry = entries[prevIdx]
        } else {
            viewModel.selectedEntry = entries.first
        }
        showDetail = true
    }

    
    // MARK: - Filter Bar
    private var consoleFilterBar: some View {
        HStack(spacing: 12) {
            // Filter pills
            HStack(spacing: 2) {
                ForEach([LogFilter.all, .errors, .warnings, .debug], id: \.self) { filter in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            viewModel.selectedFilter = filter
                        }
                    }) {
                        HStack(spacing: 4) {
                            Text(filter.rawValue)
                            if filter == .all && viewModel.totalCount > 0 {
                                Text("\(viewModel.totalCount)")
                                    .font(TTFont.badge)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1)
                                    .background(Capsule().fill(Color.ttPrimary.opacity(0.3)))
                            }
                            if filter == .errors && viewModel.errorCount > 0 {
                                Text("\(viewModel.errorCount)")
                                    .font(TTFont.badge)
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 1)
                                    .background(Capsule().fill(Color.ttError.opacity(0.3)))
                            }
                        }
                        .font(TTFont.labelMedium)
                        .foregroundColor(viewModel.selectedFilter == filter ? .white : .ttTextSecondary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(viewModel.selectedFilter == filter ? Color.ttPrimary : Color.clear)
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Search field
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.ttIcon(TTIcon.lg))
                    .foregroundColor(.ttTextTertiary)
                
                TextField("Filter logs...", text: $viewModel.searchText)
                    .textFieldStyle(.plain)
                    .font(TTFont.bodyMedium)
                    .foregroundColor(.ttTextPrimary)
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.ttIcon(TTIcon.lg))
                            .foregroundColor(.ttTextTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.ttSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.ttBorder, lineWidth: 1)
                    )
            )
            .frame(maxWidth: 300)
            
            Spacer()
            
            // Result count
            Text("\(viewModel.filteredEntries.count) entries")
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
            
            // Live streaming indicator
            Button(action: { viewModel.isLiveStreaming.toggle() }) {
                StatusBadge(
                    text: viewModel.isLiveStreaming ? "LIVE" : "PAUSED",
                    color: viewModel.isLiveStreaming ? .ttSuccess : .ttWarning,
                    style: .dot
                )
            }
            .buttonStyle(.plain)
            
            // Clear
            Button(action: {
                viewModel.clearAll()
            }) {
                HStack(spacing: 4) {
                    Image(systemName: "trash")
                        .font(.ttIcon(TTIcon.md))
                    Text("Clear")
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(.ttTextSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.ttBackground)
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.3)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Column Headers
    private var columnHeaders: some View {
        HStack(spacing: 0) {
            Text("TYPE")
                .frame(width: 40, alignment: .leading)
            Text("TIMESTAMP")
                .frame(width: 110, alignment: .leading)
            Text("SUBSYSTEM")
                .frame(width: 160, alignment: .leading)
            Text("MESSAGE")
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(TTFont.sidebarHeader)
        .foregroundColor(.ttTextTertiary)
        .tracking(0.8)
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.ttSurface.opacity(0.3))
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.3)).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Log Table
    private var logTable: some View {
        Group {
            if viewModel.filteredEntries.isEmpty {
                EmptyStateView(
                    icon: "terminal",
                    title: "No Console Logs",
                    subtitle: viewModel.entries.isEmpty
                        ? "Console logs from the connected device will appear here.\nMake sure your app uses TTDebugBridge.shared.sendConsoleLog()."
                        : "No logs match the current filter."
                )
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.filteredEntries) { entry in
                                ConsoleEntryRowView(
                                    entry: entry,
                                    isSelected: viewModel.selectedEntry?.id == entry.id,
                                    searchText: viewModel.searchText
                                )
                                .id(entry.id)
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.15)) {
                                        viewModel.selectedEntry = entry
                                        showDetail = true
                                    }
                                }
                                .contextMenu {
                                    Button(action: {
                                        NSPasteboard.general.clearContents()
                                        NSPasteboard.general.setString(entry.message, forType: .string)
                                    }) {
                                        Label("Copy Message", systemImage: "doc.on.doc")
                                    }
                                    
                                    Button(action: {
                                        let full = "[\(entry.formattedTime)] [\(entry.level.uppercased())] [\(entry.subsystem)] \(entry.message)"
                                        NSPasteboard.general.clearContents()
                                        NSPasteboard.general.setString(full, forType: .string)
                                    }) {
                                        Label("Copy Full Entry", systemImage: "doc.on.clipboard")
                                    }
                                    
                                    if let payload = entry.payload, !payload.isEmpty {
                                        Button(action: {
                                            NSPasteboard.general.clearContents()
                                            NSPasteboard.general.setString(payload, forType: .string)
                                        }) {
                                            Label("Copy JSON Payload", systemImage: "curlybraces")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: viewModel.entries.count) {
                        if viewModel.isLiveStreaming, let last = viewModel.filteredEntries.last {
                            withAnimation {
                                proxy.scrollTo(last.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Console Entry Row
struct ConsoleEntryRowView: View {
    let entry: ConsoleLogEntry
    var isSelected: Bool = false
    var searchText: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // Type icon
            LogLevelBadge(level: entry.level)
                .frame(width: 40, alignment: .leading)
            
            // Timestamp
            Text(entry.formattedTime)
                .font(TTFont.timestamp)
                .foregroundColor(.ttTextSecondary)
                .frame(width: 110, alignment: .leading)
            
            // Subsystem
            Text(entry.subsystem)
                .font(TTFont.codeMedium)
                .foregroundColor(.ttPrimaryLight)
                .fontWeight(.semibold)
                .frame(width: 160, alignment: .leading)
                .lineLimit(1)
            
            // Message (highlight search matches)
            messageText
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(rowBackground)
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.15)).frame(height: 1),
            alignment: .bottom
        )
        .contentShape(Rectangle())
    }
    
    private var rowBackground: Color {
        if isSelected { return Color.ttPrimary.opacity(0.12) }
        switch entry.level {
        case "error": return Color.ttError.opacity(0.04)
        case "warning": return Color.ttWarning.opacity(0.03)
        default: return Color.clear
        }
    }
    
    @ViewBuilder
    private var messageText: some View {
        if !searchText.isEmpty, entry.message.localizedCaseInsensitiveContains(searchText) {
            highlightedMessage
        } else {
            Text(entry.message)
                .font(TTFont.bodySmall)
                .foregroundColor(.ttTextPrimary)
        }
    }
    
    private var highlightedMessage: some View {
        let msg = entry.message
        let search = searchText.lowercased()
        var result = Text("")
        var currentIndex = msg.startIndex
        
        while let range = msg[currentIndex...].range(of: search, options: .caseInsensitive) {
            // Text before match
            if currentIndex < range.lowerBound {
                result = result + Text(msg[currentIndex..<range.lowerBound])
                    .font(TTFont.bodySmall)
                    .foregroundColor(.ttTextPrimary)
            }
            // Matched text
            result = result + Text(msg[range])
                .font(TTFont.bodySmall)
                .foregroundColor(.ttWarning)
                .bold()
                .underline()
            
            currentIndex = range.upperBound
        }
        
        // Remaining text
        if currentIndex < msg.endIndex {
            result = result + Text(msg[currentIndex...])
                .font(TTFont.bodySmall)
                .foregroundColor(.ttTextPrimary)
        }
        
        return result
    }
}

// MARK: - Entry Detail Panel
struct EntryDetailPanel: View {
    let entry: ConsoleLogEntry
    var onClose: () -> Void = {}
    var onOpenInEditor: ((String, String) -> Void)? = nil
    @State private var isCopied: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    Text("Entry Details")
                        .font(TTFont.heading3)
                        .foregroundColor(.ttTextPrimary)
                    
                    Spacer()
                    
                    Button(action: copyEntry) {
                        Image(systemName: isCopied ? "checkmark" : "doc.on.doc")
                            .font(.ttIcon(TTIcon.lg))
                            .foregroundColor(isCopied ? .ttSuccess : .ttTextSecondary)
                    }
                    .buttonStyle(.ttGhost)
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.ttIcon(TTIcon.lg))
                    }
                    .buttonStyle(.ttGhost)
                }
                
                // Metadata
                CardView(title: "METADATA") {
                    VStack(spacing: 10) {
                        metadataRow(label: "SUBSYSTEM", value: entry.subsystem)
                        metadataRow(label: "THREAD ID", value: entry.threadId)
                        metadataRow(label: "TIMESTAMP", value: entry.formattedTime)
                        HStack {
                            Text("LEVEL")
                                .font(TTFont.labelSmall)
                                .foregroundColor(.ttTextTertiary)
                                .frame(width: 100, alignment: .leading)
                            Spacer()
                            StatusBadge(text: entry.level.uppercased(), color: Color.forLogLevel(entry.level))
                        }
                    }
                }
                
                // Payload JSON
                if let payload = entry.payload, !payload.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("PAYLOAD CONTENT")
                                .font(TTFont.sidebarHeader)
                                .foregroundColor(.ttTextSecondary)
                                .tracking(0.8)
                            Spacer()
                            Text("(application/json)")
                                .font(TTFont.labelSmall)
                                .foregroundColor(.ttTextTertiary)
                        }
                        
                        JSONViewer(jsonString: payload, showLineNumbers: true, showToolbar: true, onOpenInEditor: { json in
                            onOpenInEditor?(json, "Console Log Payload — \(entry.level.uppercased())")
                        })
                            .frame(minHeight: 150)
                    }
                }
                
                // Origin Source
                if let sourceFile = entry.sourceFile {
                    CardView(title: "ORIGIN SOURCE") {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.right")
                                    .font(.ttIcon(TTIcon.xxs))
                                    .foregroundColor(.ttPrimary)
                                Text("\(sourceFile):\(entry.sourceLine ?? 0)")
                                    .font(TTFont.codeMedium)
                                    .foregroundColor(.ttPrimary)
                            }
                        }
                    }
                }
                
                // Full message
                CardView(title: "FULL MESSAGE") {
                    Text(entry.message)
                        .font(TTFont.codeMedium)
                        .foregroundColor(.ttTextPrimary)
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(16)
        }
        .background(Color.ttBackground)
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.3)).frame(width: 1),
            alignment: .leading
        )
    }
    
    private func metadataRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
                .frame(width: 100, alignment: .leading)
            Spacer()
            Text(value)
                .font(TTFont.codeMedium)
                .foregroundColor(.ttTextPrimary)
                .textSelection(.enabled)
        }
    }
    
    private func copyEntry() {
        let text = """
        [\(entry.level.uppercased())] \(entry.formattedTime) [\(entry.subsystem)]
        \(entry.message)
        \(entry.payload ?? "")
        """
        #if os(macOS)
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
        #endif
        isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { isCopied = false }
    }
}

#Preview {
    ConsoleView()
        .environment(AppState())
        .environment(ConnectionManager())
        .frame(width: 1100, height: 700)
        .preferredColorScheme(.dark)
}
