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
    
    var viewDefBgColor: UIColor = UIColor.clear
    var viewDefCornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_RADIUS
    
    
    public var paddingContentImage: CGFloat = 0
    public lazy var skeletonMarkView:TTBaseSkeletonMarkView = TTBaseSkeletonMarkView()
    fileprivate lazy var skeletonImg:UIImage = UIImage.getFromTTBaseUIKitPM(byName: Config.Value.noImageName) ?? UIImage()
    
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
        self.image =  UIImage.getFromTTBaseUIKitPM(byName: Config.Value.noImageName)
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
        guard let image = UIImage.getFromTTBaseUIKitPM(byName: name) else { return }
        self.image =  image
        self.image?.accessibilityIdentifier = name
    }
    
    
}

//MARK://
extension TTBaseUIImageView {
    public func setAnimalForSkeletonView() {
        if let img = self.image { self.skeletonImg = img }
        self.image =  UIImage.getFromTTBaseUIKitPM(byName: Config.Value.noImageName)
    }
    
    public func setRollBackViewForSkeletonAnimal() {
        self.image = self.skeletonImg
    }
}

//MARK:// Skeleton
extension TTBaseUIImageView {
    public func onAddSkeletonMark() {
        if self.viewWithTag(CONSTANT.TAG_VIEW.IMAGE_SKELETON.rawValue) != nil { return }
        
        self.skeletonMarkView = TTBaseSkeletonMarkView()
        self.skeletonMarkView.tag = CONSTANT.TAG_VIEW.IMAGE_SKELETON.rawValue
        self.addSubview(self.skeletonMarkView)
        
        self.skeletonMarkView.setFullContraints(constant: 0)
    }
    
    public func onRemoveSkeletonMark() {
        UIView.animate(withDuration: 0.2, animations: {
            self.skeletonMarkView.alpha = 0
        }) { (isComplete) in
            self.skeletonMarkView.removeFromSuperview()
        }
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
    
    @discardableResult public func setCorner(withCornerRadius conner:CGFloat) -> TTBaseUIImageView {
        if conner == 0 { return self }
        self.viewDefCornerRadius = conner
        self.drawView()
        return self
    }
    
    @discardableResult public func setBgColor(_ color:UIColor)  -> TTBaseUIImageView {
        self.backgroundColor = color
        return self
    }
    
    @discardableResult public func setIconColor(_ color:UIColor)  -> TTBaseUIImageView {
        self.image = self.image?.tinted(with: color)
        return self
    }
    
    @discardableResult public func setIconPadding(_ padding:CGFloat)  -> TTBaseUIImageView {
        guard let imagePadding = self.image?.addImagePadding(x: padding, y: padding) else { return self}
        self.image = imagePadding.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
        return self
    }
    
    @discardableResult public func setImage(with name:String, scale:UIView.ContentMode = .scaleAspectFill)  -> TTBaseUIImageView {
        self.setImageByName(name: name)
        self.contentMode = scale
        return self
    }

    @discardableResult public func setIConImage(with name:String, color:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor,  scale:UIView.ContentMode = .scaleAspectFill, size:CGSize = CGSize(width: 60, height: 60))  -> TTBaseUIImageView {
        self.image = UIImage.fontAwesomeIconWithName(nameString: name, size: size, iconColor: color, backgroundColor: UIColor.clear)
        self.contentMode = scale
        return self
    }
    
    @discardableResult public func setIConImage(with name:AwesomePro.Light, color:UIColor = TTBaseUIKitConfig.getViewConfig().iconColor,  scale:UIView.ContentMode = .scaleAspectFill, size:CGSize = CGSize(width: 60, height: 60))  -> TTBaseUIImageView {
        self.image = UIImage.fontAwesomeIconWithName(nameString: name.rawValue, size: size, iconColor: color, backgroundColor: UIColor.clear)
        self.contentMode = scale
        return self
    }
}

