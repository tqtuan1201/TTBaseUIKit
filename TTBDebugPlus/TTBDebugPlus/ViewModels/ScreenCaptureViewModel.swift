//
//  ScreenCaptureViewModel.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Manages screenshot capture, recording sessions, GIF export, gallery & annotations
//

import SwiftUI
import AppKit
import ImageIO
import UniformTypeIdentifiers

// MARK: - Screen Capture ViewModel
@Observable
final class ScreenCaptureViewModel {
    
    // MARK: - Screenshot State
    var currentScreenshot: NSImage? = nil
    var screenshotHistory: [ScreenshotItem] = []
    var isCapturing: Bool = false
    var selectedHistoryItem: ScreenshotItem? = nil
    
    // MARK: - Gallery State
    var selectedItems: Set<UUID> = []
    var isMultiSelectMode: Bool = false
    var galleryViewMode: GalleryViewMode = .grid
    var sortOrder: GallerySortOrder = .newest
    
    // MARK: - Annotation State
    var isAnnotating: Bool = false
    var annotations: [AnnotationItem] = []
    var selectedTool: AnnotationTool = .pen
    var selectedColor: Color = .red
    var lineWidth: CGFloat = 3.0
    
    // MARK: - Recording State
    var recordingSession = RecordingSession()
    var recordingElapsed: TimeInterval = 0
    var showRecordingExport: Bool = false
    
    // MARK: - Bug Report State
    var showBugReportComposer: Bool = false
    var reportScreenshots: [NSImage] = []
    
    // MARK: - Fullscreen Preview
    var isFullscreenPreview: Bool = false
    
    // MARK: - Private
    private var recordingSource: DispatchSourceTimer?
    private var elapsedTimer: Timer?
    private let maxHistoryCount = 50
    private let timerQueue = DispatchQueue(label: "com.ttbdebug.recording", qos: .utility)
    
    // MARK: - Computed
    var sortedHistory: [ScreenshotItem] {
        switch sortOrder {
        case .newest: return screenshotHistory
        case .oldest: return screenshotHistory.reversed()
        }
    }
    
    var selectedCount: Int { selectedItems.count }
    var hasSelection: Bool { !selectedItems.isEmpty }
    var isRecording: Bool { recordingSession.isActive }
    
