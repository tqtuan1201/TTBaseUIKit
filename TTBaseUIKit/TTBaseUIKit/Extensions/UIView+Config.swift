//
//  UIView+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    public func done(_ completion: (() -> Void)? = nil) {
        completion?()
    }

    public func setConerRadius(with radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    public func addBorder(borderColor:UIColor = UIColor.white, borderHeight:CGFloat = 1) {
        self.layer.addBorder(edge: UIRectEdge.left, color: borderColor, thickness: borderHeight)
        self.layer.addBorder(edge: UIRectEdge.right, color: borderColor, thickness: borderHeight)
        self.layer.addBorder(edge: UIRectEdge.top, color: borderColor, thickness: borderHeight)
        self.layer.addBorder(edge: UIRectEdge.bottom, color: borderColor, thickness: borderHeight)
    }
    
    public func addBorder(withRectEdge rectEdge:UIRectEdge, borderColor:UIColor = UIColor.white, borderHeight:CGFloat = 1) {
        self.layer.sublayers?.filter({$0.name == "BORDER." + rectEdge.rawValue.description}).forEach({$0.removeFromSuperlayer()})
        self.layer.addBorder(edge: rectEdge, color: borderColor, thickness: borderHeight)
    }
    
    public func shakeAnimation(x _x: CGFloat, y _y:CGFloat, duration _duration:CFTimeInterval) {
        let keyFrame = CAKeyframeAnimation(keyPath: "position")
        
        let point = self.layer.position
        keyFrame.values = [NSValue(cgPoint: CGPoint(x: CGFloat(point.x), y: CGFloat(point.y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - _x), y: CGFloat(point.y - _y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + _x), y: CGFloat(point.y + _y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - _x), y: CGFloat(point.y - _y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + _x), y: CGFloat(point.y + _y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x - _x), y: CGFloat(point.y - _y))),
                           NSValue(cgPoint: CGPoint(x: CGFloat(point.x + _x), y: CGFloat(point.y + _y))),
                           NSValue(cgPoint: point)]
        
        keyFrame.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        keyFrame.duration = _duration
        self.layer.position = point
        self.layer.add(keyFrame, forKey: keyFrame.keyPath)
    }
    
    public func setAutoresizingMaskIntoConstraints() -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
    
    /// Returns the first constraint with the given identifier, if available.
    ///
    /// - Parameter identifier: The constraint identifier.
    public func constraintWithIdentifier(_ identifier: String) -> NSLayoutConstraint? {
        return self.constraints.filter({$0.identifier == identifier}).first
    }
}
