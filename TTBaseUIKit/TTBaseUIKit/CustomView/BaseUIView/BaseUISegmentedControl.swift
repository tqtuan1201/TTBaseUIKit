//
//  BaseUISegmentedControl.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/20/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUISegmentedControl: UISegmentedControl {
    
    open var selectedColor:UIColor { get { return TTView.segSelectedColor }}
    open var bgDefStyleColor:UIColor { get { return TTView.segBgDef } }
    open var bgLineStyleColor:UIColor { get { return TTView.segBgLine } }
    
    open var textColor:UIColor { get { return TTView.segTextColor }}
    open var textSelectedColor:UIColor { get { return TTView.segTextSelectedColor }}
    
    open var borderColor:UIColor { get { return TTView.segSelectedColor }}
    open var borderHeight:CGFloat { get { return TTSize.H_BORDER }}
    open var isRemoveBorder:Bool { get { return true }}
    
    open var lineBottomHeight:CGFloat { get { return TTSize.H_SEG_LINE }}
    open var lineBottomColor:UIColor { get { return TTView.segLineBottomBg }}
    open var textLineBottomColor:UIColor { get { return UIColor.darkText }}
    open var paddingLine:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (0,0,0,0)}}
    open var conerRadio:CGFloat { get { return TTSize.CORNER_RADIUS }}
    open var fontSize:CGFloat { get { return TTFont.getHeaderSize() } }
    
    public enum TYPE {
        case DEFAULT
        case LINE_BOTTOM
    }
    
    public lazy var underlineView = UIView()
    fileprivate lazy var type:TYPE = .DEFAULT
    
    public var onTouchHandler:((_ seg:TTBaseUISegmentedControl, _ indexSelected:Int) -> Void)?
    
    open func updateUI() { }
    
    public init(with type:TYPE, items:[Any], bgColor:UIColor = UIColor.blue) {
        super.init(items: items)
        self.type = type
        if type == .LINE_BOTTOM {
            self.addUnderlineForSelectedSegment()
            self.updateUIByStyle()
        }
        self.updateUI()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
        self.updateUI()
    }
    
    public override init(items: [Any]?) {
        super.init(items: items)
        self.setupUI()
        self.updateUI()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setupUI() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setTitleTextAttributes([NSAttributedString.Key.font: TTFont.getFont().withSize(self.fontSize)], for: UIControl.State())
        self.updateUIByStyle()
        self.addTarget(self, action: #selector(self.selectionDidChange(_:)), for: .valueChanged)
        
    }
    
    
    fileprivate func updateUIByStyle() {
        
        if self.type == .DEFAULT {
            
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.textSelectedColor], for: .selected)
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.textColor], for: .normal)
            
            self.tintColor = self.selectedColor
            self.backgroundColor = self.bgDefStyleColor
            self.selectedSegmentIndex = 0
            self.layer.borderWidth = self.borderHeight
            self.layer.borderColor = self.borderColor.cgColor
            self.setConerRadius(with: self.conerRadio)
            if isRemoveBorder {self.removeBorders(withColor: self.bgDefStyleColor, selected: self.selectedColor, hightLight: self.bgDefStyleColor.withAlphaComponent(0.4))}
            
        } else {
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.textLineBottomColor], for: .selected)
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: self.textLineBottomColor.withAlphaComponent(0.5)], for: .normal)
            
            self.tintColor = UIColor.clear
            self.backgroundColor = self.bgLineStyleColor
            
            self.selectedSegmentIndex = 0
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
            self.setConerRadius(with: self.conerRadio)
            self.removeBorders(withColor: self.bgLineStyleColor, selected: bgLineStyleColor, hightLight: self.lineBottomColor.withAlphaComponent(0.4))
            
        }

    }
}

// MARK: For private base funcs
extension TTBaseUISegmentedControl {
    
    @objc fileprivate func selectionDidChange(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        self.setSelectedIndex(with: index)
        self.onTouchHandler?(self, index)
    }
    
    fileprivate func addUnderlineForSelectedSegment() {
        
        let widthLine:CGFloat = TTSize.W / CGFloat(self.numberOfSegments)
        self.addSubview(self.underlineView)
        
        self.underlineView.isUserInteractionEnabled = false
        self.underlineView.layer.zPosition = 200
        self.underlineView.frame = CGRect(x: 0, y: TTSize.H_SEG - self.lineBottomHeight, width: widthLine, height: self.lineBottomHeight)
        self.underlineView.backgroundColor = self.lineBottomColor
    }
}

// MARK: For public base funcs
extension TTBaseUISegmentedControl {
    
    public func changeUnderlinePosition() {
        DispatchQueue.main.async {
            let widthLine:CGFloat = UIScreen.main.bounds.width / CGFloat(self.numberOfSegments)
            self.underlineView.frame.size.width = widthLine
            let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(self.selectedSegmentIndex)
            UIView.animate(withDuration: 0.4, animations: { [weak self] in guard let strongSelf = self else { return }
                strongSelf.underlineView.frame.origin.x = underlineFinalXPosition
            })
        }
    }
    
    public func setSelectedIndex(with index:Int) {
        self.selectedSegmentIndex = index
        if self.type == .LINE_BOTTOM { self.changeUnderlinePosition() }
    }
}