    // MARK: - Capture Screenshot
    func requestCapture(from connectionManager: ConnectionManager) {
        // During recording, skip the isCapturing guard to allow overlapping requests
        if !isRecording {
            guard !isCapturing else { return }
        }
        isCapturing = true
        
        let quality = isRecording ? 0.4 : 0.7
        let maxWidth = isRecording ? 750 : 1170
        connectionManager.requestScreenshot(quality: quality, maxWidth: maxWidth)
        
        // Timeout fallback — reset isCapturing if no response within 8s
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) { [weak self] in
            self?.isCapturing = false
        }
    }
    
    // MARK: - Handle Received Screenshot
    func handleScreenshotReceived(_ response: ScreenshotResponsePayload) {
        isCapturing = false
        
        guard let imageData = Data(base64Encoded: response.imageData),
              let image = NSImage(data: imageData) else {
            print("[TTBDebug] Failed to decode screenshot")
            return
        }
        
        DispatchQueue.main.async { [self] in
            currentScreenshot = image
            
            let item = ScreenshotItem(
                image: image,
                timestamp: Date(timeIntervalSince1970: response.timestamp / 1000),
                orientation: response.orientation,
                screenSize: CGSize(width: response.screenWidth, height: response.screenHeight)
            )
            screenshotHistory.insert(item, at: 0)
            selectedHistoryItem = item
            
            // Add to recording session
            if recordingSession.isActive {
                let frame = RecordingFrame(
                    image: image,
                    timestamp: Date(),
                    index: recordingSession.frameCount
                )
                recordingSession.frames.append(frame)
            }
            
            // Trim history
            if screenshotHistory.count > maxHistoryCount {
                screenshotHistory = Array(screenshotHistory.prefix(maxHistoryCount))
            }
        }
    }
    
    // MARK: - Recording
    func startRecording(connectionManager: ConnectionManager, interval: TimeInterval = 0.5) {
        guard !recordingSession.isActive else { return }
        recordingSession = RecordingSession()
        recordingSession.isActive = true
        recordingSession.interval = interval
        recordingSession.startTime = Date()
        recordingElapsed = 0
        
        // Use DispatchSourceTimer on background queue to avoid main thread blocking
        let source = DispatchSource.makeTimerSource(queue: timerQueue)
        source.schedule(deadline: .now() + interval, repeating: interval)
        source.setEventHandler { [weak self] in
            DispatchQueue.main.async { self?.requestCapture(from: connectionManager) }
        }
        source.resume()
        recordingSource = source
        
        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self, self.recordingSession.isActive else { return }
            self.recordingElapsed = Date().timeIntervalSince(self.recordingSession.startTime)
        }
        
        // Capture first frame immediately
        requestCapture(from: connectionManager)
    }
    
    func stopRecording() {
        recordingSession.isActive = false
        recordingSource?.cancel()
        recordingSource = nil
        elapsedTimer?.invalidate()
        elapsedTimer = nil
        
        if recordingSession.frameCount > 0 {
            showRecordingExport = true
        }
    }
    
    var formattedRecordingTime: String {
        let mins = Int(recordingElapsed) / 60
        let secs = Int(recordingElapsed) % 60
        return String(format: "%d:%02d", mins, secs)
    }
    
    // MARK: - GIF Export
    func exportGIF(speed: Double = 1.0) -> URL? {
        let frames = recordingSession.frames.compactMap { $0.image }
        guard !frames.isEmpty else { return nil }
        
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("TTBDebug_\(Int(Date().timeIntervalSince1970)).gif")
        
        guard let destination = CGImageDestinationCreateWithURL(
            url as CFURL, UTType.gif.identifier as CFString, frames.count, nil
        ) else { return nil }
        
        let gifProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFLoopCount as String: 0
            ]
        ]
        CGImageDestinationSetProperties(destination, gifProperties as CFDictionary)
        
        let frameDelay = recordingSession.interval / speed
        let frameProperties: [String: Any] = [
            kCGImagePropertyGIFDictionary as String: [
                kCGImagePropertyGIFDelayTime as String: frameDelay
            ]
        ]
        
        for frame in frames {
            if let cgImage = frame.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                CGImageDestinationAddImage(destination, cgImage, frameProperties as CFDictionary)
            }
        }
        
        guard CGImageDestinationFinalize(destination) else { return nil }
        return url
    }
    
    func exportImageSequence() -> URL? {
        let frames = recordingSession.frames.compactMap { $0.image }
        guard !frames.isEmpty else { return nil }
        
        let dir = FileManager.default.temporaryDirectory
            .appendingPathComponent("TTBDebug_Sequence_\(Int(Date().timeIntervalSince1970))")
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        
        for (i, image) in frames.enumerated() {
            let fileName = String(format: "frame_%04d.png", i)
            let fileURL = dir.appendingPathComponent(fileName)
            if let tiffData = image.tiffRepresentation,
               let bitmap = NSBitmapImageRep(data: tiffData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                try? pngData.write(to: fileURL)
            }
        }
        
        return dir
    }
    
    func discardRecording() {
        recordingSession.reset()
        recordingElapsed = 0
        showRecordingExport = false
    }
    
    // MARK: - Gallery Management
    func selectItem(_ item: ScreenshotItem) {
        currentScreenshot = item.image
        selectedHistoryItem = item
    }
    
    func toggleSelection(_ id: UUID) {
        if selectedItems.contains(id) {
            selectedItems.remove(id)
        } else {
            selectedItems.insert(id)
        }
    }
    
    func selectAll() {
        selectedItems = Set(screenshotHistory.map { $0.id })
    }
    
    func deselectAll() {
        selectedItems.removeAll()
        isMultiSelectMode = false
    }
    
    func deleteSelected() {
        screenshotHistory.removeAll { selectedItems.contains($0.id) }
        if let current = selectedHistoryItem, selectedItems.contains(current.id) {
            selectedHistoryItem = screenshotHistory.first
            currentScreenshot = screenshotHistory.first?.image
        }
        selectedItems.removeAll()
        isMultiSelectMode = false
    }
    
    func deleteItem(_ id: UUID) {
        screenshotHistory.removeAll { $0.id == id }
        if selectedHistoryItem?.id == id {
            selectedHistoryItem = screenshotHistory.first
            currentScreenshot = screenshotHistory.first?.image
        }
    }
    
    func clearAllHistory() {
        screenshotHistory.removeAll()
        selectedItems.removeAll()
        selectedHistoryItem = nil
        currentScreenshot = nil
        isMultiSelectMode = false
    }
    
    // MARK: - Export
    func exportScreenshot(withAnnotations: Bool = false) -> URL? {
        guard let image = currentScreenshot else { return nil }
        
        let finalImage: NSImage
        if withAnnotations && !annotations.isEmpty {
            finalImage = renderAnnotatedImage(baseImage: image)
        } else {
            finalImage = image
        }
        
        let tempDir = FileManager.default.temporaryDirectory
        let fileName = "TTBDebug_\(Int(Date().timeIntervalSince1970)).png"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        if let tiffData = finalImage.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            try? pngData.write(to: fileURL)
            return fileURL
        }
        return nil
    }
    
    func exportItem(_ item: ScreenshotItem) -> URL? {
        let tempDir = FileManager.default.temporaryDirectory
        let formatter = DateFormatter()
        formatter.dateFormat = "HHmmss"
        let fileName = "TTBDebug_\(formatter.string(from: item.timestamp))_\(item.id.uuidString.prefix(4)).png"
        let fileURL = tempDir.appendingPathComponent(fileName)
        
        if let tiffData = item.image.tiffRepresentation,
           let bitmap = NSBitmapImageRep(data: tiffData),
           let pngData = bitmap.representation(using: .png, properties: [:]) {
            try? pngData.write(to: fileURL)
            return fileURL
        }
        return nil
    }
    
    func exportSelected() -> [URL] {
        screenshotHistory
            .filter { selectedItems.contains($0.id) }
            .compactMap { exportItem($0) }
    }
    
    func exportAll() -> [URL] {
        screenshotHistory.compactMap { exportItem($0) }
    }
    
    // MARK: - Bug Report
    func openBugReport(with images: [NSImage]? = nil) {
        if let images {
            reportScreenshots = images
        } else if let current = currentScreenshot {
            reportScreenshots = [current]
        }
        showBugReportComposer = true
    }
    
    func openBugReportFromSelected() {
        let images = screenshotHistory
            .filter { selectedItems.contains($0.id) }
            .map { $0.image }
        openBugReport(with: images)
    }
    
    // MARK: - Annotation Rendering (for export)
    func renderAnnotatedImage(baseImage: NSImage) -> NSImage {
        let size = baseImage.size
        let image = NSImage(size: size)
        
        image.lockFocus()
        baseImage.draw(in: NSRect(origin: .zero, size: size))
        
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return baseImage
        }
        
        for annotation in annotations {
            renderAnnotationToCG(annotation, context: context, imageSize: size)
        }
        
        image.unlockFocus()
        return image
    }
    
    private func renderAnnotationToCG(_ annotation: AnnotationItem, context: CGContext, imageSize: CGSize) {
        context.setStrokeColor(NSColor(annotation.color).cgColor)
        context.setFillColor(NSColor(annotation.color).cgColor)
        context.setLineWidth(annotation.lineWidth)
        context.setLineCap(.round)
        context.setLineJoin(.round)
        
        switch annotation.tool {
        case .pen:
            if annotation.points.count >= 2 {
                context.move(to: annotation.points[0])
                for i in 1..<annotation.points.count {
                    let prev = annotation.points[i - 1]
                    let curr = annotation.points[i]
                    let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
                    context.addQuadCurve(to: mid, control: prev)
                }
                context.addLine(to: annotation.points.last!)
                context.strokePath()
            }
            
        case .marker:
            if annotation.points.count >= 2 {
                context.setStrokeColor(NSColor(annotation.color).withAlphaComponent(0.4).cgColor)
                context.setLineWidth(annotation.lineWidth * 5)
                context.move(to: annotation.points[0])
                for i in 1..<annotation.points.count {
                    let prev = annotation.points[i - 1]
                    let curr = annotation.points[i]
                    let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
                    context.addQuadCurve(to: mid, control: prev)
                }
                context.addLine(to: annotation.points.last!)
                context.strokePath()
            }
            
        case .highlight:
            if annotation.points.count >= 2 {
                context.setStrokeColor(NSColor(annotation.color).withAlphaComponent(0.35).cgColor)
                context.setLineWidth(annotation.lineWidth * 4)
                context.move(to: annotation.points[0])
                for i in 1..<annotation.points.count {
                    let prev = annotation.points[i - 1]
                    let curr = annotation.points[i]
                    let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
                    context.addQuadCurve(to: mid, control: prev)
                }
                context.addLine(to: annotation.points.last!)
                context.strokePath()
            }
            
        case .arrow:
            if annotation.points.count >= 2 {
                let start = annotation.points.first!
                let end = annotation.points.last!
                context.move(to: start)
                context.addLine(to: end)
                context.strokePath()
                
                // Filled arrow head
                let angle = atan2(end.y - start.y, end.x - start.x)
                let headLength: CGFloat = max(15, annotation.lineWidth * 4)
                let headAngle: CGFloat = .pi / 6
                let p1 = CGPoint(x: end.x - headLength * cos(angle - headAngle), y: end.y - headLength * sin(angle - headAngle))
                let p2 = CGPoint(x: end.x - headLength * cos(angle + headAngle), y: end.y - headLength * sin(angle + headAngle))
                context.move(to: p1)
                context.addLine(to: end)
                context.addLine(to: p2)
                context.closePath()
                context.fillPath()
            }
            
        case .line:
            if annotation.points.count >= 2 {
                let start = annotation.points.first!
                let end = annotation.points.last!
                context.move(to: start)
                context.addLine(to: end)
                context.strokePath()
            }
            
        case .rectangle:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                if annotation.isFilled {
                    context.setFillColor(NSColor(annotation.color).withAlphaComponent(0.3).cgColor)
                    context.fill(rect)
                }
                context.stroke(rect)
            }
            
        case .ellipse:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                if annotation.isFilled {
                    context.setFillColor(NSColor(annotation.color).withAlphaComponent(0.3).cgColor)
                    context.fillEllipse(in: rect)
                }
                context.strokeEllipse(in: rect)
            }
            
        case .text:
            if let pos = annotation.points.first {
                let fontSize = max(14, annotation.lineWidth * 4)
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: fontSize, weight: .medium),
                    .foregroundColor: NSColor(annotation.color)
                ]
                annotation.text.draw(at: pos, withAttributes: attrs)
            }
            
        case .stepCounter:
            if let pos = annotation.points.first {
                let r: CGFloat = max(14, annotation.lineWidth * 3)
                let size = r * 2
                let rect = CGRect(x: pos.x - r, y: pos.y - r, width: size, height: size)
                context.fillEllipse(in: rect)
                
                // White outline
                context.setStrokeColor(NSColor.white.withAlphaComponent(0.8).cgColor)
                context.setLineWidth(2)
                context.strokeEllipse(in: rect)
                
                let numStr = "\(annotation.stepNumber)"
                let attrs: [NSAttributedString.Key: Any] = [
                    .font: NSFont.systemFont(ofSize: r * 1.1, weight: .bold),
                    .foregroundColor: NSColor.white
                ]
                let textSize = (numStr as NSString).size(withAttributes: attrs)
                let textPos = CGPoint(x: pos.x - textSize.width/2, y: pos.y - textSize.height/2)
                numStr.draw(at: textPos, withAttributes: attrs)
            }
            
        case .blur:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                context.setFillColor(NSColor.gray.withAlphaComponent(0.5).cgColor)
                context.fill(rect)
            }
            
        case .spotlight:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let spotRect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                let fullRect = CGRect(origin: .zero, size: imageSize)
                
                context.saveGState()
                context.addRect(fullRect)
                context.addRect(spotRect)
                context.clip(using: .evenOdd)
                context.setFillColor(NSColor.black.withAlphaComponent(0.55).cgColor)
                context.fill(fullRect)
                context.restoreGState()
                
                context.setStrokeColor(NSColor(annotation.color).cgColor)
                context.setLineWidth(2.5)
                context.stroke(spotRect)
            }
            
        case .eraser:
            break
        }
    }
}

