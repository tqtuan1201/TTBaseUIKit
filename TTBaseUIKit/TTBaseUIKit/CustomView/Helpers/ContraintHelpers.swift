//
//  ContraintHelpers.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/14/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    public func setLeadingAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setLeadingAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            var leadingAnchor:NSLayoutConstraint
            if #available(iOS 11.0, *) {
                leadingAnchor = self.leadingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.leadingAnchor, constant: constant)
            } else {
                leadingAnchor = self.leadingAnchor.constraint(equalTo: superView.leadingAnchor, constant: constant)
            }
            leadingAnchor.identifier  = identifierAnchor;
            leadingAnchor.isActive = true
        }
        return self
    }
    
    public func setTrailingAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setTrailingAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = -constant
        } else {
            var trailingAnchor:NSLayoutConstraint
            if #available(iOS 11.0, *) {
                trailingAnchor = self.trailingAnchor.constraint(equalTo: superView.safeAreaLayoutGuide.trailingAnchor, constant: -constant)
            } else {
                trailingAnchor = self.trailingAnchor.constraint(equalTo: superView.trailingAnchor, constant: -constant)
            }

            trailingAnchor.identifier  = identifierAnchor;
            trailingAnchor.isActive = true
        }
        return self
    }
    
    public func setTopAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setTopAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let topAnchor = self.topAnchor.constraint(equalTo: superView.topAnchor, constant: constant)
            topAnchor.identifier  = identifierAnchor;
            topAnchor.isActive = true
        }
        return self
    }
    
    public func setBottomAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setBottomAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = -constant
        } else {
            let bottomAnchor = self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -constant)
            bottomAnchor.identifier  = identifierAnchor;
            bottomAnchor.isActive = true
        }
        return self
    }
    
    public func setCenterXAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        
        let identifierAnchor:String = "TTBase.Contraint.setCenterXAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let centerXAnchor = self.centerXAnchor.constraint(equalTo: superView.centerXAnchor, constant: constant)
            centerXAnchor.identifier  = identifierAnchor;
            centerXAnchor.isActive = true
        }
        return self
    }
    
    public func setcenterYAnchor(_ view:UIView? = nil, isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setcenterYAnchor"
        guard let  superView = (view == nil) ? self.superview : view else { return self }
        if isUpdate {
            superView.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let centerYAnchor = self.centerYAnchor.constraint(equalTo: superView.centerYAnchor, constant: constant)
            centerYAnchor.identifier  = identifierAnchor;
            centerYAnchor.isActive = true
        }
        return self
    }
    
    public func setWidthAnchor(_ isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setWidthAnchor"
        if isUpdate {
            self.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let widthAnchor = self.widthAnchor.constraint(equalToConstant: constant)
            widthAnchor.identifier  = identifierAnchor;
            widthAnchor.isActive = true
        }
        return self
    }
    
    public func setHeightAnchor(_ isUpdate:Bool = false, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setHeightAnchor"
        if isUpdate {
            self.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let heightAnchor = self.heightAnchor.constraint(equalToConstant: constant)
            heightAnchor.identifier  = identifierAnchor;
            heightAnchor.isActive = true
        }
        return self
    }
    
}


extension UIView {
    
    public func setFullContraints(view:UIView? = nil, constant:CGFloat) {
        guard let  superView = (view == nil) ? self.superview : view else { return }
        self.setLeadingAnchor(superView, constant: constant).setTrailingAnchor(superView, constant: constant)
            .setTopAnchor(superView, constant: constant).setBottomAnchor(superView, constant: constant).done()
    }

    public func setFullContraints(view:UIView? = nil, lead:CGFloat, trail:CGFloat, top:CGFloat, bottom:CGFloat) {
        guard let  superView = (view == nil) ? self.superview : view else { return }
        self.setLeadingAnchor(superView, constant: lead).setTrailingAnchor(superView, constant: trail)
            .setTopAnchor(superView, constant: top).setBottomAnchor(superView, constant: bottom).done()
    }
    
    
    public func setTopAnchorWithAboveView(_ isUpdate:Bool = false, nextToView:UIView, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setTopAnchorWithAboveView"
        if isUpdate {
            self.superview?.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let anchor = self.topAnchor.constraint(equalTo: nextToView.bottomAnchor, constant: constant)
            anchor.identifier  = identifierAnchor;
            anchor.isActive = true
        }
        return self
    }
    
    public func setBottomAnchorWithBelowView(_ isUpdate:Bool = false, view:UIView, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setBottomAnchorWithBelowView"
        if isUpdate {
            self.superview?.constraintWithIdentifier(identifierAnchor)?.constant = -constant
        } else {
            let anchor = self.bottomAnchor.constraint(equalTo: view.topAnchor, constant: -constant)
            anchor.identifier  = identifierAnchor;
            anchor.isActive = true
        }
        return self
    }

    public func setTrailingWithNextToView(_ isUpdate:Bool = false, view:UIView, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setTrailingWithNextToView"
        if isUpdate {
            self.superview?.constraintWithIdentifier(identifierAnchor)?.constant = -constant
        } else {
            let anchor = self.trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant)
            anchor.identifier  = identifierAnchor;
            anchor.isActive = true
        }
        return self
    }
    
    public func setLeadingWithNextToView(_ isUpdate:Bool = false, view:UIView, constant:CGFloat) -> UIView {
        let identifierAnchor:String = "TTBase.Contraint.setLeadingWithNextToView"
        if isUpdate {
            self.superview?.constraintWithIdentifier(identifierAnchor)?.constant = constant
        } else {
            let anchor = self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
            anchor.identifier  = identifierAnchor;
            anchor.isActive = true
        }
        return self
    }
    
}
