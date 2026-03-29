//
//  RecordingExportView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-28.
//  Post-recording export sheet — GIF, image sequence, frame scrubber
//
//  Fixes:
//   - Crash on Discard: Slider crash when frameCount=0 (max stride must be positive)
//   - Safe bounds-checking on frame access
//   - Layout: larger view, better proportions
//   - UI/UX: cleaner header, bigger preview, progress feedback
//

import SwiftUI

struct RecordingExportView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var captureVM: ScreenCaptureViewModel
    
    @State private var currentFrameIndex: Int = 0
    @State private var gifSpeed: Double = 1.0
    @State private var isExporting: Bool = false
    @State private var exportProgress: String = ""
    @State private var showDiscardConfirm: Bool = false
    
    private var frameCount: Int { captureVM.recordingSession.frameCount }
    private var hasFrames: Bool { frameCount > 0 }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            Divider().background(Color.ttBorder)
            
            if hasFrames {
                framePreview
                Divider().background(Color.ttBorder)
                timelineScrubber
                Divider().background(Color.ttBorder)
            } else {
                emptyState
            }
            
            exportOptions
        }
        .frame(
            minWidth: 700, idealWidth: 900,
            minHeight: 600, idealHeight: 750
        )
        .background(Color.ttBackground)
        .confirmationDialog("Discard Recording", isPresented: $showDiscardConfirm, titleVisibility: .visible) {
            Button("Discard", role: .destructive) {
                captureVM.discardRecording()
                dismiss()
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("This will permanently delete \(frameCount) captured frames. This action cannot be undone.")
        }
    }
    
    // MARK: - Header
    private var header: some View {
        HStack(spacing: 12) {
            // Icon + title
            HStack(spacing: 8) {
                Image(systemName: "film.stack")
                    .font(.ttIcon(TTIcon.xxl))
                    .foregroundColor(.ttPrimary)
                
                VStack(alignment: .leading, spacing: 1) {
                    Text("Recording Session")
                        .font(TTFont.heading3)
                        .foregroundColor(.ttTextPrimary)
                    
                    if hasFrames {
                        Text("\(frameCount) frames captured")
                            .font(TTFont.labelSmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                }
            }
            
            Spacer()
            
            // Stats chips
            if hasFrames {
                HStack(spacing: 8) {
                    statChip(icon: "photo.stack", text: "\(frameCount) frames")
                    statChip(icon: "clock", text: formattedDuration)
                    statChip(icon: "timer", text: String(format: "%.1fs", captureVM.recordingSession.interval))
                }
            }
            
            // Close button
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(TTFont.labelMedium)
                    .foregroundColor(.ttTextTertiary)
                    .frame(width: 28, height: 28)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.ttSurface)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.ttBorder.opacity(0.5), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
            .help("Close")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .background(Color.ttSurface.opacity(0.5))
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "film.stack")
                .font(TTFont.displayLarge)
                .foregroundColor(.ttTextTertiary.opacity(0.4))
            Text("No Frames Captured")
                .font(TTFont.heading3)
                .foregroundColor(.ttTextTertiary)
            Text("Start a recording session to capture frames")
                .font(TTFont.bodySmall)
                .foregroundColor(.ttTextMuted)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Frame Preview
    private var framePreview: some View {
        ZStack {
            Color(nsColor: NSColor(calibratedWhite: 0.06, alpha: 1.0))
            
            if let frame = safeCurrentFrame {
                Image(nsImage: frame.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .shadow(color: .black.opacity(0.3), radius: 10, y: 4)
                    .padding(20)
            }
            
            // Frame counter badge
            if hasFrames {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "photo")
                                .font(.ttIcon(TTIcon.sm))
                            Text("Frame \(safeFrameIndex + 1) / \(frameCount)")
                                .font(TTFont.codeMedium)
                        }
                        .foregroundColor(.ttTextPrimary)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
                        )
                        .padding(16)
                    }
                }
            }
        }
        .frame(minHeight: 350)
    }
    
    // MARK: - Timeline Scrubber
    private var timelineScrubber: some View {
        VStack(spacing: 10) {
            // Scrubber slider — only render when we have ≥2 frames
            if frameCount >= 2 {
                HStack(spacing: 10) {
                    // Back button
                    Button(action: { currentFrameIndex = max(0, currentFrameIndex - 1) }) {
                        Image(systemName: "chevron.left")
                            .font(TTFont.labelMedium)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.ttGhost)
                    .disabled(currentFrameIndex <= 0)
                    
                    Slider(
                        value: Binding(
                            get: { Double(safeFrameIndex) },
                            set: { currentFrameIndex = min(Int($0), frameCount - 1) }
                        ),
                        in: 0...Double(frameCount - 1),
                        step: 1
                    )
                    
                    // Forward button
                    Button(action: { currentFrameIndex = min(frameCount - 1, currentFrameIndex + 1) }) {
                        Image(systemName: "chevron.right")
                            .font(TTFont.labelMedium)
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.ttGhost)
                    .disabled(currentFrameIndex >= frameCount - 1)
                }
            } else if frameCount == 1 {
                Text("1 frame captured")
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
            }
            
            // Thumbnail strip
            if hasFrames {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(Array(captureVM.recordingSession.frames.enumerated()), id: \.element.id) { index, frame in
                                let isSelected = safeFrameIndex == index
                                Button(action: { currentFrameIndex = index }) {
                                    Image(nsImage: frame.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 44, height: 64)
                                        .clipShape(RoundedRectangle(cornerRadius: 4))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 4)
                                                .stroke(isSelected ? Color.ttPrimary : Color.ttBorder.opacity(0.3), lineWidth: isSelected ? 2.5 : 1)
                                        )
                                        .shadow(color: isSelected ? Color.ttPrimary.opacity(0.3) : .clear, radius: 4)
                                }
                                .buttonStyle(.plain)
                                .id(index)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
                    .frame(height: 68)
                    .onChange(of: currentFrameIndex) { _, newIndex in
                        withAnimation(.easeOut(duration: 0.2)) {
                            proxy.scrollTo(min(newIndex, frameCount - 1), anchor: .center)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.ttSurface.opacity(0.3))
    }
    
    // MARK: - Export Options
    private var exportOptions: some View {
        VStack(spacing: 14) {
            // Speed control
            HStack(spacing: 10) {
                Text("GIF Speed")
                    .font(TTFont.labelMedium)
                    .foregroundColor(.ttTextSecondary)
                
                HStack(spacing: 6) {
                    ForEach([0.5, 1.0, 2.0, 3.0], id: \.self) { speed in
                        Button(action: { gifSpeed = speed }) {
                            Text("\(speed, specifier: "%.1f")×")
                                .font(TTFont.labelSmall)
                                .foregroundColor(gifSpeed == speed ? .white : .ttTextSecondary)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(gifSpeed == speed ? Color.ttPrimary : Color.ttSurface)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 6)
                                                .stroke(gifSpeed == speed ? Color.ttPrimary : Color.ttBorder.opacity(0.4), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                Spacer()
                
                // Estimated GIF info
                if hasFrames {
                    let estDelay = captureVM.recordingSession.interval / gifSpeed
                    let estDuration = estDelay * Double(frameCount)
                    Text(String(format: "~%.1fs GIF", estDuration))
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttTextMuted)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Capsule().fill(Color.ttSurface.opacity(0.6)))
                }
            }
            
            // Export progress
            if !exportProgress.isEmpty {
                HStack(spacing: 8) {
                    ProgressView()
                        .controlSize(.small)
                        .scaleEffect(0.8)
                    Text(exportProgress)
                        .font(TTFont.labelSmall)
                        .foregroundColor(.ttPrimary)
                    Spacer()
                }
                .padding(.vertical, 4)
            }
            
            // Action buttons
            HStack(spacing: 12) {
                // Discard
                Button(action: { showDiscardConfirm = true }) {
                    HStack(spacing: 6) {
                        Image(systemName: "trash")
                            .font(.ttIcon(TTIcon.lg))
                        Text("Discard")
                            .font(TTFont.labelMedium)
                    }
                }
                .buttonStyle(.ttSecondaryCompact)
                .disabled(!hasFrames)
                
                Spacer()
                
                // Image Sequence
                Button(action: exportImageSequence) {
                    HStack(spacing: 6) {
                        Image(systemName: "photo.stack")
                            .font(.ttIcon(TTIcon.lg))
                        Text("Image Sequence")
                            .font(TTFont.labelMedium)
                    }
                }
                .buttonStyle(.ttSecondaryCompact)
                .disabled(isExporting || !hasFrames)
                
                // Export GIF
                Button(action: exportGIF) {
                    HStack(spacing: 6) {
                        Image(systemName: "film")
                            .font(.ttIcon(TTIcon.lg))
                        Text("Export GIF")
                            .font(TTFont.labelMedium)
                    }
                }
                .buttonStyle(.ttPrimaryCompact)
                .disabled(isExporting || frameCount < 2)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.ttSurface.opacity(0.5))
    }
    
    // MARK: - Safe Accessors (prevent out-of-bounds crashes)
    
    private var safeFrameIndex: Int {
        guard hasFrames else { return 0 }
        return min(max(currentFrameIndex, 0), frameCount - 1)
    }
    
    private var safeCurrentFrame: RecordingFrame? {
        guard hasFrames else { return nil }
        let idx = safeFrameIndex
        guard idx < captureVM.recordingSession.frames.count else { return nil }
        return captureVM.recordingSession.frames[idx]
    }
    
    private var formattedDuration: String {
        let elapsed = captureVM.recordingElapsed
        let mins = Int(elapsed) / 60
        let secs = Int(elapsed) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    private func statChip(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon).font(.ttIcon(TTIcon.sm))
            Text(text).font(TTFont.codeSmall)
        }
        .foregroundColor(.ttTextTertiary)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            Capsule()
                .fill(Color.ttSurface.opacity(0.8))
                .overlay(Capsule().stroke(Color.ttBorder.opacity(0.3), lineWidth: 1))
        )
    }
    
    // MARK: - Export Actions
    private func exportGIF() {
        guard hasFrames else { return }
        isExporting = true
        exportProgress = "Creating GIF (\(frameCount) frames)..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let url = captureVM.exportGIF(speed: gifSpeed)
            DispatchQueue.main.async {
                isExporting = false
                exportProgress = ""
                if let url {
                    NSWorkspace.shared.activateFileViewerSelecting([url])
                }
            }
        }
    }
    
    private func exportImageSequence() {
        guard hasFrames else { return }
        isExporting = true
        exportProgress = "Exporting \(frameCount) frames..."
        
        DispatchQueue.global(qos: .userInitiated).async {
            let url = captureVM.exportImageSequence()
            DispatchQueue.main.async {
                isExporting = false
                exportProgress = ""
                if let url {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
}

#Preview {
    RecordingExportView(captureVM: ScreenCaptureViewModel())
        .frame(width: 900, height: 750)
        .preferredColorScheme(.dark)
}
