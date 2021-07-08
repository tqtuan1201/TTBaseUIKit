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
    
    
    
    public func setConerDef() {
        self.setConerRadius(with: TTSize.CORNER_RADIUS)
    }
    
    public func setBorder(with width:CGFloat, color:UIColor, coner:CGFloat) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
        self.setConerRadius(with: coner)
    }
    
    public func setDashedLine(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layer.sublayers?.filter({$0.name == "BORDER_DASH"}).forEach({$0.removeFromSuperlayer()})
        let border = CAShapeLayer()
        border.name = "BORDER_DASH"
        border.lineWidth = lineWidth
        border.strokeColor = strokeColor.cgColor
        border.fillColor = nil
        border.lineDashPattern = [4, 4]
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds;
        self.layer.addSublayer(border)
    }
    
    public func done(_ completion: (() -> Void)? = nil) {
        completion?()
    }

    public func setConerRadius(with radius:CGFloat) {
        self.layer.cornerRadius = radius
        if radius == 0.0 {
            self.clipsToBounds = false
        } else {
            self.clipsToBounds = true
        }
    }
    
    public func roundCorners(corners: UIRectCorner, radius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    public func setBgImageView(withImage image:UIImage?) {
        let backgroundImage = TTBaseUIImageView()
        backgroundImage.isUserInteractionEnabled = false
        backgroundImage.image = image
        self.insertSubview(backgroundImage, at: 0)
        backgroundImage.setFullContraints(view: self, constant: 0)
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
    
    public func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
    
    public static func getGradientSkeletonLayer(heightDef:CGFloat = TTBaseUIKitConfig.getSizeConfig().H_CELL, widthDef:CGFloat = TTBaseUIKitConfig.getSizeConfig().W ) -> CALayer {
        
        let startLocations : [NSNumber] = [-1.0,-0.5, 0.0]
        let endLocations : [NSNumber] = [1.0,1.5, 2.0]
        let gradientBackgroundColor : CGColor = TTView.viewBgGradientSkeleton.cgColor
        let gradientMovingColor : CGColor = TTView.viewBgGradientMoveSkeleton.cgColor
        
        let movingAnimationDuration : CFTimeInterval = 0.8
        let delayBetweenAnimationLoops : CFTimeInterval = 1.0
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.zPosition = CONSTANT.POSITION_VIEW.SKELETON_LAYER.rawValue
        gradientLayer.frame = CGRect.init(x: -4, y: 0, width: widthDef + 8, height: heightDef)
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [ gradientBackgroundColor, gradientMovingColor, gradientBackgroundColor ]
        gradientLayer.locations = startLocations
        gradientLayer.name = "SkeletonAnimating"
        
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = startLocations
        animation.isRemovedOnCompletion = false
        animation.toValue = endLocations
        animation.duration = movingAnimationDuration
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = movingAnimationDuration + delayBetweenAnimationLoops
        animationGroup.animations = [animation]
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = .infinity
        gradientLayer.add(animationGroup, forKey: animation.keyPath)
        return gradientLayer
    }
    
    public func onStartSkeletonCustomViewAnimation(withDef height:CGFloat = TTBaseUIKitConfig.getSizeConfig().H_CELL, width:CGFloat = TTBaseUIKitConfig.getSizeConfig().W) {
        if !(self.layer.sublayers?.filter({$0.name == "SkeletonAnimating"}) ?? []).isEmpty { return }
        self.clipsToBounds = true
        self.layer.addSublayer(UIView.getGradientSkeletonLayer(heightDef: height, widthDef: width))
        let views = self.subviewsRecursive()
        for view in views {
            if let lb = view as? TTBaseUILabel {lb.onAddSkeletonMark()}
            if let btn = view as? TTBaseUIButton {btn.onAddSkeletonMark()}
            if let img = view as? TTBaseUIImageView {img.onAddSkeletonMark()}
            if let web = view as? TTBaseWKWebView {web.onAddSkeletonMark()}
        }
    }
    
    public func onStopSkeletonCustomViewAnimation() {
        self.layer.sublayers?.filter({$0.name == "SkeletonAnimating"}).first?.removeFromSuperlayer()
        let views = self.subviewsRecursive()
        for view in views {
            if let _ = view as? TTBaseUIView {
                //view.backgroundColor = view.viewDefBgColor
            } else if let lb = view as? TTBaseUILabel {
                lb.onRemoveSkeletonMark()
            }  else if let btn = view as? TTBaseUIButton {
                btn.onRemoveSkeletonMark()
            } else if let img = view as? TTBaseUIImageView {
                img.onRemoveSkeletonMark()
            } else if let web = view as? TTBaseWKWebView {
                web.onRemoveSkeletonMark()
            }
        }
    }
    
    public func addSubviews(views: [UIView]) {
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(view)
        }
    }
    
    public func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    public func setMapBaseAnimation(withPadding padding:CGFloat, time:TimeInterval = 20.0) {
        UIView.animate(withDuration: time, delay: 0, options: [.repeat, .autoreverse, .preferredFramesPerSecond60, .overrideInheritedDuration], animations: { [weak self] in
            let arrBg:[CGAffineTransform] = [CGAffineTransform(translationX: padding, y: 0),CGAffineTransform(translationX: padding, y: 0)]
            self?.transform = arrBg[Int(arc4random_uniform(UInt32(arrBg.count)))]
        }, completion: nil)
    }
    
    /// Detect position waring view
    ///
    /// - Parameter duration: This is time for play animation when detect view
    public func onDetectPositionForValidation(withDuration dur:Double = 3.0) {
        DispatchQueue.main.async { [weak self] in guard let strongSelf = self else { return }
            
            strongSelf.shakeAnimation(x: 1, y: 1, duration: 1.0)
            let warningView:TTBaseUIView = TTBaseUIView()
            warningView.setConerDef()
            warningView.isUserInteractionEnabled = false
            warningView.backgroundColor = TTBaseUIKitConfig.getViewConfig().labelBgWar.withAlphaComponent(0.5)
            warningView.alpha = 0
            warningView.tag = CONSTANT.TAG_VIEW.WARNING_VIEW.rawValue
            
            if strongSelf.viewWithTag(CONSTANT.TAG_VIEW.WARNING_VIEW.rawValue) == nil {
                strongSelf.addSubview(warningView); warningView.setFullContraints(constant: 0)
                UIView.animate(withDuration: dur, animations: {
                    warningView.alpha = 1
                }) { (true) in
                    UIView.animate(withDuration: dur - 1.0, animations: {
                        warningView.alpha = 0
                    }) { (true) in
                        warningView.removeFromSuperview()
                    }
                }
            }
        }
    }
    
//    public func startSkeletonAnimating() {
//        if (self.layer.sublayers?.filter({$0.name == "SkeletonAnimating"}).isEmpty ?? false) {
//            self.layer.addSublayer(self.getGradientSkeletonLayer())
//        } else {
//            return
//        }
//    }
//    
//    public func stopSkeletonAnimating() {
//        self.layer.sublayers?.filter({$0.name == "SkeletonAnimating"}).forEach({$0.removeFromSuperlayer()})
//    }

}

//MARK:// UIStackView
extension UIStackView {
    public func addArrangeSubviews(views: [UIView]) {
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
    }
}

//MARK:// UILabel
extension UILabel {
    public func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font ?? TTFont.getFont()], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}
