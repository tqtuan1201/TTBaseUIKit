//
//  WebViewController.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 25/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import Foundation

import TTBaseUIKit
import WebKit

class WebViewController: BaseUIViewController {
    override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE {return .STATUS_NAV}
    override var lgNavType: BaseUINavigationView.TYPE { return .DETAIL}
    private let webView: TTBaseWKWebView = TTBaseWKWebView()
    private let loadingView: UIActivityIndicatorView = UIActivityIndicatorView(style: .gray)
    override var isSetHiddenTabar: Bool { return true }
    private var navTitle:String = "Web"
    
    private var urlString:String = ""
    
    init(navTitle: String, urlString: String? = nil) {
        self.urlString = urlString ?? ""
        self.navTitle = navTitle
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubviews(views: [self.webView, self.loadingView])
        self.setTitleNav(navTitle.uppercased())
        
        self.loadingView
            .setcenterYAnchor(constant: 0)
            .setCenterXAnchor(constant: 0)
            .setHeightAnchor(constant: XSize.H_ICON_CELL)
            .setWidthAnchor(constant: XSize.H_ICON_CELL)
        
        self.webView
            .setTopAnchor(constant: XSize.getHeightNavWithStatus())
            .setLeadingAnchor(constant: 0)
            .setTrailingAnchor(constant: 0)
            .setBottomAnchor(constant: 0)
        
        self.loadingView.hidesWhenStopped = true
        self.webView.isHidden = true
        self.webView.navigationDelegate = self
        
        if let url = URL(string: self.urlString) {
            self.loadContent(url: url)
        }
    }
    
    override func navDidTouchUpBackButton(withNavView nav: BaseUINavigationView) {
        self.pop()
        self.dismiss(animated: true)
    }
    
    func loadContent(url: URL) {
        self.runOnMainThread {
            let request = URLRequest(url: url)
            self.webView.load(request)
            self.loadingView.startAnimating()
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.runOnMainThread {
            self.webView.isHidden = false
            self.loadingView.stopAnimating()
            self.loadingView.isHidden = true
            
        }
    }
}
