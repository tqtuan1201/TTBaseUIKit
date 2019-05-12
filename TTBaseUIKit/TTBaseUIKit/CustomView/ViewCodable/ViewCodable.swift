//
//  ViewCodable.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/13/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit


///
/// This is a protocol use to easily organize UI handling code.
///
public protocol TTViewCodable {
    
    /*
     This function calls all other functions in the correct order.
     You can use it in an UIViewController viewDidLoad method or in a view initializer, for example.
     */
    func setupViewCodable(with views : [UIView])
    
    //  This function should be used to add your custom views to the views hierarchy
    func addToHierarchy(_ views : [UIView])
    
    // This function should be used to add more customs views
    func setupCustomView()
    
    // This function should be used to add constraints to your customs views
    func setupConstraints()
    
    /*
     This function should be used to apply styles to your customs views.
     You could change colors, fonts, alignments or other properties here.
     */
    func setupStyles()
    
    /*
     This function should be used to set data
     */
    func setupData()
    
    /*
     This function should be used to call base API
     */
    func setupBaseAPI()
    
    /*
     This function should be used to link actions to your customs views.
     For example, you could add a selector to a button or use reactive bindings here.
     */
    func bindComponents()
    
    /*
     This function should be used to react for viewModel
     */
    func bindViewModel()
    
    /*
     This function should be used to set AcessibilityIdentifiers view for test automationTest
     */
    func setupAcessibilityIdentifiers()
    
}

//MARK: - UI extensions
extension TTViewCodable where Self : UIView {
    
    public func addToHierarchy(_ views : [UIView]) {
        add(views, to: self)
    }
    
}

extension TTViewCodable where Self : UIViewController {
    
    public  func addToHierarchy(_ views : [UIView]) {
        add(views, to: self.view)
    }
    
}

extension TTViewCodable where Self : UITableViewCell {
    
    public func addToHierarchy(_ views : [UIView]) {
        add(views, to: contentView)
    }
    
}

//MARK: - Helpers
private func add(_ views : [UIView], to parentView : UIView) {
    views.forEach {
        $0.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview($0)
    }
}


extension TTViewCodable {
    
   public func setupViewCodable(with views : [UIView]) {
        self.addToHierarchy(views)
        self.setupCustomView()
        self.setupConstraints()
        self.setupStyles()
        self.bindComponents()
        self.bindViewModel()
        self.setupData()
        self.setupBaseAPI()
        self.setupAcessibilityIdentifiers()
    }
    
    // Making some of the functions optional, since they might not apply to every context
    
    public func setupCustomView() { }
    
    public func setupConstraints() { }
    
    public func setupStyles() { }
    
    public func bindComponents() { }
    
    public func setupAcessibilityIdentifiers() { }
    
    public func setupData() {}
    
    public func setupBaseAPI() {}
    
    public func bindViewModel() {}

    
}
