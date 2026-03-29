//
//  DeviceView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Redesigned: compact preview, inline toolbar, gallery + annotation/report sheets
//

import SwiftUI

struct DeviceView: View {
    @Environment(ConnectionManager.self) var connectionManager
    @State private var captureVM = ScreenCaptureViewModel()
    
    @State private var darkModeOverride = true
    @State private var showGallery = true
    @State private var showDeleteConfirm = false
    @State private var deleteTarget: DeleteTarget = .single(nil)
    @State private var recordingInterval: TimeInterval = 0.5
    @State private var showIntervalPicker = false
    @State private var deviceInfoExpanded = false
    
    // MARK: Quick Draw State
    @State private var quickDrawTool: AnnotationTool = .pen
    @State private var quickDrawEnabled: Bool = true
    @State private var quickDrawColor: Color = .red
    @State private var quickDrawWidth: CGFloat = 3.0
    @State private var quickDragPoints: [CGPoint] = []
    @State private var quickAnnotations: [AnnotationItem] = []
    @State private var quickRedoStack: [AnnotationItem] = []
    @State private var previewDisplaySize: CGSize = .zero
    // Quick text input
    @State private var quickTextInput: String = ""
    @State private var quickTextPosition: CGPoint = .zero
    @State private var showQuickTextInput: Bool = false
    
    enum DeleteTarget {
        case single(UUID?)
        case selected
        case all
    }
    
