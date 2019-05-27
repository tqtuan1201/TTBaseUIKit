//
//  UITableView+UICollectionView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/18/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

/// Easier way to create cell identifier
public protocol ReusableView: class {
    /// Get identifier from class
    static var defaultReuseIdentifier: String { get }
}

public extension ReusableView where Self: UIView {
    static var defaultReuseIdentifier: String {
        // Set the Identifier from class name
        return NSStringFromClass(self)
    }
}

/// Extend to easier allow for identifier to be set without much work
extension UITableView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UITableViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        
        guard let cell = dequeueReusableCell(withIdentifier: T.defaultReuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    
    /// Register cell with automatically setting Identifier
    public func register<T: UITableViewHeaderFooterView>(_: T.Type) where T: ReusableView {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.defaultReuseIdentifier)
    }

    /// Get cell with the default reuse cell identifier
    public func dequeueReusableHeaderFooterCell<T: UITableViewHeaderFooterView>() -> T where T: ReusableView {
        
        
        guard let cell = dequeueReusableHeaderFooterView(withIdentifier: T.defaultReuseIdentifier) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
    
    
    public func setNonBgNoData() {
        self.backgroundView = nil
        self.backgroundView?.isUserInteractionEnabled = false
        self.isScrollEnabled = true
    }
    
    public func setBgGifNoData(withImageName imageString:String, onTouchHandle:(() -> ())?)  {
        
        let panelView:UIView = UIView()
        panelView.backgroundColor = UIColor.white
        panelView.translatesAutoresizingMaskIntoConstraints = false
        
        let webView:TTBaseWKWebView = TTBaseWKWebView(gifNameString: imageString)
        
        webView.contentMode = UIView.ContentMode.bottom
        webView.scrollView.isScrollEnabled = false
        panelView.addSubview(webView)
        
        webView.widthAnchor.constraint(equalTo: panelView.widthAnchor, multiplier: 1).isActive = true
        webView.heightAnchor.constraint(equalTo: webView.widthAnchor, multiplier: 1).isActive = true
        webView.centerXAnchor.constraint(equalTo: panelView.centerXAnchor, constant: 1).isActive = true
        webView.centerYAnchor.constraint(equalTo: panelView.centerYAnchor, constant: 1).isActive = true
        
        self.backgroundView = panelView
        self.backgroundView?.isUserInteractionEnabled = true
        self.backgroundView?.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundView?.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor, constant: 0).isActive = true
        self.backgroundView?.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor, constant: 0).isActive = true
        self.backgroundView?.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor, constant: 0).isActive = true
        self.backgroundView?.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        
        self.backgroundView?.alpha = 0
        UIView.animate(withDuration: 0.8) {
            self.backgroundView?.alpha = 1
        }
        self.isScrollEnabled = false
        
        webView.onTouchHandler = { baseWebView in
            onTouchHandle?()
        }
    }
    

    public func setStaticBgNoData(withIcon icon:AwesomePro.Light , color:UIColor = TTBaseUIKitConfig.getViewConfig().viewIconTextBgTableView, title:String, des:String, isScrool:Bool = false, onTouchHandle:(() -> ())?)  {
            self.setStaticBgNoData(withImageName: icon.rawValue, color: color, title: title, des: des, isScrool: isScrool) {
                onTouchHandle?()
            }
    }
    
    public func setStaticBgNoData(withImageName icon:String = AwesomePro.Light.clock.rawValue, color:UIColor = TTBaseUIKitConfig.getViewConfig().viewIconTextBgTableView, title:String, des:String, isScrool:Bool = false, onTouchHandle:(() -> ())?)  {
        
        let emptyView = TTBaseUIView()
        emptyView.setBgColor(UIColor.clear)
        emptyView.frame = CGRect(x: self.center.x, y: self.center.y, width: self.bounds.size.width, height: self.bounds.size.height)
        emptyView.translatesAutoresizingMaskIntoConstraints = true
        
        var paddingTop:CGFloat = TTSize.P_CONS_DEF
        
        var imageView:TTBaseUIImageView = TTBaseUIImageFontView(withFontIconSize: icon, sizeIcon: CGSize(width: 100, height: 100), colorIcon: color, contendMode: .scaleAspectFit)
        if icon.contains(".ing") || icon.contains(".png") { imageView = TTBaseUIImageView(with: icon) ; paddingTop = TTSize.P_CONS_DEF + 3 }
        
        imageView.backgroundColor = UIColor.clear
        emptyView.addSubview(imageView)
        
        imageView.setWidthAnchor(constant: TTSize.W / 4.5).setHeightAnchor(constant: TTSize.W / 4.5).setFullCenterAnchor(constant: 0)
        
        let titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: title, align: .center)
        titleLabel.setTextColor(color: color).done()
        titleLabel.backgroundColor = UIColor.clear
        emptyView.addSubview(titleLabel)
        
        titleLabel.setVerticalContentHuggingPriority().setTopAnchorWithAboveView(nextToView: imageView, constant: paddingTop).done()
        titleLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: paddingTop).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -paddingTop).isActive = true
        
        let subLabel:TTBaseUILabel = TTBaseUILabel(withType: .SUB_TITLE, text: des, align: .center)
        subLabel.backgroundColor = UIColor.clear
        subLabel.setTextColor(color: color).done()
        emptyView.addSubview(subLabel)
        
        subLabel.setVerticalContentHuggingPriority().setTopAnchorWithAboveView(nextToView: titleLabel, constant: TTSize.P_CONS_DEF / 2).done()
        subLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: paddingTop).isActive = true
        subLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -paddingTop).isActive = true
        
        
        // The only tricky part is here:
        self.backgroundView = emptyView
        self.separatorStyle = .none
        self.backgroundView?.isUserInteractionEnabled = true
        
        self.backgroundView?.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.backgroundView?.alpha = 1
        }
        self.isScrollEnabled = isScrool
        emptyView.setTouchHandler().onTouchHandler = { view in
            onTouchHandle?()
        }
        
    }
    
}

/// Extend to easier allow for identifier to be set without much work
extension UICollectionView {
    
    /// Register cell with automatically setting Identifier
    public func register<T: UICollectionViewCell>(_: T.Type) where T: ReusableView {
        register(T.self, forCellWithReuseIdentifier: T.defaultReuseIdentifier)
    }
    
    /// Get cell with the default reuse cell identifier
    public func dequeueReusableCell<T: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> T where T: ReusableView {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.defaultReuseIdentifier, for: indexPath as IndexPath) as? T else {
            fatalError("Could not dequeue cell: \(T.self) with identifier: \(T.defaultReuseIdentifier)")
        }
        
        return cell
    }
}
