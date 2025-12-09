//
//  File.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 21/11/25.
//

import Foundation
import UIKit

/// An animated border "trail" that travels endlessly around a view's bounds,
/// inspired by Motion-Primitives Border Trail.
open class TTBaseBorderTrailView: UIView {

    // MARK: - Config
    public struct Config {
        var lineWidth: CGFloat
        var cornerRadius: CGFloat
        /// 0 < trailLength < 1 ; it's a fraction of the full perimeter
        var trailLength: CGFloat
        /// seconds per full loop
        var duration: CFTimeInterval
        /// Gradient colors of the trail
        var colors: [UIColor]
        /// Shadow/glow intensity (0 disables)
        var glowOpacity: Float

        public init(
            lineWidth: CGFloat = 2,
            cornerRadius: CGFloat = 16,
            trailLength: CGFloat = 0.12,
            duration: CFTimeInterval = 2.4,
            colors: [UIColor] = [
                UIColor.systemPurple,
                UIColor.systemBlue,
                UIColor.systemTeal
            ],
            glowOpacity: Float = 0.35
        ) {
            self.lineWidth = lineWidth
            self.cornerRadius = cornerRadius
            self.trailLength = trailLength
            self.duration = duration
            self.colors = colors
            self.glowOpacity = glowOpacity
        }
    }

    public var config: Config { didSet { rebuildLayers() } }

    // MARK: - Layers
    private let gradientLayer = CAGradientLayer()
    private let shapeMask = CAShapeLayer()
    private let outlineLayer = CAShapeLayer() // subtle static outline

    // MARK: - Init
    public init(config: TTBaseBorderTrailView.Config = TTBaseBorderTrailView.Config.init()) {
        self.config = config
        super.init(frame: .zero)
        self.isUserInteractionEnabled = false
        self.setupLayers()
    }

    required public init?(coder: NSCoder) {
        self.config = .init()
        super.init(coder: coder)
        self.isUserInteractionEnabled = false
        self.setupLayers()
    }

    // MARK: - Layout
    open override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutBorder()
    }

    // MARK: - Public
    public func start() {
        shapeMask.removeAllAnimations()
        let trail = max(0.01, min(0.95, config.trailLength))

        // We animate a moving "window" along the stroke using strokeStart/End.
        // End goes 0 -> 1, Start tracks behind End by `trail`.
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.fromValue = 0.0
        end.toValue = 1.0
        end.duration = config.duration
        end.timingFunction = CAMediaTimingFunction(name: .linear)

        let start = CABasicAnimation(keyPath: "strokeStart")
        start.fromValue = -trail
        start.toValue = 1.0 - trail
        start.duration = config.duration
        start.timingFunction = CAMediaTimingFunction(name: .linear)

        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = config.duration
        group.repeatCount = .infinity
        group.isRemovedOnCompletion = false

        shapeMask.add(group, forKey: "borderTrail")
    }

    public func stop() {
        shapeMask.removeAnimation(forKey: "borderTrail")
    }

    // MARK: - Private
    private func setupLayers() {
        // Static subtle outline under the moving trail
        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.strokeColor = UIColor.separator.withAlphaComponent(0.35).cgColor
        layer.addSublayer(outlineLayer)

        // Gradient that will be masked by the moving stroke segment
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint   = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = config.colors.map { $0.cgColor }
        gradientLayer.locations = stride(from: 0.0, to: 1.0, by: 1.0 / Double(max(2, config.colors.count - 1))).map { NSNumber(value: $0) }
        layer.addSublayer(gradientLayer)

        // Mask: only a short arc of the stroke is visible; we animate this mask
        shapeMask.fillColor = UIColor.clear.cgColor
        shapeMask.strokeColor = UIColor.black.cgColor
        shapeMask.lineCap = .round
        gradientLayer.mask = shapeMask

        // Optional glow
        layer.shadowColor = config.colors.first?.cgColor ?? UIColor.systemBlue.cgColor
        layer.shadowOpacity = config.glowOpacity
        layer.shadowRadius = 8
        layer.shadowOffset = .zero
    }

    private func layoutBorder() {
        let inset = config.lineWidth / 2
        let rect = bounds.insetBy(dx: inset, dy: inset)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: config.cornerRadius)
        let perimeter = path.cgPath

        outlineLayer.frame = bounds
        outlineLayer.path = perimeter
        outlineLayer.lineWidth = config.lineWidth

        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = config.cornerRadius

        shapeMask.frame = bounds
        shapeMask.path = perimeter
        shapeMask.lineWidth = config.lineWidth

        // keep glow in sync with size
        layer.shadowPath = perimeter
    }

    private func rebuildLayers() {
        outlineLayer.lineWidth = config.lineWidth
        layer.shadowOpacity = config.glowOpacity
        gradientLayer.colors = config.colors.map { $0.cgColor }
        setNeedsLayout()
        layoutIfNeeded()
        start() // restart with new config
    }
}
