//
//  LogTrackingWebViewController.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 9/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation

class LogTrackingTableViewCell : TTTextSubtextIconTableViewCell {
    override var sizeImages: (CGFloat, CGFloat) { return ( 0,0 )}
    
    override var numberOfLineTitle: Int { return 100}
    override var numberOfLineSub: Int { return 20 }
    
    override func updateUI() {
        super.updateUI()
        self.titleLabel.setTextColor(color: TTView.labelBgDef).setFontSize(size: TTFont.SUB_TITLE_H)
        self.subLabel.setTextColor(color: TTView.labelBgWar).setFontSize(size: TTFont.SUB_TITLE_H)
    }
}


public class LogTrackingWebViewController: TTBaseUIViewController<DarkBaseUIView> {
    
    public override var navType: TTBaseUIViewController<DarkBaseUIView>.NAV_STYLE { return .NO_VIEW}
    
    fileprivate let wkView:TTBaseWKWebView = TTBaseWKWebView()
    fileprivate let backButton:TTBaseUIButton = TTBaseUIButton(textString: "BACK", type: .DEFAULT, isSetSize: false)
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.wkView)
        self.view.addSubview(self.backButton)
        
        self.wkView.translatesAutoresizingMaskIntoConstraints = false
        self.wkView.setFullContraints(lead: 0, trail: 0, top: 0, bottom: 0)
        if let url = URL(string: "http://jsonviewer.stack.hu/") {
            let request = URLRequest(url: url)
            wkView.load(request)
        }
        self.backButton.setWidthAnchor(constant: 200).setHeightAnchor(constant: 40)
            .setBottomAnchor(constant: 8, isMarginsGuide: true)
            .setCenterXAnchor(constant: 0)
        
        self.backButton.onTouchHandler = { [weak self] _ in guard let strongSelf = self else { return }
            strongSelf.dismiss(animated: true, completion: nil)
        }
    }
}
