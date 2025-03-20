//
//  BaseCustomUICollectionFlowLayoutViewCell.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 18/3/25.
//  Copyright © 2025 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

import UIKit

import UIKit

class AutoSizingFlowLayout: UICollectionViewFlowLayout {
    let columns: Int = 2
    let itemSpacing: CGFloat = 10
    let topPadding: CGFloat = 10 // Uniform top padding for all items

    override func prepare() {
        super.prepare()
        
        // Enable self-sizing cells
        estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        sectionInset = UIEdgeInsets.zero
        scrollDirection = UICollectionView.ScrollDirection.vertical
        minimumInteritemSpacing = itemSpacing
        minimumLineSpacing = topPadding // Set top padding between all items
    }
    
    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
//        
//        for index in stride(from: 0, to: attributes.count, by: 2) {
//            guard index + 1 < attributes.count else { continue }
//            
//            let firstAttr = attributes[index]
//            let secondAttr = attributes[index + 1]
//            
//            let heightFirst = firstAttr.frame.height
//            let heightSecond = secondAttr.frame.height
//            
//            let minY = min(firstAttr.frame.origin.y, secondAttr.frame.origin.y)
//            
//            if heightFirst > heightSecond {
//                secondAttr.frame.origin.y = minY
//            } else {
//                firstAttr.frame.origin.y = minY
//            }
//        }
//        
//        return attributes
//    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
          guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        for (_i, _a) in attributes.enumerated() {
            if _i % 2 == 0 {
                let _second = attributes[safeIndex: _i + 1]
                let height_First = _a.frame.size.height
                let height_Second = _second?.frame.size.height ?? 0.0
                
                if height_First > height_Second {
                    if let _trueY:CGFloat = attributes[safeIndex: _i]?.frame.origin.y {
                        attributes[safeIndex: _i + 1]?.frame.origin.y = _trueY
                    }
                } else {
                    if let _trueY:CGFloat = attributes[safeIndex: _i + 1]?.frame.origin.y {
                        attributes[safeIndex: _i]?.frame.origin.y = _trueY
                    }
                }
                
            }
        }
          
          return attributes
      }
    
}

class AutoSizingCell: TTBaseUICollectionViewCell {
    
    let image:TTBaseUIImageView = TTBaseUIImageView(imageName: "AppIcon", contentMode: .scaleAspectFill)
    let nameLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Require two line\nDescription...", align: .left).setBold().setTextColor(color: XView.textDefColor)
    let priveLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Price...", align: .left).setTextColor(color: XView.textDefColor)
    
    override var padding: CGFloat {get { return 0 } }
    override var isSetPanelBgColor: Bool {get { return false } }
    override var bgColor: UIColor { get { return .red } }
    
    
    override func updateUI() {
        super.updateUI()
        self.setupViewCodable(with: [])
    }
    
}


extension AutoSizingCell :TTViewCodable {
    
    func setupStyles() {
        self.image.setConerDef()
        self.nameLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingTail).setNonBold()
        self.priveLabel.setMutilLine(numberOfLine: 0, textAlignment: .left, mode: .byTruncatingTail).setNonBold()
        self.priveLabel.setBold()
        self.panel.setBgColor(.clear)
        self.panel.setBorder(with: 1, color: UIColor.black.withAlphaComponent(0.1), coner: 8.0)
        self.panel.setBgColor(UIColor.black.withAlphaComponent(0.1))
    }
    
    func setupCustomView() {
        self.panel.addSubviews(views: [self.image, self.nameLabel, self.priveLabel])
    }
    
    func setupConstraints() {
        
        let paddingImage:CGFloat = XSize.P_CONS_DEF * 2.0
        
        self.image.setTopAnchor(constant: paddingImage)
            .setLeadingAnchor(constant: paddingImage).setTrailingAnchor(constant: paddingImage)
            .heightAnchor.constraint(equalTo: self.image.widthAnchor, constant: 1.0).isActive = true
        
        self.nameLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.image, constant: XSize.P_CONS_DEF * 2)
        
        self.priveLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF * 2).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.nameLabel, constant: XSize.P_CONS_DEF * 1.4)
            .setBottomAnchor(constant: XSize.P_CONS_DEF)
        
        self.panel.setWidthAnchor(constant: XSize.W / 2 - XSize.P_CONS_DEF * 1.5)
        }
}

