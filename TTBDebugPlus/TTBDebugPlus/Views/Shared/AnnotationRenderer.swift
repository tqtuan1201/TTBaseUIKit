//
//  AnnotationRenderer.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Shared annotation rendering utilities — eliminates duplicate code across
//  DeviceView, AnnotationEditorView, and ScreenCaptureViewModel
//

import SwiftUI

// MARK: - Path Smoothing (Shared)
enum PathSmoothing {
    /// Creates a Bezier-smoothed Path from freehand points.
    /// Used by all annotation renderers (Canvas + CGContext).
    static func smoothedPath(from points: [CGPoint]) -> Path {
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
        if let last = points.last {
            path.addLine(to: last)
        }
        
        return path
    }
    
    /// Applies Bezier smoothing to a CGContext path (used in image export).
    static func addSmoothedPath(to context: CGContext, from points: [CGPoint]) {
        guard points.count >= 2 else { return }
        
        context.move(to: points[0])
        
        if points.count == 2 {
            context.addLine(to: points[1])
            return
        }
        
        for i in 1..<points.count {
            let prev = points[i - 1]
            let curr = points[i]
            let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
            context.addQuadCurve(to: mid, control: prev)
        }
        context.addLine(to: points[points.count - 1])
    }
}

// MARK: - Arrow Geometry
enum ArrowGeometry {
    struct ArrowHead {
        let p1: CGPoint
        let p2: CGPoint
        let tip: CGPoint
    }
    
    /// Compute arrow head points for a line from `start` to `end`
    static func arrowHead(start: CGPoint, end: CGPoint, lineWidth: CGFloat, headLengthMultiplier: CGFloat = 4.0) -> ArrowHead {
        let angle = atan2(end.y - start.y, end.x - start.x)
        let headLen: CGFloat = max(12, lineWidth * headLengthMultiplier)
        let headAngle: CGFloat = .pi / 6
        
        let p1 = CGPoint(
            x: end.x - headLen * cos(angle - headAngle),
            y: end.y - headLen * sin(angle - headAngle)
        )
        let p2 = CGPoint(
            x: end.x - headLen * cos(angle + headAngle),
            y: end.y - headLen * sin(angle + headAngle)
        )
        return ArrowHead(p1: p1, p2: p2, tip: end)
    }
}

// MARK: - Two-Point Rect Helper
extension AnnotationItem {
    /// Computes a normalized CGRect from the first and last annotation points.
    /// Returns nil if fewer than 2 points.
    var boundingRect: CGRect? {
        guard let s = points.first, let e = points.last, points.count >= 2 else { return nil }
        return CGRect(
            x: min(s.x, e.x), y: min(s.y, e.y),
            width: abs(e.x - s.x), height: abs(e.y - s.y)
        )
    }
}
