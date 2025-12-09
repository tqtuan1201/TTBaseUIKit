//
//  UIColor+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/6/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import UIKit



extension UIColor {
    
    
    public class getColorFromHex: UIColor {
        public convenience init(red: Int, green: Int, blue: Int) {
            assert(red >= 0 && red <= 255, "Invalid red component")
            assert(green >= 0 && green <= 255, "Invalid green component")
            assert(blue >= 0 && blue <= 255, "Invalid blue component")
            
            self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
        }
        public convenience init(netHex:Int) {
            let r = (netHex >> 16) & 0xFF
            let g = (netHex >> 8) & 0xFF
            let b = netHex & 0xFF
            self.init(red: r, green: g, blue: b, alpha: 1)
        }
        
    }
    
    public static var random: UIColor {
        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
    }
    
    public var hexString:String? {
        if let components = self.cgColor.components {
            let r = components[0]
            let g = components[1]
            let b = components[2]
            return  String(format: "#%02x%02x%02x", (Int)(r * 255), (Int)(g * 255), (Int)(b * 255))
        }
        return nil
    }
    
    
    convenience public init(hexFromString:String, alpha:CGFloat = 1.0) {
        self.init(hexV2: hexFromString)
    }
    
    /// Create a color directly from a hex string (e.g. "#FBBF00" or "FBBF00")
    convenience init(hexV2: String) {
        let hexString = hexV2.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hexString.count {
        case 3: // short RGB, e.g. FFF
            (r, g, b) = (
                (int >> 8) * 17,
                (int >> 4 & 0xF) * 17,
                (int & 0xF) * 17
            )
        case 6: // full RGB, e.g. FFFFFF
            (r, g, b) = (
                int >> 16,
                int >> 8 & 0xFF,
                int & 0xFF
            )
        default:
            (r, g, b) = (0, 0, 0)
        }
        self.init(red: Int(r), green: Int(g), blue: Int(b))
    }
    
    convenience public init(red: Int, green: Int, blue: Int, alpha: Int = 1) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}