// MARK: - Supporting Models

struct ScreenshotItem: Identifiable {
    let id = UUID()
    let image: NSImage
    let timestamp: Date
    let orientation: String
    let screenSize: CGSize
    
    // Pre-computed strings (avoid re-formatting each render)
    let formattedTime: String
    let formattedDateTime: String
    
    // Static DateFormatters — shared across all instances
    private static let timeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm:ss"
        return f
    }()
    
    private static let dateTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, HH:mm:ss"
        return f
    }()
    
    init(image: NSImage, timestamp: Date, orientation: String, screenSize: CGSize) {
        self.image = image
        self.timestamp = timestamp
        self.orientation = orientation
        self.screenSize = screenSize
        self.formattedTime = Self.timeFormatter.string(from: timestamp)
        self.formattedDateTime = Self.dateTimeFormatter.string(from: timestamp)
    }
    
    var resolutionText: String { "\(Int(screenSize.width))×\(Int(screenSize.height))" }
    
    var fileSizeEstimate: String {
        // Rough estimate based on screen size (avoids expensive tiffRepresentation)
        let estimatedBytes = Int(screenSize.width * screenSize.height * 4 * 0.15) // ~15% of raw RGBA
        let kb = Double(estimatedBytes) / 1024
        return kb > 1024 ? String(format: "%.1f MB", kb / 1024) : String(format: "%.0f KB", kb)
    }
}

