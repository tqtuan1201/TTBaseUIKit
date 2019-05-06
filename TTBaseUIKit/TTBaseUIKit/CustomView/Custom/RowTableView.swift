//
//  RowTableView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/29/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//
import UIKit
import Foundation
///
/// This Class to create colum table view
///
/// Input number of Comlum Ex: Input 4  ==  | COMLUMN 1 | COLUMN 2 | COLUMN 3 | COLUMN 4 |
///
/// Input number of column by int or string
///
open class TTRowTableView: TTBaseUIView {
    
    open var paddingStack:(CGFloat,CGFloat,CGFloat,CGFloat) { get { return (TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF,TTSize.P_CONS_DEF)}}
    open var paddingLabel:CGFloat { get { return TTSize.P_CONS_DEF / 2 }}
    open var spaceLabelStack:CGFloat { get { return TTSize.P_CONS_DEF / 4 }}
    open var numberOfLine:Int { get { return 2 }}
    
    open var stackView:TTBaseUIStackView =  TTBaseUIStackView(axis: .horizontal, spacing: TTSize.P_CONS_DEF / 4, alignment: .fill, distributionValue: .fillEqually)
    
    open var columnType:TTBaseUILabel.TYPE { get { return TTBaseUILabel.TYPE.SUB_TITLE}}
    open var columnTitleType:TTBaseUILabel.TYPE { get { return TTBaseUILabel.TYPE.TITLE}}
    
    open var titleBgColor:UIColor { get { return TTView.tableRowTitleBgColor }}
    open var rowDev1BgColor:UIColor { get { return TTView.tableRowDev1BgColor }}
    open var rowDev2BgColor:UIColor { get { return TTView.tableRowDev2BgColor }}
    
    open var titleTextColor:UIColor { get { return TTView.tableRowTitleTextColor }}
    open var rowTextColor:UIColor { get { return TTView.tableRowTextColor }}
    
    public var bgColor:UIColor = TTView.viewBgCellColor
    
    fileprivate let ID_DEFINE:String = "COLUMN_"
    fileprivate var columnValue:[String] = []
    
    open func updateButtonPanelView() { }
    
    public convenience init(with numberOfColumn:Int, bgColor:UIColor) {
        self.init()
        self.columnValue = Array(repeating: "Value", count: numberOfColumn)
        self.bgColor = bgColor
        self.setupBaseUIView()
        self.updateButtonPanelView()
    }
    
    public convenience init(with columnValue:[String], bgColor:UIColor) {
        self.init()
        self.columnValue = columnValue
        self.bgColor = bgColor
        self.setupBaseUIView()
        self.updateButtonPanelView()
    }
    
}

// MARK: For private funcs
extension TTRowTableView {
    
    fileprivate func setupBaseUIView() {
        self.backgroundColor = bgColor
        self.stackView.spacing = spaceLabelStack
        self.addSubview(self.stackView)
        self.stackView.setFullContraints(view: self, lead: paddingStack.0, trail: paddingStack.2, top: paddingStack.1, bottom: paddingStack.3)
        
        for (index, column) in self.columnValue.enumerated() {
            let label:TTBaseUILabel = TTBaseUILabel(withType: self.columnType)
            label.accessibilityIdentifier = "\(ID_DEFINE)\(index)"
            label.setText(text: column).setTextColor(color: rowTextColor).done()
            label.setMutilLine(numberOfLine: self.numberOfLine, textAlignment: .center).done()
            label.setTopAnchor(constant: self.paddingLabel).setBottomAnchor(constant: self.paddingLabel).done()
            self.stackView.addArrangedSubview(label)
        }
    }
    
}

// MARK: For public funcs
extension TTRowTableView {
    
    public func setColum(byString values:[String], indexRow:Int = 0) {
        for (index, view) in self.stackView.arrangedSubviews.enumerated() {
            guard let columnLabel:TTBaseUILabel = view as? TTBaseUILabel  else { return }
            if values.indices.contains(index) {
                columnLabel.setText(text: values[index]).layoutIfNeeded()
                if indexRow % 2 == 0 {
                    self.backgroundColor = self.rowDev1BgColor
                } else {
                    self.backgroundColor =  self.rowDev2BgColor
                }
            }
        }
    }
    
    public func setTitleColum(byString values:[String], fontSize:CGFloat, isBold:Bool) {
        for (index, view) in self.stackView.arrangedSubviews.enumerated() {
            guard let columnLabel:TTBaseUILabel = view as? TTBaseUILabel  else { return }
            if values.indices.contains(index) {
                columnLabel.setText(text: values[index]).setTextColor(color: self.titleTextColor).setFontSize(size: fontSize).layoutIfNeeded()
                self.backgroundColor = self.titleBgColor
                if isBold { columnLabel.setBold().done()}
            }
        }
    }
}
