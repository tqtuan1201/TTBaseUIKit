//
//  FeedbackView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Bug report management with form, screenshot attachment, and export
//

import SwiftUI

struct FeedbackView: View {
    @Environment(AppState.self) var appState
    @Environment(ConnectionManager.self) var connectionManager
    @State private var viewModel = FeedbackViewModel()
    @State private var showForm: Bool = false
    
    var body: some View {
        HSplitView {
            // MARK: - Report List
            VStack(spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Feedback Reports")
                            .font(TTFont.heading2)
                            .foregroundColor(.ttTextPrimary)
                        Text("\(viewModel.reports.count) reports • \(viewModel.reports.filter { !$0.isResolved }.count) open")
                            .font(TTFont.labelSmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                    
                    Spacer()
                    
                    Button(action: { showForm.toggle() }) {
                        HStack(spacing: 4) {
                            Image(systemName: "plus")
                            Text("New Report")
                        }
                    }
                    .buttonStyle(.ttPrimaryCompact)
                }
                .padding(16)
                
                Divider().background(Color.ttBorder)
                
                // New report form (collapsible)
                if showForm {
                    feedbackForm
                    Divider().background(Color.ttBorder)
                }
                
                // Report list
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.reports) { report in
                            FeedbackReportRow(
                                report: report,
                                isSelected: viewModel.selectedReport?.id == report.id
                            )
                            .onTapGesture {
                                viewModel.selectedReport = report
                            }
                            .contextMenu {
                                Button("Mark \(report.isResolved ? "Open" : "Resolved")") {
                                    viewModel.toggleResolve(report)
                                }
                                Button("Export as Markdown") {
                                    viewModel.exportReport(report)
                                }
                                Divider()
                                Button("Delete", role: .destructive) {
                                    viewModel.deleteReport(report)
                                }
                            }
                        }
                    }
                }
            }
            .frame(minWidth: 350)
            .background(Color.ttBackground)
            
            // MARK: - Detail
            if let report = viewModel.selectedReport {
                feedbackDetail(report)
            } else {
                EmptyStateView(
                    icon: "bubble.left.and.text.bubble.right",
                    title: "Select a Report",
                    subtitle: "Choose a feedback report from the list to view details, or create a new one."
                )
            }
        }
    }
    
    // MARK: - Feedback Form
    private var feedbackForm: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Title
            VStack(alignment: .leading, spacing: 4) {
                Text("ISSUE TITLE")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.5)
                
                TextField("Brief summary of the issue", text: $viewModel.formTitle)
                    .textFieldStyle(.plain)
                    .font(TTFont.bodyMedium)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ttSurface)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.ttBorder, lineWidth: 1))
                    )
            }
            
            // Description
            VStack(alignment: .leading, spacing: 4) {
                Text("DESCRIPTION")
                    .font(TTFont.sidebarHeader)
                    .foregroundColor(.ttTextTertiary)
                    .tracking(0.5)
                
                TextEditor(text: $viewModel.formDescription)
                    .font(TTFont.bodyMedium)
                    .scrollContentBackground(.hidden)
                    .padding(8)
                    .frame(minHeight: 80, maxHeight: 200)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.ttSurface)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.ttBorder, lineWidth: 1))
                    )
            }
            
            // Tag selector
            HStack(spacing: 8) {
                Text("TAG:")
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
                
                ForEach(FeedbackTag.allCases, id: \.self) { tag in
                    Button(action: { viewModel.formTag = tag }) {
                        HStack(spacing: 4) {
                            Image(systemName: tag.icon)
                                .font(.ttIcon(TTIcon.sm))
                            Text(tag.rawValue)
                                .font(TTFont.labelSmall)
                        }
                        .foregroundColor(viewModel.formTag == tag ? .white : .ttTextSecondary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(viewModel.formTag == tag ? tag.color : Color.clear)
                                .overlay(
                                    Capsule().stroke(viewModel.formTag == tag ? Color.clear : Color.ttBorder, lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            // Screenshot attachment
            if !viewModel.formScreenshots.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(viewModel.formScreenshots.enumerated()), id: \.offset) { index, image in
                            ZStack(alignment: .topTrailing) {
                                Image(nsImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 110)
                                    .clipShape(RoundedRectangle(cornerRadius: 6))
                                
                                Button(action: { viewModel.removeScreenshot(at: index) }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.ttIcon(TTIcon.xl))
                                        .foregroundColor(.ttTextPrimary)
                                        .shadow(radius: 2)
                                }
                                .buttonStyle(.plain)
                                .offset(x: 4, y: -4)
                            }
                        }
                    }
                }
            }
            
            // Submit
            HStack {
                Button(action: {
                    showForm = false
                    viewModel.clearForm()
                }) {
                    Text("Cancel")
                }
                .buttonStyle(.ttSecondaryCompact)
                
                Spacer()
                
                Button(action: {
                    let deviceName = connectionManager.selectedDevice?.displayName ?? "Unknown"
                    viewModel.submitReport(deviceName: deviceName)
                    showForm = false
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "paperplane.fill")
                        Text("Submit Report")
                    }
                }
                .buttonStyle(.ttPrimaryCompact)
                .disabled(viewModel.formTitle.isEmpty)
            }
        }
        .padding(16)
        .background(Color.ttSurface.opacity(0.3))
    }
    
    // MARK: - Feedback Detail
    private func feedbackDetail(_ report: FeedbackReport) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Title + Meta
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(report.title)
                            .font(TTFont.heading2)
                            .foregroundColor(.ttTextPrimary)
                        
                        HStack(spacing: 8) {
                            StatusBadge(text: report.tag.rawValue, color: report.tag.color)
                            Text(report.relativeTime)
                                .font(TTFont.labelSmall)
                                .foregroundColor(.ttTextTertiary)
                            Text("•")
                                .foregroundColor(.ttTextTertiary)
                            HStack(spacing: 4) {
                                Image(systemName: "iphone")
                                    .font(.ttIcon(TTIcon.sm))
                                Text(report.deviceName)
                                    .font(TTFont.labelSmall)
                            }
                            .foregroundColor(.ttTextTertiary)
                        }
                    }
                    Spacer()
                    StatusBadge(
                        text: report.isResolved ? "RESOLVED" : "OPEN",
                        color: report.isResolved ? .ttSuccess : .ttWarning
                    )
                }
                
                SectionDivider()
                
                // Description
                CardView(title: "DESCRIPTION") {
                    Text(report.description)
                        .font(TTFont.bodyMedium)
                        .foregroundColor(.ttTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .textSelection(.enabled)
                }
                
                // Screenshots
                if !report.screenshots.isEmpty {
                    CardView(title: "SCREENSHOTS (\(report.screenshots.count))") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(Array(report.screenshots.enumerated()), id: \.offset) { _, image in
                                    Image(nsImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxHeight: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(Color.ttBorder, lineWidth: 1)
                                        )
                                }
                            }
                        }
                    }
                }
                
                // Actions
                HStack(spacing: 12) {
                    Button(action: {
                        viewModel.exportReport(report)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.doc")
                            Text("Export Markdown")
                        }
                    }
                    .buttonStyle(.ttSecondary)
                    
                    Button(action: {
                        viewModel.shareReport(report)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "doc.on.doc")
                            Text("Copy Report")
                        }
                    }
                    .buttonStyle(.ttSecondary)
                    
                    Spacer()
                    
                    Button(action: {
                        viewModel.toggleResolve(report)
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: report.isResolved ? "arrow.uturn.backward" : "checkmark.circle")
                            Text(report.isResolved ? "Reopen" : "Mark Resolved")
                        }
                    }
                    .buttonStyle(.ttPrimary)
                }
            }
            .padding(20)
        }
        .background(Color.ttBackground)
    }
}

