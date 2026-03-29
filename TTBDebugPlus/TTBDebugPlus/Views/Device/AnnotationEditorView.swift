//
//  AnnotationEditorView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-28.
//  Full-screen annotation editor — CleanShot X inspired
//
//  Architecture:
//   - Two-row toolbar: Row1 = tools + actions, Row2 = color/size/zoom
//   - DragGesture on transparent overlay INSIDE the zoom/pan transform
//     so gesture coords match Canvas coords exactly (no conversion needed)
//   - MagnificationGesture + scroll-wheel on outer container for zoom
//   - Option+drag for panning
//

import SwiftUI

struct AnnotationEditorView: View {
    let baseImage: NSImage
    @Binding var annotations: [AnnotationItem]
    
    var onDone: () -> Void
    var onCancel: () -> Void
    
    @State private var selectedTool: AnnotationTool = .arrow
    @State private var selectedColor: Color = .red
    @State private var lineWidth: CGFloat = 3.0
    @State private var currentDragPoints: [CGPoint] = []
    @State private var textInput: String = ""
    @State private var showTextInput: Bool = false
    @State private var textPosition: CGPoint = .zero
    @State private var stepCounter: Int = 0
    @State private var zoomScale: CGFloat = 1.0
    @State private var accumulatedZoom: CGFloat = 1.0
    @State private var panOffset: CGSize = .zero
    @State private var lastPanOffset: CGSize = .zero
    @State private var fillShape: Bool = false
    
    // Unlimited undo/redo
    @State private var redoStack: [AnnotationItem] = []
    
    let colorPalette: [Color] = [.red, .orange, .yellow, .green, .blue, .purple, .white, .black]
    
