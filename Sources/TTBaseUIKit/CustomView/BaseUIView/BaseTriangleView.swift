//
//  File.swift
//  
//
//  Created by TuanTruong on 18/11/2023.
//

import Foundation
import UIKit

open class TTBaseTriangleView : TTBaseUIView {
    
    fileprivate var bgColor:UIColor = UIColor.getColorFromHex(netHex: 0xF4D648)
    fileprivate var lineColor:UIColor = UIColor.clear
    
    public init(bgColor: UIColor, lineColor: UIColor) {
        self.bgColor = bgColor
        self.lineColor = lineColor
        super.init()
        self.setBgColor(UIColor.clear)
    }
    
    required public init() {
        super.init()
        self.setBgColor(UIColor.clear)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.setBgColor(UIColor.clear)
    }
    
    override open func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: self.frame.size.height))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        path.close()
        
        
        // Specify the fill color and apply it to the path.
        self.bgColor.setFill()
        path.fill()
        
        // Specify a border (stroke) color.
        self.lineColor.setStroke()
        path.stroke()
        self.setConerRadius(with: 0)
    }
}

open class TTBaseWarningArrowView: TTBaseUIView {
    
    public var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Warning Description", align: .left)
    public var arrowView:TTBaseTriangleView = TTBaseTriangleView(bgColor: TTView.labelBgWar, lineColor: UIColor.clear)
    
    fileprivate let panelView:TTBaseUIView = TTBaseUIView()
    fileprivate var bgColor:UIColor = UIColor.getColorFromHex(netHex: 0xF4D648)
    
    open var padding:CGFloat { get { return TTSize.P_CONS_DEF * 2 }}
    open var textColor:UIColor { get { return UIColor.white }}
    
    public init(withTitle title:String, isBold:Bool = true) {
        super.init()
        self.titleLabel.setText(text: title)
        if isBold { self.titleLabel.setBold()}
        self.setupViewCodable(with: [self.arrowView, self.panelView])
    }

    public init(withAttr title:NSMutableAttributedString) {
         super.init()
        self.titleLabel.attributedText = title
        self.setupViewCodable(with: [self.arrowView, self.panelView])
    }

    public init(bgColor color:UIColor) {
        super.init()
        self.bgColor = color
        self.arrowView = TTBaseTriangleView.init(bgColor: color, lineColor: .clear)
        self.setupViewCodable(with: [self.arrowView, self.panelView])
    }
    
    public func setArrowCenter(byView view:UIView, value:CGFloat) {
        self.arrowView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: value).isActive = true
    }
    
    required public init() {
        super.init()
        self.setupViewCodable(with: [self.arrowView, self.panelView])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init()
        self.setupViewCodable(with: [self.arrowView, self.panelView])
    }
}

extension  TTBaseWarningArrowView :TTViewCodable {

    public func setupStyles() {
        self.setConerRadius(with: TTSize.CORNER_RADIUS)
        self.setBgColor(.clear)
        self.panelView.setBgColor(self.bgColor)
        self.panelView.setConerRadius(with: TTSize.CORNER_RADIUS)
        self.titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .left).setTextColor(color: self.textColor)
    }
    
    public func setupCustomView() {
        self.panelView.addSubview(self.titleLabel)
    }
    
    public func setupConstraints() {
        
        self.arrowView.setWidthAnchor(constant: TTSize.P_CONS_DEF * 2.2).setHeightAnchor(constant: TTSize.P_CONS_DEF * 2)
            .setTopAnchor(constant: 0)
        
        self.titleLabel.setVerticalContentHuggingPriority()
            .setFullContraints(constant: self.padding)
            
        self.panelView.setTopAnchorWithAboveView(nextToView: self.arrowView, constant: -2)
            .setLeadingAnchor(constant: 0).setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)
    }
}
