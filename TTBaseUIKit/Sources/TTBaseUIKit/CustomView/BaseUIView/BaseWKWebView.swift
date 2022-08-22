//
//  BaseWKWebView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import WebKit

open class TTBaseWKWebView: WKWebView, UIGestureRecognizerDelegate {
    
    public lazy var skeletonMarkView:TTBaseSkeletonMarkView = TTBaseSkeletonMarkView()
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: .zero, configuration: configuration)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    open var onTouchHandler:((_ webview:TTBaseWKWebView) -> Void)?
    
    public convenience init(gifNameString:String) {
        self.init(frame: .zero, configuration: WKWebViewConfiguration())
        self.translatesAutoresizingMaskIntoConstraints = false
        self.contentMode = UIView.ContentMode.scaleAspectFit
        self.scrollView.isScrollEnabled = false
        if let url = Bundle.main.url(forResource: gifNameString, withExtension: "gif") {
            if let data = try? Data(contentsOf: url) {
                self.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url)
            }
        } else if let url = Bundle(for: Fonts.self).url(forResource: gifNameString, withExtension: "gif") {
            if let data = try? Data(contentsOf: url) {
                self.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url)
            }
        }
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(self.onTouchImage(_:)))
        tap.delegate = self
        self.scrollView.addGestureRecognizer(tap )
    }
    
    @objc fileprivate func onTouchImage(_ sender:UITapGestureRecognizer) {
        self.onTouchHandler?(self)
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
}


//MARK:// Skeleton
extension TTBaseWKWebView {
    
    public func onAddSkeletonMark() {
        if self.viewWithTag(CONSTANT.TAG_VIEW.WKWEB_VIEW_SKELETON.rawValue) != nil { return }
        
        self.skeletonMarkView = TTBaseSkeletonMarkView()
        self.skeletonMarkView.tag = CONSTANT.TAG_VIEW.WKWEB_VIEW_SKELETON.rawValue
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


extension WKWebView {

    /// load HTML String same font like the UIWebview
    ///
    //// - Parameters:
    ///   - content: HTML content which we need to load in the webview.
    ///   - baseURL: Content base url. It is optional.
    public func loadHTMLStringWithMagic(content:String,baseURL:URL?){
        let headerString = "<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>"
        loadHTMLString(headerString + content, baseURL: baseURL)
    }
}
