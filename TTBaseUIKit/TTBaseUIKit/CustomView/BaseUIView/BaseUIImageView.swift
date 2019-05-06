//
//  TTBaseUIView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/8/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//
import Foundation
import UIKit

open class TTBaseUIImageView: UIImageView, ViewDrawer {
    
    var viewDefBgColor: UIColor = TTBaseUIKitConfig.getViewConfig().viewDefColor
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    var paddingContentImage: CGFloat = 0
    
    open func updateUI() { }
    
    public var onTouchHandler:((_ label:TTBaseUIImageView) -> Void)?
    
    public required init() {
        super.init(frame: .zero)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateUI()
    }
    
    open override var alignmentRectInsets: UIEdgeInsets {
        return UIEdgeInsets(top: -self.paddingContentImage, left: -self.paddingContentImage, bottom: -self.paddingContentImage, right: -self.paddingContentImage)
    }

    public convenience init(withIconView iconName:String, contendMode:UIView.ContentMode = UIView.ContentMode.scaleAspectFit, corner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS, padding:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS) {
        self.init()
        self.paddingContentImage = padding
        self.setCorner(withCornerRadius: corner).done()
        self.setImageByName(name: iconName)
        self.contentMode = contendMode
    }
    
    public convenience init(paddingContentImage padding:CGFloat) {
        self.init(); self.paddingContentImage = padding
    }
        
    public convenience init(withCornerRadius radio:CGFloat) {
        self.init(); self.setCorner(withCornerRadius: radio).done()
    }

    public convenience init(withCornerRadius radio:CGFloat, imageName:String, contentMode:UIView.ContentMode) {
        self.init()
        self.setCorner(withCornerRadius: radio).done()
        self.setImageByName(name: imageName)
        self.contentMode = contentMode
    }

    public convenience init(imageName:String, contentMode:UIView.ContentMode) {
        self.init()
        self.setImageByName(name: imageName)
        self.contentMode = contentMode
    }
    
    public convenience init(with imageName:String) {
        self.init()
        self.setImageByName(name: imageName)
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.viewDefCornerRadius = 0
        self.setupUI()
        self.updateUI()
    }
    
    private func setupUI() {
        
        self.drawView()
        self.image =  UIImage(fromTTBaseUIKit: Config.Value.noImageName)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
    }
    
    private func setupTargets() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onTouchView(_:))))
    }
    
    @objc private func onTouchView(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
    
    func setImageFromTTBaseUIKit(name:String) {
        guard let image = UIImage.init(fromTTBaseUIKit: name) else { return }
        self.image =  image
        self.image?.accessibilityIdentifier = name
    }
    
    
}

extension TTBaseUIImageView {
    
    public func setActiveOnTouchHandle() -> TTBaseUIImageView {
        self.isUserInteractionEnabled = true
        self.setupTargets()
        return self
    }
    
    public func setImageByName(name:String) {
        guard let image = UIImage.init(named: name) else { return }
        self.image =  image
        self.image?.accessibilityIdentifier = name
    }
    
    public func setIconStyle(with bgColor:UIColor, iconColor:UIColor, padding:CGFloat) {
        self.setBgColor(bgColor).setIconColor(iconColor).setIconPadding(padding).done()
    }
    
    public func setCorner(withCornerRadius conner:CGFloat) -> TTBaseUIImageView {
        if conner == 0 { return self }
        self.viewDefCornerRadius = conner
        self.drawView()
        return self
    }
    
    public func setBgColor(_ color:UIColor)  -> TTBaseUIImageView {
        self.backgroundColor = color
        return self
    }
    
    public func setIconColor(_ color:UIColor)  -> TTBaseUIImageView {
        self.image = self.image?.tinted(with: color)
        return self
    }
    
    public func setIconPadding(_ padding:CGFloat)  -> TTBaseUIImageView {
        guard let imagePadding = self.image?.addImagePadding(x: padding, y: padding) else { return self}
        self.image = imagePadding.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        return self
    }
    
    public func setImage(with name:String, scale:UIView.ContentMode = .scaleAspectFill)  -> TTBaseUIImageView {
        self.setImageByName(name: name)
        self.contentMode = scale
        return self
    }

    public func setIConImage(with name:String, color:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor,  scale:UIView.ContentMode = .scaleAspectFill)  -> TTBaseUIImageView {
        self.image = UIImage.fontAwesomeIconWithName(nameString: name, size: CGSize(width: 400, height: 400), iconColor: color, backgroundColor: UIColor.clear)
        self.contentMode = scale
        return self
    }
}