    var body: some View {
        Group {
            if let device = connectionManager.selectedDevice, device.isOnline {
                connectedContent(device: device)
            } else {
                EmptyStateView(
                    icon: "iphone.slash",
                    title: "No Device Connected",
                    subtitle: "Connect an iOS device running TTBaseUIKit to start debugging.\nMake sure both devices are on the same network.",
                    actionTitle: "Scan for Devices"
                ) {
                    connectionManager.startServer()
                }
            }
        }
        .background(Color.ttBackground)
        .onChange(of: connectionManager.selectedDevice?.latestScreenshot?.timestamp) { _, newVal in
            if let _ = newVal, let screenshot = connectionManager.selectedDevice?.latestScreenshot {
                captureVM.handleScreenshotReceived(screenshot)
            }
        }
        // Clear quick annotations when switching screenshots
        .onChange(of: captureVM.selectedHistoryItem?.id) { _, _ in
            quickAnnotations.removeAll()
            quickRedoStack.removeAll()
            quickDragPoints.removeAll()
        }
        // Annotation editor — opens as large window-sized sheet
        .sheet(isPresented: $captureVM.isAnnotating) {
            if let image = captureVM.currentScreenshot {
                AnnotationEditorView(
                    baseImage: image,
                    annotations: $captureVM.annotations,
                    onDone: { captureVM.isAnnotating = false },
                    onCancel: { captureVM.isAnnotating = false }
                )
                .frame(
                    minWidth: 1000, idealWidth: 1400, maxWidth: .infinity,
                    minHeight: 750, idealHeight: 1000, maxHeight: .infinity
                )
                .interactiveDismissDisabled()
            }
        }
        // Bug report composer sheet
        .sheet(isPresented: $captureVM.showBugReportComposer) {
            BugReportComposerView(
                screenshots: captureVM.reportScreenshots,
                deviceInfo: currentDeviceInfoSnapshot
            )
        }
        // Recording export sheet
        .sheet(isPresented: $captureVM.showRecordingExport) {
            RecordingExportView(captureVM: captureVM)
        }
        // Delete confirmation
        .confirmationDialog("Delete Screenshots", isPresented: $showDeleteConfirm, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                switch deleteTarget {
                case .single(let id): if let id { captureVM.deleteItem(id) }
                case .selected: captureVM.deleteSelected()
                case .all: captureVM.clearAllHistory()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            switch deleteTarget {
            case .single: Text("This screenshot will be permanently removed.")
            case .selected: Text("Delete \(captureVM.selectedCount) selected screenshots?")
            case .all: Text("Delete all \(captureVM.screenshotHistory.count) screenshots?")
            }
        }
        // Keyboard navigation
        .onKeyPress(.leftArrow) { navigateGallery(direction: -1); return .handled }
        .onKeyPress(.rightArrow) { navigateGallery(direction: 1); return .handled }
        .onKeyPress(.space) {
            captureVM.requestCapture(from: connectionManager); return .handled
        }
        .onKeyPress(.delete) {
            if let item = captureVM.selectedHistoryItem {
                deleteTarget = .single(item.id)
                showDeleteConfirm = true
            }
            return .handled
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Device Manager")
    }
    
    // MARK: - Gallery Keyboard Navigation
    private func navigateGallery(direction: Int) {
        let history = captureVM.sortedHistory
        guard !history.isEmpty else { return }
        if let current = captureVM.selectedHistoryItem,
           let idx = history.firstIndex(where: { $0.id == current.id }) {
            let newIdx = max(0, min(idx + direction, history.count - 1))
            captureVM.selectItem(history[newIdx])
        } else if let first = history.first {
            captureVM.selectItem(first)
        }
    }
    
    // MARK: - Connected Content
    private func connectedContent(device: DeviceSession) -> some View {
        VStack(spacing: 0) {
            // Compact header with capture toolbar
            compactHeader(device: device)
            
            Divider().background(Color.ttBorder.opacity(0.3))
            
            // Main content
            HSplitView {
                // Left: Preview + device info
                leftPanel(device: device)
                    .frame(minWidth: 320, idealWidth: 380)
                
                // Right: Gallery
                if showGallery {
                    rightGalleryPanel
                        .frame(minWidth: 300, idealWidth: 460)
                }
            }
        }
    }
    
    // MARK: - Compact Header
    private func compactHeader(device: DeviceSession) -> some View {
        HStack(spacing: 8) {
            // Connection status
            ConnectionIndicator(isConnected: device.isOnline)
            Text(device.displayName)
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextPrimary)
            
            StatusBadge(text: device.shortId, color: .ttTextSecondary, style: .outlined)
            
            Spacer()
            
            // Recording indicator
            if captureVM.isRecording {
                HStack(spacing: 5) {
                    Circle().fill(Color.ttError).frame(width: 7, height: 7)
                        .modifier(PulsingAnimation())
                    Text("REC \(captureVM.formattedRecordingTime)")
                        .font(TTFont.badge)
                        .foregroundColor(.ttError)
                        .monospacedDigit()
                    Text("• \(captureVM.recordingSession.frameCount)f")
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttError.opacity(0.7))
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(Color.ttError.opacity(0.1))
                        .overlay(Capsule().stroke(Color.ttError.opacity(0.3), lineWidth: 1))
                )
            }
            
            // Capture toolbar buttons
            captureToolbar
            
            Divider().frame(height: 20)
            
            // Gallery toggle
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { showGallery.toggle() } }) {
                HStack(spacing: 3) {
                    Image(systemName: showGallery ? "sidebar.trailing" : "photo.on.rectangle")
                        .font(.ttIcon(TTIcon.md))
                    if !captureVM.screenshotHistory.isEmpty {
                        Text("\(captureVM.screenshotHistory.count)")
                            .font(TTFont.badge)
                            .foregroundColor(.ttPrimary)
                    }
                }
            }
            .buttonStyle(.ttGhost)
            .help(showGallery ? "Hide gallery" : "Show gallery")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.ttSurface.opacity(0.3))
    }
    
    // MARK: - Capture Toolbar
    @State private var showCopiedFeedback: Bool = false
    
    private var captureToolbar: some View {
        HStack(spacing: 4) {
            // ── Capture Group ──
            HStack(spacing: 2) {
                // Capture
                Button(action: { captureVM.requestCapture(from: connectionManager) }) {
                    if captureVM.isCapturing {
                        ProgressView().controlSize(.small).scaleEffect(0.6)
                            .frame(width: 14, height: 14)
                    } else {
                        Image(systemName: "camera.fill")
                            .font(.ttIcon(TTIcon.lg))
                    }
                }
                .buttonStyle(.ttGhost)
                .disabled(captureVM.isCapturing)
                .help("Capture screenshot (Space)")
                
                // Record toggle
                Button(action: toggleRecording) {
                    Image(systemName: captureVM.isRecording ? "stop.fill" : "record.circle")
                        .font(.ttIcon(TTIcon.lg))
                        .foregroundColor(captureVM.isRecording ? .ttError : .ttTextPrimary)
                }
                .buttonStyle(.ttGhost)
                .help(captureVM.isRecording ? "Stop recording" : "Start recording")
                
                // Record interval
                Button(action: { showIntervalPicker.toggle() }) {
                    Text(String(format: "%.1fs", recordingInterval))
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttTextTertiary)
                }
                .buttonStyle(.plain)
                .popover(isPresented: $showIntervalPicker) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("CAPTURE INTERVAL")
                            .font(TTFont.sidebarHeader)
                            .foregroundColor(.ttTextTertiary)
                            .tracking(0.8)
                        ForEach([0.3, 0.5, 1.0, 2.0, 5.0], id: \.self) { interval in
                            Button(action: {
                                recordingInterval = interval
                                showIntervalPicker = false
                            }) {
                                HStack {
                                    Text("\(interval, specifier: "%.1f")s")
                                        .font(TTFont.bodyMedium)
                                    Spacer()
                                    if recordingInterval == interval {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.ttPrimary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(12)
                    .frame(width: 140)
                }
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.ttSurface.opacity(0.6))
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.ttBorder.opacity(0.3), lineWidth: 1))
            )
            
            // ── Draw / Annotate — Highlighted CTA ──
            Button(action: { captureVM.isAnnotating = true }) {
                HStack(spacing: 4) {
                    Image(systemName: "pencil.tip.crop.circle")
                        .font(.ttIcon(TTIcon.lg))
                    Text("Draw")
                        .font(TTFont.badge)
                }
                .foregroundColor(captureVM.currentScreenshot != nil ? .white : .ttTextTertiary)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(captureVM.currentScreenshot != nil ? Color.ttPrimary : Color.ttSurface.opacity(0.4))
                )
            }
            .buttonStyle(.plain)
            .disabled(captureVM.currentScreenshot == nil)
            .help("Open annotation editor (Draw on screenshot)")
            
            // ── Bug report ──
            Button(action: { captureVM.openBugReport() }) {
                Image(systemName: "ladybug.fill")
                    .font(.ttIcon(TTIcon.lg))
                    .foregroundColor(captureVM.currentScreenshot != nil ? .ttWarning : .ttTextTertiary)
            }
            .buttonStyle(.ttGhost)
            .disabled(captureVM.currentScreenshot == nil)
            .help("Create bug report")
            
            Divider().frame(height: 18)
            
            // ── Action Group: Copy, Save, Share ──
            HStack(spacing: 2) {
                // Copy to clipboard
                Button(action: copyScreenshotToClipboard) {
                    HStack(spacing: 3) {
                        Image(systemName: showCopiedFeedback ? "checkmark" : "doc.on.doc")
                            .font(.ttIcon(TTIcon.md))
                            .foregroundColor(showCopiedFeedback ? .ttSuccess : .ttTextSecondary)
                        if showCopiedFeedback {
                            Text("Copied!")
                                .font(TTFont.badge)
                                .foregroundColor(.ttSuccess)
                                .transition(.opacity.combined(with: .scale(scale: 0.8)))
                        }
                    }
                    .animation(.easeOut(duration: 0.15), value: showCopiedFeedback)
                }
                .buttonStyle(.ttGhost)
                .disabled(captureVM.currentScreenshot == nil)
                .help("Copy to clipboard (⌘C)")
                .keyboardShortcut("c", modifiers: .command)
                
                // Save
                Button(action: exportScreenshotWithQuickAnnotations) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.ttIcon(TTIcon.md))
                }
                .buttonStyle(.ttGhost)
                .disabled(captureVM.currentScreenshot == nil)
                .help("Save to disk")
                
                // Share
                Button(action: {
                    if let url = exportScreenshotToURL() {
                        let picker = NSSharingServicePicker(items: [url])
                        if let contentView = NSApp.keyWindow?.contentView {
                            picker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
                        }
                    }
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.ttIcon(TTIcon.md))
                }
                .buttonStyle(.ttGhost)
                .disabled(captureVM.currentScreenshot == nil)
                .help("Share")
            }
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 7)
                    .fill(Color.ttSurface.opacity(0.6))
                    .overlay(RoundedRectangle(cornerRadius: 7).stroke(Color.ttBorder.opacity(0.3), lineWidth: 1))
            )
        }
    }
    
    // MARK: - Copy to Clipboard
    private func copyScreenshotToClipboard() {
        guard let image = captureVM.currentScreenshot else { return }
        
        var finalImage = image
        
        // Render full-editor annotations if present
        if !captureVM.annotations.isEmpty {
            finalImage = captureVM.renderAnnotatedImage(baseImage: finalImage)
        }
        
        // Render quick-draw annotations if present
        if !quickAnnotations.isEmpty && previewDisplaySize.width > 0 {
            finalImage = captureVM.renderImageWithQuickAnnotations(
                baseImage: finalImage,
                annotations: quickAnnotations,
                displaySize: previewDisplaySize
            )
        }
        
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.writeObjects([finalImage])
        
        // Show feedback
        withAnimation { showCopiedFeedback = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { showCopiedFeedback = false }
        }
    }
    
    // MARK: - Export Helpers (includes quick annotations)
    private func buildAnnotatedImage() -> NSImage? {
        guard var finalImage = captureVM.currentScreenshot else { return nil }
        
        if !captureVM.annotations.isEmpty {
            finalImage = captureVM.renderAnnotatedImage(baseImage: finalImage)
        }
        if !quickAnnotations.isEmpty && previewDisplaySize.width > 0 {
            finalImage = captureVM.renderImageWithQuickAnnotations(
                baseImage: finalImage,
                annotations: quickAnnotations,
                displaySize: previewDisplaySize
            )
        }
        return finalImage
    }
    
    private func exportScreenshotToURL() -> URL? {
        guard let image = buildAnnotatedImage() else { return nil }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "TTBDebug_\(Int(Date().timeIntervalSince1970)).png"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        if let tiffData = image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            try? pngData.write(to: fileURL)
            return fileURL
        }
        return nil
    }
    
    private func exportScreenshotWithQuickAnnotations() {
        if let url = exportScreenshotToURL() {
            NSWorkspace.shared.activateFileViewerSelecting([url])
        }
    }
    
    // MARK: - Left Panel
    private func leftPanel(device: DeviceSession) -> some View {
        ScrollView {
            VStack(spacing: 14) {
                // Screenshot preview (compact, no bezel)
                screenshotPreview
                
                // Image metadata
                if let item = captureVM.selectedHistoryItem {
                    metadataBar(item: item)
                }
                
                // Thumbnail strip
                thumbnailStrip
                
                // Device info (collapsible)
                DisclosureGroup(isExpanded: $deviceInfoExpanded) {
                    deviceInfoContent(device: device)
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "iphone")
                            .font(.ttIcon(TTIcon.md))
                            .foregroundColor(.ttTextTertiary)
                        Text("DEVICE INFO")
                            .font(TTFont.sidebarHeader)
                            .foregroundColor(.ttTextSecondary)
                            .tracking(0.8)
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.ttSurface.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.ttBorder.opacity(0.3), lineWidth: 1)
                        )
                )
                
                // Appearance toggle
                appearanceRow
                
                // Coming soon
                comingSoonSection
            }
            .padding(14)
        }
    }
    
    // MARK: - Screenshot Preview with Inline Drawing
    private var screenshotPreview: some View {
        VStack(spacing: 0) {
            // Image area
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(nsColor: NSColor(calibratedWhite: 0.06, alpha: 1.0)))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.ttBorder.opacity(0.4), lineWidth: 1)
                    )
                
                if let image = captureVM.currentScreenshot {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        // Canvas overlay (pen/arrow/rect only — text rendered separately)
                        .overlay {
                            Canvas { context, size in
                                for annotation in quickAnnotations where annotation.tool != .text {
                                    renderQuickAnnotation(annotation, in: &context, size: size)
                                }
                                if !quickDragPoints.isEmpty && quickDrawTool != .text {
                                    let current = AnnotationItem(
                                        tool: quickDrawTool, points: quickDragPoints,
                                        color: quickDrawColor, lineWidth: quickDrawWidth
                                    )
                                    renderQuickAnnotation(current, in: &context, size: size)
                                }
                            }
                            .allowsHitTesting(false)
                        }
                        // Text annotations overlay (draggable SwiftUI views)
                        .overlay {
                            quickTextAnnotationsOverlay
                        }
                        // Drawing gesture overlay (disabled during text input)
                        .overlay {
                            if quickDrawEnabled && !showQuickTextInput {
                                Color.clear
                                    .contentShape(Rectangle())
                                    .gesture(quickDrawGesture)
                            }
                        }
                        // Capture rendered size for coordinate scaling
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .onAppear { previewDisplaySize = geo.size }
                                    .onChange(of: geo.size) { _, newSize in
                                        previewDisplaySize = newSize
                                    }
                            }
                        )
                        .padding(10)
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "iphone")
                            .font(TTFont.displayMedium)
                            .foregroundColor(.ttTextTertiary.opacity(0.4))
                        Text("Capture a screenshot to start")
                            .font(TTFont.bodySmall)
                            .foregroundColor(.ttTextTertiary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .frame(minHeight: 250, maxHeight: 480)
            .onTapGesture(count: 2) {
                if captureVM.currentScreenshot != nil && !showQuickTextInput {
                    captureVM.isAnnotating = true
                }
            }
            // Quick text input popover
            .overlay {
                if showQuickTextInput {
                    quickTextInputOverlay
                }
            }
            
            // Toolbar — sits BELOW the image, never overlapping
            if captureVM.currentScreenshot != nil {
                quickDrawMiniToolbar
                    .padding(.top, 6)
                    .padding(.bottom, 2)
            }
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Quick Draw Mini Toolbar
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var quickDrawMiniToolbar: some View {
        HStack(spacing: 0) {
            // Tool buttons
            HStack(spacing: 2) {
                quickToolBtn(.pen)
                quickToolBtn(.arrow)
                quickToolBtn(.rectangle)
                quickToolBtn(.text)
            }
            .padding(.horizontal, 4)
            
            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1, height: 18)
                .padding(.horizontal, 4)
            
            // Color palette
            HStack(spacing: 3) {
                ForEach([Color.red, .orange, .yellow, .green, .blue, .white], id: \.self) { color in
                    Button(action: { quickDrawColor = color }) {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: quickDrawColor == color ? 1.5 : 0)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.ttPrimary, lineWidth: quickDrawColor == color ? 1 : 0)
                                    .padding(-2)
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 4)
            
            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1, height: 18)
                .padding(.horizontal, 4)
            
            // Undo / Redo / Clear
            HStack(spacing: 2) {
                Button(action: quickUndo) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(quickAnnotations.isEmpty ? .white.opacity(0.25) : .white.opacity(0.8))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .disabled(quickAnnotations.isEmpty)
                .help("Undo")
                
                Button(action: quickRedo) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(quickRedoStack.isEmpty ? .white.opacity(0.25) : .white.opacity(0.8))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .disabled(quickRedoStack.isEmpty)
                .help("Redo")
                
                Button(action: {
                    quickAnnotations.removeAll()
                    quickRedoStack.removeAll()
                }) {
                    Image(systemName: "trash")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(quickAnnotations.isEmpty ? .white.opacity(0.25) : .ttError.opacity(0.9))
                        .frame(width: 24, height: 24)
                }
                .buttonStyle(.plain)
                .disabled(quickAnnotations.isEmpty)
                .help("Clear all")
            }
            .padding(.horizontal, 2)
            
            // Annotation count badge
            if !quickAnnotations.isEmpty {
                Text("\(quickAnnotations.count)")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 2)
                    .background(Capsule().fill(Color.ttPrimary))
                    .padding(.trailing, 4)
            }
        }
        .padding(.vertical, 5)
        .padding(.horizontal, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
                .overlay(
                    Capsule()
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.35), radius: 8, y: 3)
    }
    
    private func quickToolBtn(_ tool: AnnotationTool) -> some View {
        let isSelected = quickDrawEnabled && quickDrawTool == tool
        return Button(action: {
            if quickDrawTool == tool && quickDrawEnabled {
                quickDrawEnabled = false
            } else {
                quickDrawTool = tool
                quickDrawEnabled = true
            }
        }) {
            Image(systemName: tool.icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isSelected ? .white : .white.opacity(0.55))
                .frame(width: 26, height: 26)
                .background(
                    RoundedRectangle(cornerRadius: 5)
                        .fill(isSelected ? Color.ttPrimary : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .help(tool.rawValue)
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Quick Text Input Overlay
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var quickTextInputOverlay: some View {
        ZStack(alignment: .topLeading) {
            // Dismiss background
            Color.black.opacity(0.15)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .onTapGesture { commitQuickText() }
            
            // Input card
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 5) {
                    Circle()
                        .fill(quickDrawColor)
                        .frame(width: 8, height: 8)
                    Text("Add Note")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(.white.opacity(0.5))
                }
                
                HStack(spacing: 6) {
                    QuickNoteTextField(
                        text: $quickTextInput,
                        placeholder: "Type description...",
                        onCommit: commitQuickText
                    )
                    .frame(minWidth: 160, maxWidth: 280, minHeight: 22)
                    
                    Button(action: commitQuickText) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.ttPrimary)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        showQuickTextInput = false
                        quickTextInput = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.35))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.ttPrimary.opacity(0.4), lineWidth: 1)
                    )
            )
            .shadow(color: .black.opacity(0.5), radius: 12, y: 4)
            .offset(x: min(quickTextPosition.x, previewDisplaySize.width - 200),
                    y: quickTextPosition.y + 8)
            .padding(10)
        }
    }
    
    // MARK: - Text Annotations Overlay (draggable)
    private var quickTextAnnotationsOverlay: some View {
        ForEach(Array(quickAnnotations.enumerated()), id: \.element.id) { index, annotation in
            if annotation.tool == .text, let pos = annotation.points.first, !annotation.text.isEmpty {
                let fontSize: CGFloat = max(11, annotation.lineWidth * 3.5)
                Text(annotation.text)
                    .font(.system(size: fontSize, weight: .semibold))
                    .foregroundColor(annotation.color)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 2)
                    .background(
                        RoundedRectangle(cornerRadius: 3)
                            .fill(Color.black.opacity(0.55))
                    )
                    .overlay(
                        quickDrawTool == .text ?
                        RoundedRectangle(cornerRadius: 3)
                            .stroke(Color.white.opacity(0.3), style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
                        : nil
                    )
                    .position(x: pos.x + 20, y: pos.y + 10)
                    .gesture(
                        quickDrawTool == .text ?
                        DragGesture(minimumDistance: 1)
                            .onChanged { value in
                                quickAnnotations[index].points = [
                                    CGPoint(x: value.location.x - 20, y: value.location.y - 10)
                                ]
                            }
                        : nil
                    )
            }
        }
    }
    
    // MARK: - Quick Draw Gesture
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var quickDrawGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                switch quickDrawTool {
                case .text:
                    // Single tap — just track position
                    if quickDragPoints.isEmpty {
                        quickDragPoints = [value.location]
                    }
                case .arrow, .line, .rectangle, .ellipse:
                    quickDragPoints = [value.startLocation, value.location]
                default:
                    // pen — freehand
                    quickDragPoints.append(value.location)
                }
            }
            .onEnded { _ in
                handleQuickDrawEnd()
            }
    }
    
    private func handleQuickDrawEnd() {
        // Text tool — show input field
        if quickDrawTool == .text {
            if let pos = quickDragPoints.first {
                quickTextPosition = pos
                quickTextInput = ""
                showQuickTextInput = true
            }
            quickDragPoints.removeAll()
            return
        }
        
        guard quickDragPoints.count >= 2 else {
            quickDragPoints.removeAll()
            return
        }
        let annotation = AnnotationItem(
            tool: quickDrawTool,
            points: quickDragPoints,
            color: quickDrawColor,
            lineWidth: quickDrawWidth
        )
        quickAnnotations.append(annotation)
        quickRedoStack.removeAll()
        quickDragPoints.removeAll()
    }
    
    private func commitQuickText() {
        guard !quickTextInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showQuickTextInput = false
            quickTextInput = ""
            return
        }
        var annotation = AnnotationItem(
            tool: .text,
            points: [quickTextPosition],
            color: quickDrawColor,
            lineWidth: quickDrawWidth
        )
        annotation.text = quickTextInput
        quickAnnotations.append(annotation)
        quickRedoStack.removeAll()
        showQuickTextInput = false
        quickTextInput = ""
    }
    
    private func quickUndo() {
        guard let last = quickAnnotations.popLast() else { return }
        quickRedoStack.append(last)
    }
    
    private func quickRedo() {
        guard let last = quickRedoStack.popLast() else { return }
        quickAnnotations.append(last)
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Quick Draw Canvas Rendering
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func renderQuickAnnotation(_ annotation: AnnotationItem, in context: inout GraphicsContext, size: CGSize) {
        let shading: GraphicsContext.Shading = .color(annotation.color)
        
        switch annotation.tool {
        case .pen:
            if annotation.points.count >= 2 {
                let path = PathSmoothing.smoothedPath(from: annotation.points)
                context.stroke(path, with: shading, style: StrokeStyle(
                    lineWidth: annotation.lineWidth, lineCap: .round, lineJoin: .round
                ))
            }
            
        case .arrow:
            if annotation.points.count >= 2,
               let start = annotation.points.first, let end = annotation.points.last {
                var path = Path()
                path.move(to: start)
                path.addLine(to: end)
                context.stroke(path, with: shading, style: StrokeStyle(
                    lineWidth: annotation.lineWidth, lineCap: .round
                ))
                let head = ArrowGeometry.arrowHead(start: start, end: end, lineWidth: annotation.lineWidth, headLengthMultiplier: 4.0)
                var arrow = Path()
                arrow.move(to: head.p1)
                arrow.addLine(to: head.tip)
                arrow.addLine(to: head.p2)
                arrow.closeSubpath()
                context.fill(arrow, with: shading)
            }
            
        case .rectangle:
            if let rect = annotation.boundingRect {
                let path = Path(roundedRect: rect, cornerRadius: 2)
                context.stroke(path, with: shading, lineWidth: annotation.lineWidth)
            }
            
        case .text:
            // Text is rendered as SwiftUI views in quickTextAnnotationsOverlay
            // (to support drag-to-reposition). Canvas skips text.
            break
            
        default:
            break
        }
    }
    
    // MARK: - Metadata Bar
    private func metadataBar(item: ScreenshotItem) -> some View {
        HStack(spacing: 8) {
            metaChip(icon: "clock", text: item.formattedTime)
            metaChip(icon: "arrow.up.left.and.arrow.down.right", text: item.resolutionText)
            metaChip(icon: "doc", text: item.fileSizeEstimate)
            Spacer()
        }
    }
    
    private func metaChip(icon: String, text: String) -> some View {
        HStack(spacing: 3) {
            Image(systemName: icon).font(.ttIcon(TTIcon.xxs)).foregroundColor(.ttTextTertiary)
            Text(text).font(TTFont.codeSmall).foregroundColor(.ttTextTertiary)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Capsule().fill(Color.ttSurface.opacity(0.6)))
    }
    
    // MARK: - Thumbnail Strip
    private var thumbnailStrip: some View {
        Group {
            if !captureVM.screenshotHistory.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 5) {
                        ForEach(captureVM.screenshotHistory.prefix(15)) { item in
                            let selected = captureVM.selectedHistoryItem?.id == item.id
                            Button(action: { captureVM.selectItem(item) }) {
                                Image(nsImage: item.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36, height: 56)
                                    .background(Color(nsColor: NSColor(calibratedWhite: 0.06, alpha: 1.0)))
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(selected ? Color.ttPrimary : Color.ttBorder.opacity(0.3), lineWidth: selected ? 2 : 1)
                                    )
                            }
                            .buttonStyle(.plain)
                            .contextMenu {
                                galleryItemContextMenu(item)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Device Info Content
    private func deviceInfoContent(device: DeviceSession) -> some View {
        VStack(spacing: 6) {
            infoRow(icon: "gear", label: "OS", value: device.osVersionString)
            infoRow(icon: "app.badge", label: "App", value: "\(device.appNameString) v\(device.deviceInfo?.appVersion ?? "—")")
            infoRow(icon: "rectangle.on.rectangle", label: "Screen", value: {
                if let info = device.deviceInfo {
                    return "\(Int(info.screenWidth))×\(Int(info.screenHeight))pt"
                }
                return "—"
            }())
            infoRow(icon: "wrench.and.screwdriver", label: "SDK", value: device.deviceInfo?.sdkVersion ?? "—")
            
            if device.isSimulator {
                HStack(spacing: 6) {
                    Image(systemName: "desktopcomputer").font(.ttIcon(TTIcon.sm)).foregroundColor(.ttWarning).frame(width: 18)
                    Text("Simulator").font(TTFont.labelSmall).foregroundColor(.ttWarning)
                    Spacer()
                    StatusBadge(text: "SIM", color: .ttWarning, style: .filled)
                }
            }
            
            HStack(spacing: 6) {
                Image(systemName: "clock").font(.ttIcon(TTIcon.sm)).foregroundColor(.ttTextTertiary).frame(width: 18)
                Text("Connected").font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
                Spacer()
                Text(device.connectedAt, style: .relative).font(TTFont.codeSmall).foregroundColor(.ttTextSecondary)
            }
        }
        .padding(.top, 6)
    }
    
    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon).font(.ttIcon(TTIcon.sm)).foregroundColor(.ttTextTertiary).frame(width: 18)
            Text(label).font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
            Spacer()
            Text(value).font(TTFont.codeSmall).foregroundColor(.ttTextPrimary).lineLimit(1)
        }
    }
    
    // MARK: - Appearance
    private var appearanceRow: some View {
        HStack(spacing: 8) {
            Image(systemName: darkModeOverride ? "moon.fill" : "sun.max.fill")
                .font(.ttIcon(TTIcon.lg))
                .foregroundColor(darkModeOverride ? .ttPrimary : .ttWarning)
                .frame(width: 20)
            Text("Dark Mode")
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextPrimary)
            Spacer()
            Toggle("", isOn: Binding(
                get: { darkModeOverride },
                set: { newValue in
                    darkModeOverride = newValue
                    connectionManager.sendCommand(newValue ? "dark_mode_on" : "dark_mode_off")
                }
            ))
            .toggleStyle(.switch)
            .tint(.ttPrimary)
            .controlSize(.small)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ttSurface.opacity(0.5))
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.ttBorder.opacity(0.3), lineWidth: 1))
        )
    }
    
    // MARK: - Coming Soon
    private var comingSoonSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach([("rocket.fill", "App Lifecycle"), ("accessibility", "Accessibility"), ("hand.tap.fill", "Touch Overlay")], id: \.1) { icon, title in
                HStack(spacing: 6) {
                    Image(systemName: icon).font(.ttIcon(TTIcon.sm)).foregroundColor(.ttTextTertiary).frame(width: 18)
                    Text(title).font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
                    Spacer()
                    StatusBadge(text: "SOON", color: .ttTextTertiary, style: .outlined)
                }
                .opacity(0.4)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ttSurface.opacity(0.3))
        )
    }
    
    // MARK: - Right Gallery Panel
    private var rightGalleryPanel: some View {
        VStack(spacing: 0) {
            galleryToolbar
            Divider().background(Color.ttBorder.opacity(0.3))
            
            if captureVM.screenshotHistory.isEmpty {
                VStack(spacing: 12) {
                    Spacer()
                    Image(systemName: "photo.stack")
                        .font(TTFont.displayLarge)
                        .foregroundColor(.ttTextTertiary.opacity(0.4))
                    Text("No Screenshots")
                        .font(TTFont.heading3)
                        .foregroundColor(.ttTextTertiary)
                    Text("Captured screenshots appear here")
                        .font(TTFont.bodySmall)
                        .foregroundColor(.ttTextTertiary)
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            } else {
                galleryContent
            }
            
            if !captureVM.screenshotHistory.isEmpty {
                galleryFooter
            }
        }
        .background(Color.ttBackground)
    }
    
    // MARK: - Gallery Toolbar
    private var galleryToolbar: some View {
        HStack(spacing: 6) {
            Text("SCREENSHOTS")
                .font(TTFont.sidebarHeader)
                .foregroundColor(.ttTextSecondary)
                .tracking(0.8)
            
            Text("\(captureVM.screenshotHistory.count)")
                .font(TTFont.badge)
                .foregroundColor(.ttPrimary)
                .padding(.horizontal, 5)
                .padding(.vertical, 1)
                .background(Capsule().fill(Color.ttPrimary.opacity(0.15)))
            
            Spacer()
            
            Picker("", selection: $captureVM.galleryViewMode) {
                ForEach(GalleryViewMode.allCases, id: \.self) { mode in
                    Image(systemName: mode.icon).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 64)
            
            Menu {
                ForEach(GallerySortOrder.allCases, id: \.self) { order in
                    Button { captureVM.sortOrder = order } label: {
                        HStack {
                            Text(order.rawValue)
                            if captureVM.sortOrder == order { Image(systemName: "checkmark") }
                        }
                    }
                }
            } label: {
                Image(systemName: "arrow.up.arrow.down").font(.ttIcon(TTIcon.sm))
            }
            .menuStyle(.borderlessButton)
            .frame(width: 20)
            
            Button(action: {
                captureVM.isMultiSelectMode.toggle()
                if !captureVM.isMultiSelectMode { captureVM.deselectAll() }
            }) {
                Image(systemName: captureVM.isMultiSelectMode ? "checkmark.circle.fill" : "checkmark.circle")
                    .font(.ttIcon(TTIcon.lg))
                    .foregroundColor(captureVM.isMultiSelectMode ? .ttPrimary : .ttTextTertiary)
            }
            .buttonStyle(.plain)
            .help("Multi-select")
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
    }
    
    // MARK: - Gallery Content
    private var galleryContent: some View {
        ScrollView {
            switch captureVM.galleryViewMode {
            case .grid: galleryGrid
            case .list: galleryList
            }
        }
    }
    
    private var galleryGrid: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90, maximum: 130), spacing: 6)], spacing: 6) {
            ForEach(captureVM.sortedHistory) { item in
                galleryGridItem(item)
            }
        }
        .padding(10)
    }
    
    private func galleryGridItem(_ item: ScreenshotItem) -> some View {
        let isSelected = captureVM.selectedHistoryItem?.id == item.id
        let isChecked = captureVM.selectedItems.contains(item.id)
        
        return Button(action: {
            captureVM.isMultiSelectMode ? captureVM.toggleSelection(item.id) : captureVM.selectItem(item)
        }) {
            VStack(spacing: 3) {
                ZStack(alignment: .topTrailing) {
                    Image(nsImage: item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                        .frame(maxWidth: .infinity)
                        .background(Color(nsColor: NSColor(calibratedWhite: 0.06, alpha: 1.0)))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(isSelected ? Color.ttPrimary : Color.ttBorder.opacity(0.3), lineWidth: isSelected ? 2 : 1)
                        )
                    
                    if captureVM.isMultiSelectMode {
                        Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                            .font(.ttIcon(TTIcon.xxl))
                            .foregroundColor(isChecked ? .ttPrimary : .white.opacity(0.7))
                            .shadow(color: .black.opacity(0.5), radius: 2)
                            .padding(4)
                    }
                }
                
                Text(item.formattedTime)
                    .font(TTFont.codeSmall)
                    .foregroundColor(isSelected ? .ttPrimary : .ttTextTertiary)
            }
        }
        .buttonStyle(.plain)
        .contextMenu { galleryItemContextMenu(item) }
    }
    
    private var galleryList: some View {
        LazyVStack(spacing: 0) {
            ForEach(captureVM.sortedHistory) { item in
                galleryListItem(item)
            }
        }
    }
    
    private func galleryListItem(_ item: ScreenshotItem) -> some View {
        let isSelected = captureVM.selectedHistoryItem?.id == item.id
        let isChecked = captureVM.selectedItems.contains(item.id)
        
        return Button(action: {
            captureVM.isMultiSelectMode ? captureVM.toggleSelection(item.id) : captureVM.selectItem(item)
        }) {
            HStack(spacing: 8) {
                if captureVM.isMultiSelectMode {
                    Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                        .font(.ttIcon(TTIcon.xl))
                        .foregroundColor(isChecked ? .ttPrimary : .ttTextTertiary)
                }
                
                Image(nsImage: item.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 36, height: 52)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(item.formattedDateTime)
                        .font(TTFont.labelSmall)
                        .foregroundColor(isSelected ? .ttPrimary : .ttTextPrimary)
                    HStack(spacing: 6) {
                        Text(item.resolutionText).font(TTFont.codeSmall).foregroundColor(.ttTextTertiary)
                        Text("•").foregroundColor(.ttTextTertiary)
                        Text(item.fileSizeEstimate).font(TTFont.codeSmall).foregroundColor(.ttTextTertiary)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(isSelected ? Color.ttPrimary.opacity(0.08) : Color.clear)
            )
        }
        .buttonStyle(.plain)
        .contextMenu { galleryItemContextMenu(item) }
    }
    
    // MARK: - Context Menu
    @ViewBuilder
    private func galleryItemContextMenu(_ item: ScreenshotItem) -> some View {
        Button { captureVM.selectItem(item) } label: { Label("View", systemImage: "eye") }
        Button { captureVM.selectItem(item); captureVM.isAnnotating = true } label: { Label("Draw / Annotate", systemImage: "pencil.tip.crop.circle") }
        Button { captureVM.openBugReport(with: [item.image]) } label: { Label("Bug Report", systemImage: "ladybug") }
        Divider()
        Button {
            let pasteboard = NSPasteboard.general
            pasteboard.clearContents()
            pasteboard.writeObjects([item.image])
        } label: { Label("Copy to Clipboard", systemImage: "doc.on.doc") }
        Button {
            if let url = captureVM.exportItem(item) { NSWorkspace.shared.activateFileViewerSelecting([url]) }
        } label: { Label("Save to Disk", systemImage: "square.and.arrow.down") }
        Button {
            if let url = captureVM.exportItem(item) {
                let picker = NSSharingServicePicker(items: [url])
                if let view = NSApp.keyWindow?.contentView { picker.show(relativeTo: .zero, of: view, preferredEdge: .minY) }
            }
        } label: { Label("Share...", systemImage: "square.and.arrow.up") }
        Divider()
        Button(role: .destructive) { deleteTarget = .single(item.id); showDeleteConfirm = true } label: { Label("Delete", systemImage: "trash") }
    }
    
    // MARK: - Gallery Footer
    private var galleryFooter: some View {
        HStack(spacing: 6) {
            if captureVM.isMultiSelectMode {
                Button(action: { captureVM.selectAll() }) {
                    Text("All").font(TTFont.labelSmall)
                }
                .buttonStyle(.ttGhost)
                
                if captureVM.hasSelection {
                    Text("\(captureVM.selectedCount) sel.")
                        .font(TTFont.codeSmall)
                        .foregroundColor(.ttPrimary)
                    
                    Spacer()
                    
                    Button(action: { captureVM.openBugReportFromSelected() }) {
                        Image(systemName: "ladybug").font(.ttIcon(TTIcon.sm))
                    }
                    .buttonStyle(.ttGhost)
                    .help("Create bug report from selected")
                    
                    Button(action: {
                        let urls = captureVM.exportSelected()
                        if !urls.isEmpty { NSWorkspace.shared.activateFileViewerSelecting(urls) }
                    }) {
                        Image(systemName: "square.and.arrow.down").font(.ttIcon(TTIcon.sm))
                    }
                    .buttonStyle(.ttGhost)
                    
                    Button(action: { deleteTarget = .selected; showDeleteConfirm = true }) {
                        Image(systemName: "trash").font(.ttIcon(TTIcon.sm)).foregroundColor(.ttError)
                    }
                    .buttonStyle(.ttGhost)
                } else { Spacer() }
            } else {
                Text("\(captureVM.screenshotHistory.count) screenshots")
                    .font(TTFont.codeSmall).foregroundColor(.ttTextTertiary)
                Spacer()
                Menu {
                    Button {
                        let urls = captureVM.exportAll()
                        if !urls.isEmpty { NSWorkspace.shared.activateFileViewerSelecting(urls) }
                    } label: { Label("Export All", systemImage: "square.and.arrow.down") }
                    Divider()
                    Button(role: .destructive) { deleteTarget = .all; showDeleteConfirm = true } label: { Label("Clear All", systemImage: "trash") }
                } label: {
                    Image(systemName: "ellipsis.circle").font(.ttIcon(TTIcon.lg)).foregroundColor(.ttTextTertiary)
                }
                .menuStyle(.borderlessButton)
                .frame(width: 24)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.ttBackground)
        .overlay(Rectangle().fill(Color.ttBorder.opacity(0.3)).frame(height: 1), alignment: .top)
    }
    
    // MARK: - Helpers
    private func toggleRecording() {
        if captureVM.isRecording {
            captureVM.stopRecording()
        } else {
            captureVM.startRecording(connectionManager: connectionManager, interval: recordingInterval)
        }
    }
    
    private var currentDeviceInfoSnapshot: DeviceInfoSnapshot {
        guard let device = connectionManager.selectedDevice else { return .empty }
        return DeviceInfoSnapshot(
            deviceName: device.displayName,
            osVersion: device.osVersionString,
            appName: device.appNameString,
            appVersion: device.deviceInfo?.appVersion ?? "—",
            sdkVersion: device.deviceInfo?.sdkVersion ?? "—",
            screenResolution: {
                if let info = device.deviceInfo {
                    return "\(Int(info.screenWidth))×\(Int(info.screenHeight))pt"
                }
                return "—"
            }(),
            isSimulator: device.isSimulator
        )
    }
}

#Preview {
    DeviceView()
        .environment(ConnectionManager())
        .frame(width: 1000, height: 800)
        .preferredColorScheme(.dark)
}
