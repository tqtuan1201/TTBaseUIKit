//
//  General+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit


extension UIImage {
    public convenience init?(fromTTBaseUIKit name:String) {
         self.init(named: "Frameworks/TTBaseUIKit.framework/\(name)")
    }
}

extension UIImageView {
    public static func viewNoImage() -> UIImageView {
        let imageView:UIImageView = UIImageView()
        imageView.image = UIImage(fromTTBaseUIKit: "img.NoImage.png")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

extension CGFloat {
    public static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension CALayer {
    
    public func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        border.name = "BORDER"
        switch edge {
        case UIRectEdge.top:
            border.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.bottom:
            border.frame = CGRect(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            break
        case UIRectEdge.left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: self.frame.height)
            break
        case UIRectEdge.right:
            border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        default:
            //For Center Line
            border.frame = CGRect(x: self.frame.width/2 - thickness, y: 0, width: thickness, height: self.frame.height)
            break
        }
        border.name = "BORDER." + edge.rawValue.description
        border.backgroundColor = color.cgColor;
        self.addSublayer(border)
    }
}

