//
//  ViewController.swift
//  TTBaseUIKitExample
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import UIKit
import TTBaseUIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = XView.viewBgColor
        
        //let iconCircle:IconCircleView = IconCircleView()
        //iconCircle.setWidthAnchor(constant: 100).setHeightAnchor(constant: 100).done()

        //let searchFlight:IconFunc = IconFunc()
        //self.view.addSubview(searchFlight)
        //searchFlight.setcenterYAnchor(constant: 0).setCenterXAnchor(constant: 0).done()

        
        let searchFlight:IconFunc = IconFunc()
        searchFlight.titleLabel.setText(text: "Flight")
    
        let searchFlight1:IconFunc = IconFunc()
        searchFlight1.titleLabel.setText(text: "Payment")
        
        let searchFlight2:IconFunc = IconFunc()
        searchFlight2.titleLabel.setText(text: "Prices")

        let searchFlight3:IconFunc = IconFunc()
        searchFlight3.titleLabel.setText(text: "QuangTuan")
        
        
        searchFlight.setBgColor(UIColor.clear)
        searchFlight1.setBgColor(UIColor.clear)
        searchFlight2.setBgColor(UIColor.clear)
        
        let panelView:TTBaseUIStackView = TTBaseUIStackView(axis: .horizontal, spacing: XSize.P_CONS_DEF, alignment: .fill, distributionValue: .fillEqually)
        panelView.setBackgroundColorByView(color: UIColor.white, conerRadius: 4)
        panelView.setConerRadius(with: XSize.CORNER_RADIUS)
        
        panelView.addArrangedSubview(searchFlight)
        panelView.addArrangedSubview(searchFlight1)
        panelView.addArrangedSubview(searchFlight2)
        panelView.addArrangedSubview(searchFlight3)
    
        self.view.addSubview(panelView)
        
    
        panelView.setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF).setcenterYAnchor(constant: 0).done()
        
        
        let concurrentQueue = DispatchQueue(label: "concurrentQueue", qos: .default, attributes: .concurrent)
        concurrentQueue.async {
            for _ in 1...3 {
                print("concurrentQueue 1")
            }
        }
        
        concurrentQueue.async {
            for _ in 1...3 {
                print("concurrentQueue 2")
            }
        }
        
        let serialQueue = DispatchQueue(label: "serialQueue")
        serialQueue.async {
            for _ in 1...10000 {
                print("serialQueue 1")
            }
        }
        
        serialQueue.async {
            for _ in 1...3 {
                print("serialQueue 2")
            }
        }

        
    }


}


open class IconCircleView: TTBaseUICricleView {
    
    var iconUIImage:TTBaseUIImageFontView = TTBaseUIImageFontView(withFontIconLightSize: .user, sizeIcon: CGSize.init(width: 60, height: 60), colorIcon: UIColor.white, contendMode: .scaleAspectFill)
    
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        
        self.backgroundColor = XView.buttonBgDef
        
        self.addSubview(self.iconUIImage)
        
        self.iconUIImage.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.6).isActive = true
        self.iconUIImage.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.6).isActive = true
        self.iconUIImage.setcenterYAnchor(constant: 0).setCenterXAnchor(constant: 0).done()
        
    }
    
}


class IconFunc :TTBaseUIView {
    
    var iconUIImage:IconCircleView = IconCircleView()
    var titleLabel:TTBaseUILabel = TTBaseUILabel(withType: .TITLE, text: "Function", align: .center)
    
    override func updateBaseUIView() {
        self.addSubview(self.iconUIImage)
        self.addSubview(self.titleLabel)
        self.setupContraints()
    }
    
    
    fileprivate func setupContraints() {
        self.iconUIImage.setWidthAnchor(constant: XSize.H_ICON).setHeightAnchor(constant: XSize.H_ICON)
        self.iconUIImage.setTopAnchor(constant: XSize.P_CONS_DEF).setCenterXAnchor(constant: 0).done()
        
        self.titleLabel.setVerticalContentHuggingPriority()
            .setLeadingAnchor(constant: XSize.P_CONS_DEF).setTrailingAnchor(constant: XSize.P_CONS_DEF)
            .setTopAnchorWithAboveView(nextToView: self.iconUIImage, constant: XSize.P_CONS_DEF)
            .setBottomAnchor(constant: XSize.P_CONS_DEF)
    }
    
}