enum GalleryViewMode: String, CaseIterable {
    case grid = "Grid"
    case list = "List"
    var icon: String { self == .grid ? "square.grid.2x2" : "list.bullet" }
}

enum GallerySortOrder: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let tool: AnnotationTool
    var points: [CGPoint]
    let color: Color
    let lineWidth: CGFloat
    var text: String = ""
    var stepNumber: Int = 0
    var isFilled: Bool = false
}

enum AnnotationTool: String, CaseIterable {
    case pen = "Pen"
    case marker = "Marker"
    case arrow = "Arrow"
    case line = "Line"
    case rectangle = "Rectangle"
    case ellipse = "Ellipse"
    case text = "Text"
    case stepCounter = "Step Counter"
    case blur = "Blur"
    case highlight = "Highlight"
    case spotlight = "Spotlight"
    case eraser = "Eraser"
    
    var icon: String {
        switch self {
        case .pen: return "pencil.tip"
        case .marker: return "paintbrush.pointed.fill"
        case .arrow: return "arrow.up.right"
        case .line: return "line.diagonal"
        case .rectangle: return "rectangle"
        case .ellipse: return "circle"
        case .text: return "textformat"
        case .stepCounter: return "number.circle"
        case .blur: return "checkerboard.rectangle"
        case .highlight: return "highlighter"
        case .spotlight: return "flashlight.on.fill"
        case .eraser: return "eraser"
        }
    }
    
