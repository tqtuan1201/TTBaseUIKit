//
//  BaseUISearchView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/7/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseSearchBar: UISearchBar {
    
    public enum TYPE {
        case DEF
    }
    
    var type:TYPE = .DEF
    
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupBaseUIView()
    }
    
    public convenience init(withType type:TYPE, textPlaceHolder:String) {
        self.init(frame: .zero)
        self.placeholder = textPlaceHolder
        self.setupBaseUIView()
    }
    
    
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupBaseUIView() {
        self.backgroundImage = UIImage()
        self.backgroundColor = UIColor.white
        self.translatesAutoresizingMaskIntoConstraints = false
        self.tintColor = TTView.textDefColor
        self.layer.shadowOpacity = 0
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.masksToBounds = false
        let textFieldInsideSearchBar = self.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = TTView.textDefColor
    }
}


extension TTBaseSearchBar {
    
    public func getTextField() -> UITextField? {
        return self.value(forKey: "searchField") as? UITextField
    }
    
}
