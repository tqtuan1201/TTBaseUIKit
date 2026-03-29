//
//  JSONGraphView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Interactive graph visualization: pannable/zoomable canvas with JSON nodes & edges
//

import SwiftUI

struct JSONGraphView: View {
    let jsonString: String
    
    @State private var layout: GraphLayout = .empty
    @State private var isLoading: Bool = true
    @State private var scale: CGFloat = 1.0
    @State private var offset: CGSize = .zero
    @State private var dragOffset: CGSize = .zero
    @State private var collapsedNodeIds: Set<String> = []
    @State private var selectedNodeId: String? = nil
    @State private var hoveredNodeId: String? = nil
    
    // Zoom limits
    private let minScale: CGFloat = 0.15
    private let maxScale: CGFloat = 2.5
    
    var body: some View {
        ZStack {
            // Background
            Color.ttBackground
                .ignoresSafeArea()
            
            if isLoading {
                loadingOverlay
            } else if layout.nodes.isEmpty {
                emptyState
            } else {
                graphCanvas
            }
            
            // Toolbar overlay
            VStack {
                HStack {
                    Spacer()
                    graphToolbar
                }
                .padding(12)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: jsonString.hashValue) {
            await buildLayout()
        }
    }
    
    // MARK: - Graph Canvas
    private var graphCanvas: some View {
        GeometryReader { geometry in
            let totalOffset = CGSize(
                width: offset.width + dragOffset.width,
                height: offset.height + dragOffset.height
            )
            
            ZStack(alignment: .topLeading) {
                // Edge lines (drawn first, behind nodes)
                Canvas { context, _ in
                    drawEdges(context: context, offset: totalOffset)
                }
                .allowsHitTesting(false)
                
                // Nodes
                ForEach(visibleNodes) { node in
                    graphNodeView(node)
                        .position(
                            x: (node.position.x + node.size.width / 2) * scale + totalOffset.width,
                            y: (node.position.y + node.size.height / 2) * scale + totalOffset.height
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged { value in
                        dragOffset = value.translation
                    }
                    .onEnded { value in
                        offset.width += value.translation.width
                        offset.height += value.translation.height
                        dragOffset = .zero
                    }
            )
            .gesture(
                MagnificationGesture()
                    .onChanged { value in
                        let newScale = scale * value
                        scale = max(minScale, min(maxScale, newScale))
                    }
            )
            .onAppear {
                fitToWindow(size: geometry.size)
            }
        }
    }
    
    // MARK: - Node View
    private func graphNodeView(_ node: GraphNode) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 6) {
                // Type badge
                Text(node.valueType.badge)
                    .font(.system(size: max(8, 10 * scale), weight: .bold, design: .monospaced))
                    .foregroundColor(.white)
                
                Text(node.label)
                    .font(.system(size: max(8, 11 * scale), weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Spacer()
                
                if !node.childIds.isEmpty {
                    Image(systemName: collapsedNodeIds.contains(node.id) ? "chevron.right" : "chevron.down")
                        .font(.system(size: max(6, 8 * scale), weight: .bold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(node.headerColor.opacity(0.8))
            
            // Entries
            if !node.entries.isEmpty {
                VStack(alignment: .leading, spacing: 0) {
                    let visibleEntries = Array(node.entries.prefix(8))
                    ForEach(Array(visibleEntries.enumerated()), id: \.offset) { _, entry in
                        HStack(spacing: 4) {
                            Text(entry.key)
                                .foregroundColor(.ttJsonKey)
                            Text(":")
                                .foregroundColor(.ttJsonBrace)
                            Text(entry.value)
                                .foregroundColor(entry.type.badgeColor)
                                .lineLimit(1)
                        }
                        .font(.system(size: max(7, 10 * scale), design: .monospaced))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                    }
                    
                    if node.entries.count > 8 {
                        Text("... +\(node.entries.count - 8) more")
                            .font(.system(size: max(7, 9 * scale), design: .monospaced))
                            .foregroundColor(.ttTextTertiary)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .frame(width: node.size.width * scale)
        .background(
            RoundedRectangle(cornerRadius: 8 * scale)
                .fill(Color.ttSurface)
                .shadow(
                    color: selectedNodeId == node.id ? node.headerColor.opacity(0.3) : Color.black.opacity(0.2),
                    radius: selectedNodeId == node.id ? 8 : 3,
                    x: 0, y: 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8 * scale)
                .stroke(
                    selectedNodeId == node.id ? node.headerColor :
                    (hoveredNodeId == node.id ? Color.ttPrimary.opacity(0.5) : Color.ttBorder.opacity(0.3)),
                    lineWidth: selectedNodeId == node.id ? 2 : 1
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 8 * scale))
        .onHover { isHovered in
            hoveredNodeId = isHovered ? node.id : nil
        }
        .onTapGesture {
            selectedNodeId = node.id
            if !node.childIds.isEmpty {
                if collapsedNodeIds.contains(node.id) {
                    collapsedNodeIds.remove(node.id)
                } else {
                    collapsedNodeIds.insert(node.id)
                }
            }
        }
    }
    
    // MARK: - Edge Drawing
    private func drawEdges(context: GraphicsContext, offset: CGSize) {
        for edge in layout.edges {
            guard let fromNode = layout.nodes.first(where: { $0.id == edge.fromId }),
                  let toNode = layout.nodes.first(where: { $0.id == edge.toId }) else { continue }
            
            // Skip edges from collapsed nodes
            if collapsedNodeIds.contains(edge.fromId) { continue }
            
            let fromPoint = CGPoint(
                x: (fromNode.position.x + fromNode.size.width / 2) * scale + offset.width,
                y: (fromNode.position.y + fromNode.size.height) * scale + offset.height
            )
            let toPoint = CGPoint(
                x: (toNode.position.x + toNode.size.width / 2) * scale + offset.width,
                y: toNode.position.y * scale + offset.height
            )
            
            var path = Path()
            path.move(to: fromPoint)
            
            // Bezier curve for smooth edges
            let controlY = (fromPoint.y + toPoint.y) / 2
            path.addCurve(
                to: toPoint,
                control1: CGPoint(x: fromPoint.x, y: controlY),
                control2: CGPoint(x: toPoint.x, y: controlY)
            )
            
            let isHighlighted = selectedNodeId == edge.fromId || selectedNodeId == edge.toId
            context.stroke(
                path,
                with: .color(isHighlighted ? Color.ttPrimary : Color.ttBorder.opacity(0.4)),
                lineWidth: isHighlighted ? 2 : 1
            )
            
            // Arrow at endpoint
            let arrowSize: CGFloat = 5 * scale
            var arrowPath = Path()
            arrowPath.move(to: CGPoint(x: toPoint.x - arrowSize, y: toPoint.y - arrowSize * 1.5))
            arrowPath.addLine(to: toPoint)
            arrowPath.addLine(to: CGPoint(x: toPoint.x + arrowSize, y: toPoint.y - arrowSize * 1.5))
            context.fill(
                arrowPath,
                with: .color(isHighlighted ? Color.ttPrimary : Color.ttBorder.opacity(0.4))
            )
        }
    }
    
    // MARK: - Visible Nodes (filtered by collapse state)
    private var visibleNodes: [GraphNode] {
        var hidden = Set<String>()
        for collapsedId in collapsedNodeIds {
            collectDescendants(collapsedId, hidden: &hidden)
        }
        return layout.nodes.filter { !hidden.contains($0.id) }
    }
    
    private func collectDescendants(_ nodeId: String, hidden: inout Set<String>) {
        guard let node = layout.nodes.first(where: { $0.id == nodeId }) else { return }
        for childId in node.childIds {
            hidden.insert(childId)
            collectDescendants(childId, hidden: &hidden)
        }
    }
    
    // MARK: - Graph Toolbar
    private var graphToolbar: some View {
        HStack(spacing: 4) {
            // Zoom controls
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { scale = max(minScale, scale * 0.8) } }) {
                Image(systemName: "minus.magnifyingglass")
                    .font(.system(size: 12))
            }
            .buttonStyle(.ttGhost)
            .help("Zoom Out")
            
            Text("\(Int(scale * 100))%")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
                .frame(width: 40)
            
            Button(action: { withAnimation(.easeInOut(duration: 0.2)) { scale = min(maxScale, scale * 1.25) } }) {
                Image(systemName: "plus.magnifyingglass")
                    .font(.system(size: 12))
            }
            .buttonStyle(.ttGhost)
            .help("Zoom In")
            
            Divider().frame(height: 14)
            
            // Fit to window
            Button(action: {
                if let window = NSApplication.shared.keyWindow {
                    let contentSize = window.contentView?.bounds.size ?? CGSize(width: 800, height: 600)
                    withAnimation(.easeInOut(duration: 0.3)) {
                        fitToWindow(size: contentSize)
                    }
                }
            }) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 12))
            }
            .buttonStyle(.ttGhost)
            .help("Fit to Window")
            
            // Reset
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    scale = 1.0
                    offset = .zero
                }
            }) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.system(size: 12))
            }
            .buttonStyle(.ttGhost)
            .help("Reset View")
            
            Divider().frame(height: 14)
            
            // Node count
            Text("\(layout.nodes.count) nodes")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.ttSurface.opacity(0.9))
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        )
    }
    
    // MARK: - Loading
    private var loadingOverlay: some View {
        VStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)
            Text("Building graph layout...")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "point.3.connected.trianglepath.dotted")
                .font(.system(size: 40))
                .foregroundColor(.ttTextTertiary)
            Text("No graph to display")
                .font(TTFont.labelMedium)
                .foregroundColor(.ttTextSecondary)
            Text("Enter valid JSON to visualize")
                .font(TTFont.codeSmall)
                .foregroundColor(.ttTextTertiary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Actions
    
    private func buildLayout() async {
        isLoading = true
        let input = jsonString
        let result = await Task.detached(priority: .userInitiated) {
            JSONGraphLayoutEngine.layout(from: input)
        }.value
        
        layout = result
        isLoading = false
        collapsedNodeIds.removeAll()
        selectedNodeId = nil
    }
    
    private func fitToWindow(size: CGSize) {
        guard layout.totalSize.width > 0, layout.totalSize.height > 0 else { return }
        
        let padding: CGFloat = 80
        let scaleX = (size.width - padding) / layout.totalSize.width
        let scaleY = (size.height - padding) / layout.totalSize.height
        let fitScale = min(scaleX, scaleY, 1.5) // Don't scale up too much
        
        scale = max(minScale, fitScale)
        offset = CGSize(
            width: (size.width - layout.totalSize.width * scale) / 2,
            height: (size.height - layout.totalSize.height * scale) / 2
        )
    }
}