    /// Short display name for toolbar button labels
    var shortName: String {
        switch self {
        case .pen: return "Pen"
        case .marker: return "Marker"
        case .arrow: return "Arrow"
        case .line: return "Line"
        case .rectangle: return "Rect"
        case .ellipse: return "Ellipse"
        case .text: return "Text"
        case .stepCounter: return "Step"
        case .blur: return "Blur"
        case .highlight: return "Highlight"
        case .spotlight: return "Spot"
        case .eraser: return "Erase"
        }
    }
    
    /// Keyboard shortcut hint for tooltip
    var shortcutHint: String {
        switch self {
        case .pen: return "P"
        case .marker: return "M"
        case .arrow: return "A"
        case .line: return "L"
        case .rectangle: return "R"
        case .ellipse: return "O"
        case .text: return "T"
        case .stepCounter: return "N"
        case .blur: return "B"
        case .highlight: return "H"
        case .spotlight: return "S"
        case .eraser: return "E"
        }
    }
    
    var group: ToolGroup {
        switch self {
        case .pen, .marker, .highlight: return .draw
        case .arrow, .line, .rectangle, .ellipse: return .shape
        case .text, .stepCounter, .blur, .spotlight: return .annotate
        case .eraser: return .edit
        }
    }
    
    enum ToolGroup: String, CaseIterable {
        case draw = "Draw"
        case shape = "Shape"
        case annotate = "Annotate"
        case edit = "Edit"
    }
}