// MARK: - Feedback Report Row
struct FeedbackReportRow: View {
    let report: FeedbackReport
    var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                // Status dot
                Circle()
                    .fill(report.isResolved ? Color.ttSuccess : Color.ttWarning)
                    .frame(width: 6, height: 6)
                
                Text(report.title)
                    .font(TTFont.labelLarge)
                    .foregroundColor(.ttTextPrimary)
                    .lineLimit(1)
                
                Spacer()
                
                Text(report.relativeTime)
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
            }
            
            HStack(spacing: 8) {
                StatusBadge(text: report.tag.rawValue, color: report.tag.color, style: .filled)
                
                HStack(spacing: 3) {
                    Image(systemName: "iphone")
                        .font(.ttIcon(TTIcon.xs))
                    Text(report.deviceName)
                        .font(TTFont.labelSmall)
                }
                .foregroundColor(.ttTextTertiary)
                
                if !report.screenshots.isEmpty {
                    HStack(spacing: 3) {
                        Image(systemName: "paperclip")
                            .font(.ttIcon(TTIcon.xs))
                        Text("\(report.screenshots.count)")
                            .font(TTFont.labelSmall)
                    }
                    .foregroundColor(.ttTextTertiary)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? Color.ttPrimary.opacity(0.12) : Color.clear)
        .overlay(
            Rectangle().fill(Color.ttBorder.opacity(0.15)).frame(height: 1),
            alignment: .bottom
        )
        .contentShape(Rectangle())
    }
}

#Preview {
    FeedbackView()
        .environment(AppState())
        .environment(ConnectionManager())
        .frame(width: 1000, height: 700)
        .preferredColorScheme(.dark)
}