    var body: some View {
        VStack(spacing: 0) {
            // Row 1: Tools + Close/Done
            toolRow
            
            Divider().background(Color.ttBorder.opacity(0.5))
            
            // Row 2: Color, Size, Zoom
            propertyRow
            
            Divider().background(Color.ttBorder)
            
            // Canvas area
            canvasArea
            
            Divider().background(Color.ttBorder)
            
            // Status bar
            bottomStatusBar
        }
        .background(Color.ttBackground)
        // Text input overlay
        .overlay {
            if showTextInput {
                textInputOverlay
            }
        }
        .onAppear {
            stepCounter = annotations.filter { $0.tool == .stepCounter }.count
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Row 1: Tool Row
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var toolRow: some View {
        HStack(spacing: 6) {
            // Close button
            Button(action: onCancel) {
                Image(systemName: "xmark")
                    .font(TTFont.labelMedium)
                    .foregroundColor(.ttTextSecondary)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.ttSurface)
                            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.ttBorder.opacity(0.5), lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
            .help("Close (Esc)")
            .keyboardShortcut(.escape, modifiers: [])
            
            Divider().frame(height: 24).padding(.horizontal, 2)
            
            // All tools — icon only, compact 30×30
            toolButton(.pen)
            toolButton(.marker)
            toolButton(.highlight)
            
            Divider().frame(height: 24).padding(.horizontal, 2)
            
            toolButton(.arrow)
            toolButton(.line)
            toolButton(.rectangle)
            toolButton(.ellipse)
            
            // Fill toggle (only shown for rect/ellipse)
            if selectedTool == .rectangle || selectedTool == .ellipse {
                Button(action: { fillShape.toggle() }) {
                    Image(systemName: fillShape ? "square.fill" : "square")
                        .font(.ttIcon(TTIcon.md))
                        .foregroundColor(fillShape ? .ttPrimary : .ttTextTertiary)
                        .frame(width: 26, height: 26)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(fillShape ? Color.ttPrimary.opacity(0.15) : Color.clear)
                        )
                }
                .buttonStyle(.plain)
                .help("Fill shape")
            }
            
            Divider().frame(height: 24).padding(.horizontal, 2)
            
            toolButton(.text)
            toolButton(.stepCounter)
            toolButton(.blur)
            toolButton(.spotlight)
            
            Divider().frame(height: 24).padding(.horizontal, 2)
            
            toolButton(.eraser)
            
            Spacer()
            
            // Undo/Redo/Clear
            HStack(spacing: 3) {
                Button(action: localUndo) {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.ttIcon(TTIcon.lg))
                }
                .buttonStyle(.ttGhost)
                .disabled(annotations.isEmpty)
                .keyboardShortcut("z", modifiers: .command)
                
                Button(action: localRedo) {
                    Image(systemName: "arrow.uturn.forward")
                        .font(.ttIcon(TTIcon.lg))
                }
                .buttonStyle(.ttGhost)
                .disabled(redoStack.isEmpty)
                .keyboardShortcut("z", modifiers: [.command, .shift])
                
                Button(action: {
                    annotations.removeAll()
                    redoStack.removeAll()
                    stepCounter = 0
                }) {
                    Image(systemName: "trash")
                        .font(.ttIcon(TTIcon.md))
                }
                .buttonStyle(.ttGhost)
                .disabled(annotations.isEmpty)
            }
            
            Divider().frame(height: 24).padding(.horizontal, 2)
            
            // Done button
            Button(action: onDone) {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                        .font(TTFont.badge)
                    Text("Done")
                        .font(TTFont.labelMedium)
                }
            }
            .buttonStyle(.ttPrimaryCompact)
            .keyboardShortcut(.return, modifiers: .command)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.ttSurface.opacity(0.95))
    }
    
    // MARK: - Single Tool Button (icon only, 30×30)
    private func toolButton(_ tool: AnnotationTool) -> some View {
        let isSelected = selectedTool == tool
        return Button(action: { selectedTool = tool }) {
            Image(systemName: tool.icon)
                .font(TTFont.bodyMedium)
                .foregroundColor(isSelected ? .white : .ttTextSecondary)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(isSelected ? Color.ttPrimary : Color.clear)
                )
        }
        .buttonStyle(.plain)
        .help("\(tool.rawValue) (\(tool.shortcutHint))")
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Row 2: Properties
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var propertyRow: some View {
        HStack(spacing: 8) {
            // Color palette
            HStack(spacing: 4) {
                ForEach(colorPalette, id: \.self) { color in
                    Button(action: { selectedColor = color }) {
                        Circle()
                            .fill(color)
                            .frame(width: 18, height: 18)
                            .overlay(
                                Circle().stroke(Color.white, lineWidth: selectedColor == color ? 2 : 0)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.ttPrimary, lineWidth: selectedColor == color ? 1.5 : 0)
                                    .padding(-2)
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
                    .frame(width: 22, height: 22)
            }
            
            Divider().frame(height: 20).padding(.horizontal, 4)
            
            // Line width
            HStack(spacing: 6) {
                Text("Size")
                    .font(TTFont.labelSmall)
                    .foregroundColor(.ttTextTertiary)
                
                ForEach([2, 4, 8], id: \.self) { w in
                    Button(action: { lineWidth = CGFloat(w) }) {
                        Circle()
                            .fill(Int(lineWidth) == w ? selectedColor : Color.ttTextTertiary)
                            .frame(width: CGFloat(max(w + 2, 6)), height: CGFloat(max(w + 2, 6)))
                            .frame(width: 22, height: 22)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Int(lineWidth) == w ? selectedColor.opacity(0.1) : Color.clear)
                            )
                    }
                    .buttonStyle(.plain)
                }
                
                Slider(value: $lineWidth, in: 1...12, step: 0.5)
                    .frame(width: 60)
                
                Text("\(lineWidth, specifier: "%.0f")px")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
                    .frame(width: 28, alignment: .leading)
            }
            
            Spacer()
            
            // Zoom controls
            HStack(spacing: 4) {
                Button(action: zoomToFit) {
                    Text("Fit").font(TTFont.labelSmall)
                }
                .buttonStyle(.ttGhost)
                .keyboardShortcut("0", modifiers: .command)
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        zoomScale = min(zoomScale * 1.5, 10.0)
                        accumulatedZoom = zoomScale
                    }
                }) {
                    Image(systemName: "plus.magnifyingglass").font(.ttIcon(TTIcon.md))
                }
                .buttonStyle(.ttGhost)
                .keyboardShortcut("=", modifiers: .command)
                
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        zoomScale = max(zoomScale / 1.5, 0.1)
                        accumulatedZoom = zoomScale
                    }
                }) {
                    Image(systemName: "minus.magnifyingglass").font(.ttIcon(TTIcon.md))
                }
                .buttonStyle(.ttGhost)
                .keyboardShortcut("-", modifiers: .command)
                
                Text("\(Int(zoomScale * 100))%")
                    .font(TTFont.codeSmall)
                    .foregroundColor(.ttTextTertiary)
                    .frame(width: 36)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(Color.ttSurface.opacity(0.7))
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Canvas Area
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    //
    // Architecture:  The DragGesture for drawing is placed on an overlay
    // that lives INSIDE the scaleEffect/offset transforms. This means
    // the gesture coordinates are already in the Canvas's local coordinate
    // space — NO conversion math needed.
    //
    // Zoom and pan gestures are on the outer container so they don't
    // interfere with drawing.
    //
    private var canvasArea: some View {
        GeometryReader { geo in
            ZStack {
                // Dark canvas background
                Color(nsColor: NSColor(calibratedWhite: 0.08, alpha: 1.0))
                
                // Zoomable + pannable content
                imageAndCanvas(in: geo.size)
                    .scaleEffect(zoomScale, anchor: .center)
                    .offset(x: panOffset.width, y: panOffset.height)
            }
            .clipped()
            // Pinch-to-zoom on container
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        zoomScale = max(0.1, min(10.0, accumulatedZoom * value))
                    }
                    .onEnded { _ in
                        accumulatedZoom = zoomScale
                    }
            )
            // Scroll-wheel zoom
            .onScrollGesture { delta in
                let newZoom = zoomScale * (1.0 + delta * 0.02)
                withAnimation(.easeOut(duration: 0.1)) {
                    zoomScale = max(0.1, min(10.0, newZoom))
                    accumulatedZoom = zoomScale
                }
            }
        }
    }
    
    /// Image + Canvas + drawing gesture overlay — all in the same coordinate space
    private func imageAndCanvas(in containerSize: CGSize) -> some View {
        let imgSize = baseImage.size
        let availW = max(containerSize.width - 40, 100)
        let availH = max(containerSize.height - 40, 100)
        let fitScale = min(availW / imgSize.width, availH / imgSize.height)
        let fitW = imgSize.width * fitScale
        let fitH = imgSize.height * fitScale
        
        return ZStack {
            // Base image
            Image(nsImage: baseImage)
                .resizable()
                .frame(width: fitW, height: fitH)
            
            // Annotations canvas — exact same frame as image
            Canvas { context, size in
                for annotation in annotations {
                    renderAnnotation(annotation, in: &context, size: size)
                }
                // Live drag preview
                if !currentDragPoints.isEmpty {
                    var current = AnnotationItem(
                        tool: selectedTool, points: currentDragPoints,
                        color: selectedColor, lineWidth: lineWidth
                    )
                    if selectedTool == .stepCounter {
                        current.stepNumber = stepCounter + 1
                    }
                    current.isFilled = fillShape
                    renderAnnotation(current, in: &context, size: size)
                }
            }
            .frame(width: fitW, height: fitH)
            
            // Transparent drawing gesture overlay — same frame
            // Gesture coords are in THIS view's local space = Canvas space
            Color.clear
                .frame(width: fitW, height: fitH)
                .contentShape(Rectangle())
                .gesture(drawGesture)
        }
        // Option+Drag panning (on the outer padding area too)
        .padding(20)
        .contentShape(Rectangle())
        .gesture(panGesture)
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Gestures
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    
    /// Drawing gesture — coordinates are in Canvas local space (no conversion needed)
    private var drawGesture: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { value in
                // If Option key is held, ignore drawing (panning takes over)
                if NSEvent.modifierFlags.contains(.option) { return }
                
                switch selectedTool {
                case .text:
                    textPosition = value.location
                case .stepCounter:
                    if currentDragPoints.isEmpty {
                        currentDragPoints = [value.location]
                    }
                case .blur, .spotlight, .rectangle, .ellipse, .arrow, .line:
                    currentDragPoints = [value.startLocation, value.location]
                case .eraser:
                    eraseAnnotationAt(value.location)
                default:
                    // pen, marker, highlight — append points for freehand
                    currentDragPoints.append(value.location)
                }
            }
            .onEnded { _ in
                if NSEvent.modifierFlags.contains(.option) { return }
                handleDragEnd()
            }
    }
    
    /// Pan gesture — Option+drag moves the canvas
    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .modifiers(.option)
            .onChanged { value in
                panOffset = CGSize(
                    width: lastPanOffset.width + value.translation.width,
                    height: lastPanOffset.height + value.translation.height
                )
            }
            .onEnded { _ in
                lastPanOffset = panOffset
            }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Drag End Handling
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func handleDragEnd() {
        switch selectedTool {
        case .text:
            showTextInput = true
        case .stepCounter:
            if let pos = currentDragPoints.first {
                stepCounter += 1
                var annotation = AnnotationItem(
                    tool: .stepCounter, points: [pos],
                    color: selectedColor, lineWidth: lineWidth
                )
                annotation.stepNumber = stepCounter
                annotations.append(annotation)
                redoStack.removeAll()
            }
        case .eraser:
            break
        default:
            if currentDragPoints.count >= 2 {
                var annotation = AnnotationItem(
                    tool: selectedTool, points: currentDragPoints,
                    color: selectedColor, lineWidth: lineWidth
                )
                annotation.isFilled = fillShape
                annotations.append(annotation)
                redoStack.removeAll()
            }
        }
        currentDragPoints.removeAll()
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Eraser
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func eraseAnnotationAt(_ point: CGPoint) {
        let hitRadius: CGFloat = 15
        if let index = annotations.lastIndex(where: { annotation in
            annotation.points.contains { p in
                hypot(p.x - point.x, p.y - point.y) < hitRadius
            }
        }) {
            let removed = annotations.remove(at: index)
            redoStack.append(removed)
            if removed.tool == .stepCounter { stepCounter = max(0, stepCounter - 1) }
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Undo/Redo
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func localUndo() {
        guard let last = annotations.popLast() else { return }
        redoStack.append(last)
        if last.tool == .stepCounter { stepCounter = max(0, stepCounter - 1) }
    }
    
    private func localRedo() {
        guard let last = redoStack.popLast() else { return }
        annotations.append(last)
        if last.tool == .stepCounter { stepCounter += 1 }
    }
    
    private func zoomToFit() {
        withAnimation(.easeOut(duration: 0.2)) {
            zoomScale = 1.0
            accumulatedZoom = 1.0
            panOffset = .zero
            lastPanOffset = .zero
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Text Input Overlay
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var textInputOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    showTextInput = false
                    textInput = ""
                }
            
            VStack(spacing: 16) {
                HStack {
                    Image(systemName: "textformat")
                        .font(.ttIcon(TTIcon.xl))
                        .foregroundColor(.ttPrimary)
                    Text("Add Text Annotation")
                        .font(TTFont.heading3)
                        .foregroundColor(.ttTextPrimary)
                    Spacer()
                    Button(action: {
                        showTextInput = false
                        textInput = ""
                    }) {
                        Image(systemName: "xmark")
                            .font(TTFont.labelMedium)
                            .foregroundColor(.ttTextTertiary)
                            .frame(width: 24, height: 24)
                            .background(Circle().fill(Color.ttSurface))
                    }
                    .buttonStyle(.plain)
                }
                
                AnnotationTextField(text: $textInput, placeholder: "Type your annotation text...", onCommit: commitText)
                    .frame(height: 36)
                
                HStack {
                    HStack(spacing: 6) {
                        Circle().fill(selectedColor).frame(width: 14, height: 14)
                        Text("Color").font(TTFont.labelSmall).foregroundColor(.ttTextTertiary)
                    }
                    
                    Spacer()
                    
                    Button("Cancel") {
                        showTextInput = false
                        textInput = ""
                    }
                    .buttonStyle(.ttSecondaryCompact)
                    
                    Button("Add Text") { commitText() }
                        .buttonStyle(.ttPrimaryCompact)
                        .disabled(textInput.isEmpty)
                }
            }
            .padding(20)
            .frame(width: 380)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.ttSurface)
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.ttBorder, lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 20, y: 8)
            )
        }
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
        .animation(.easeOut(duration: 0.15), value: showTextInput)
    }
    
    private func commitText() {
        if !textInput.isEmpty {
            var annotation = AnnotationItem(
                tool: .text, points: [textPosition],
                color: selectedColor, lineWidth: lineWidth
            )
            annotation.text = textInput
            annotations.append(annotation)
            redoStack.removeAll()
            textInput = ""
        }
        showTextInput = false
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Bottom Status Bar
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private var bottomStatusBar: some View {
        HStack {
            Image(systemName: selectedTool.icon)
                .font(.ttIcon(TTIcon.md))
                .foregroundColor(.ttPrimary)
            Text(statusText)
                .font(TTFont.labelSmall)
                .foregroundColor(.ttTextTertiary)
            
            Spacer()
            
            Text("⌥+Drag: Pan  •  ⌘+/–: Zoom")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextMuted)
            
            Text("•").foregroundColor(.ttTextTertiary)
            
            Text("\(annotations.count) annotation\(annotations.count == 1 ? "" : "s")")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            Text("•").foregroundColor(.ttTextTertiary)
            
            Text("\(Int(zoomScale * 100))%")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
            
            Text("•").foregroundColor(.ttTextTertiary)
            
            Text("\(Int(baseImage.size.width))×\(Int(baseImage.size.height))")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color.ttSurface.opacity(0.9))
    }
    
    private var statusText: String {
        switch selectedTool {
        case .pen: return "Pen — draw smooth freehand strokes"
        case .marker: return "Marker — thick semi-transparent strokes"
        case .arrow: return "Drag to draw an arrow"
        case .line: return "Drag to draw a straight line"
        case .rectangle: return fillShape ? "Drag to draw a filled rectangle" : "Drag to draw a rectangle"
        case .ellipse: return fillShape ? "Drag to draw a filled ellipse" : "Drag to draw an ellipse"
        case .text: return "Click to place text annotation"
        case .stepCounter: return "Click to place step \(stepCounter + 1)"
        case .blur: return "Drag to blur a region"
        case .highlight: return "Draw to highlight"
        case .spotlight: return "Drag to spotlight a region"
        case .eraser: return "Click on annotation to erase"
        }
    }
    
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // MARK: - Render Annotation (SwiftUI Canvas)
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    private func renderAnnotation(_ annotation: AnnotationItem, in context: inout GraphicsContext, size: CGSize) {
        let shading: GraphicsContext.Shading = .color(annotation.color)
        
        switch annotation.tool {
        case .pen:
            if annotation.points.count >= 2 {
                let path = smoothedPath(from: annotation.points)
                context.stroke(path, with: shading, style: StrokeStyle(lineWidth: annotation.lineWidth, lineCap: .round, lineJoin: .round))
            }
            
        case .marker:
            if annotation.points.count >= 2 {
                let path = smoothedPath(from: annotation.points)
                context.stroke(path, with: .color(annotation.color.opacity(0.4)),
                              style: StrokeStyle(lineWidth: annotation.lineWidth * 5, lineCap: .round, lineJoin: .round))
            }
            
        case .highlight:
            if annotation.points.count >= 2 {
                let path = smoothedPath(from: annotation.points)
                context.stroke(path, with: .color(annotation.color.opacity(0.35)),
                              style: StrokeStyle(lineWidth: annotation.lineWidth * 4, lineCap: .round, lineJoin: .round))
            }
            
        case .arrow:
            if annotation.points.count >= 2 {
                let start = annotation.points.first!, end = annotation.points.last!
                var path = Path()
                path.move(to: start)
                path.addLine(to: end)
                context.stroke(path, with: shading, style: StrokeStyle(lineWidth: annotation.lineWidth, lineCap: .round))
                // Arrow head
                let angle = atan2(end.y - start.y, end.x - start.x)
                let headLen: CGFloat = max(12, annotation.lineWidth * 4)
                let headAngle: CGFloat = .pi / 6
                var arrow = Path()
                let p1 = CGPoint(x: end.x - headLen * cos(angle - headAngle), y: end.y - headLen * sin(angle - headAngle))
                let p2 = CGPoint(x: end.x - headLen * cos(angle + headAngle), y: end.y - headLen * sin(angle + headAngle))
                arrow.move(to: p1)
                arrow.addLine(to: end)
                arrow.addLine(to: p2)
                arrow.closeSubpath()
                context.fill(arrow, with: shading)
            }
            
        case .line:
            if annotation.points.count >= 2 {
                let start = annotation.points.first!, end = annotation.points.last!
                var path = Path()
                path.move(to: start)
                path.addLine(to: end)
                context.stroke(path, with: shading, style: StrokeStyle(lineWidth: annotation.lineWidth, lineCap: .round))
            }
            
        case .rectangle:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                let path = Path(roundedRect: rect, cornerRadius: 3)
                if annotation.isFilled {
                    context.fill(path, with: .color(annotation.color.opacity(0.3)))
                }
                context.stroke(path, with: shading, lineWidth: annotation.lineWidth)
            }
            
        case .ellipse:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                let path = Path(ellipseIn: rect)
                if annotation.isFilled {
                    context.fill(path, with: .color(annotation.color.opacity(0.3)))
                }
                context.stroke(path, with: shading, lineWidth: annotation.lineWidth)
            }
            
        case .text:
            if let pos = annotation.points.first {
                let text = Text(annotation.text)
                    .font(.system(size: max(14, annotation.lineWidth * 4), weight: .medium))
                    .foregroundColor(annotation.color)
                context.draw(context.resolve(text), at: pos, anchor: .topLeading)
            }
            
        case .stepCounter:
            if let pos = annotation.points.first {
                let r: CGFloat = max(14, annotation.lineWidth * 3)
                let circleRect = CGRect(x: pos.x - r, y: pos.y - r, width: r * 2, height: r * 2)
                context.fill(Path(ellipseIn: circleRect), with: shading)
                context.stroke(Path(ellipseIn: circleRect), with: .color(.white.opacity(0.8)), lineWidth: 2)
                let numText = Text("\(annotation.stepNumber)")
                    .font(.system(size: r * 1.1, weight: .bold))
                    .foregroundColor(.ttTextPrimary)
                context.draw(context.resolve(numText), at: pos, anchor: .center)
            }
            
        case .blur:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let rect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                let cellSize: CGFloat = 10
                for row in stride(from: rect.minY, to: rect.maxY, by: cellSize) {
                    for col in stride(from: rect.minX, to: rect.maxX, by: cellSize) {
                        let cellRect = CGRect(x: col, y: row, width: cellSize, height: cellSize).intersection(rect)
                        let hash = Int(abs(sin(col * 12.9898 + row * 78.233) * 43758.5453).truncatingRemainder(dividingBy: 1.0) * 100)
                        let gray = Double(hash) / 100.0 * 0.4 + 0.3
                        context.fill(Path(cellRect), with: .color(.gray.opacity(gray)))
                    }
                }
                context.stroke(Path(roundedRect: rect, cornerRadius: 2), with: .color(.gray.opacity(0.5)), lineWidth: 1)
            }
            
        case .spotlight:
            if annotation.points.count >= 2 {
                let s = annotation.points.first!, e = annotation.points.last!
                let spotRect = CGRect(x: min(s.x, e.x), y: min(s.y, e.y), width: abs(e.x - s.x), height: abs(e.y - s.y))
                let fullRect = CGRect(origin: .zero, size: size)
                var maskPath = Path(fullRect)
                maskPath.addRoundedRect(in: spotRect, cornerSize: CGSize(width: 6, height: 6))
                context.fill(maskPath, with: .color(.black.opacity(0.55)), style: FillStyle(eoFill: true))
                context.stroke(Path(roundedRect: spotRect, cornerRadius: 6), with: .color(annotation.color), lineWidth: 2.5)
            }
            
        case .eraser:
            break
        }
    }
    
    // MARK: - Path Smoothing
    private func smoothedPath(from points: [CGPoint]) -> Path {
        var path = Path()
        guard points.count >= 2 else { return path }
        
        path.move(to: points[0])
        
        if points.count == 2 {
            path.addLine(to: points[1])
            return path
        }
        
        for i in 1..<points.count {
            let prev = points[i - 1]
            let curr = points[i]
            let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
            path.addQuadCurve(to: mid, control: prev)
        }
        path.addLine(to: points.last!)
        
        return path
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - NSTextField-backed TextField
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
struct AnnotationTextField: NSViewRepresentable {
    @Binding var text: String
    var placeholder: String = ""
    var onCommit: () -> Void = {}
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.stringValue = text
        textField.delegate = context.coordinator
        textField.font = NSFont.systemFont(ofSize: 14)
        textField.isBordered = true
        textField.bezelStyle = .roundedBezel
        textField.backgroundColor = NSColor(Color.ttBackground)
        textField.textColor = NSColor(Color.ttTextPrimary)
        textField.focusRingType = .none
        DispatchQueue.main.async {
            textField.window?.makeFirstResponder(textField)
        }
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        if nsView.stringValue != text {
            nsView.stringValue = text
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    class Coordinator: NSObject, NSTextFieldDelegate {
        let parent: AnnotationTextField
        init(_ parent: AnnotationTextField) { self.parent = parent }
        
        func controlTextDidChange(_ obj: Notification) {
            if let tf = obj.object as? NSTextField { parent.text = tf.stringValue }
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if commandSelector == #selector(NSResponder.insertNewline(_:)) {
                parent.onCommit()
                return true
            }
            return false
        }
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Scroll Wheel Gesture (macOS)
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
struct ScrollGestureModifier: ViewModifier {
    let action: (CGFloat) -> Void
    func body(content: Content) -> some View {
        content.background(ScrollGestureView(action: action))
    }
}

struct ScrollGestureView: NSViewRepresentable {
    let action: (CGFloat) -> Void
    func makeNSView(context: Context) -> ScrollGestureNSView {
        let view = ScrollGestureNSView()
        view.action = action
        return view
    }
    func updateNSView(_ nsView: ScrollGestureNSView, context: Context) {
        nsView.action = action
    }
}

class ScrollGestureNSView: NSView {
    var action: ((CGFloat) -> Void)?
    override func scrollWheel(with event: NSEvent) {
        let delta = event.scrollingDeltaY
        if abs(delta) > 0.1 { action?(delta) }
    }
}

extension View {
    func onScrollGesture(action: @escaping (CGFloat) -> Void) -> some View {
        modifier(ScrollGestureModifier(action: action))
    }
}

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// MARK: - Preview
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
#Preview {
    AnnotationEditorView(
        baseImage: NSImage(systemSymbolName: "photo", accessibilityDescription: nil) ?? NSImage(),
        annotations: .constant([]),
        onDone: {},
        onCancel: {}
    )
    .frame(width: 1200, height: 900)
    .preferredColorScheme(.dark)
}
