//
//  General+Config.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 4/11/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit


public final class Fonts {
    
    static func podFont(name: String, size: CGFloat) -> UIFont? {
        //Why do extra work if its available.
        if let font = UIFont(name: name, size: size) {return font}
        
        let bundle = Bundle(for: Fonts.self) //get the current bundle
        
        var urlBundle:URL?
        
        // For test local
        if let url = bundle.url(forResource: name, withExtension: "ttf") {
            urlBundle = url
        }
        // If this framework is added using CocoaPods, resources is placed under a subdirectory
        if let url = bundle.url(forResource: name, withExtension: "ttf", subdirectory: "TTBaseUIKit.bundle") {
            urlBundle = url
            TTBaseFunc.shared.printLog(object: "::Fonts podFont applied by CocoaPods TTBaseUIKit.bundle")
        }
        
        if let url = bundle.url(forResource: name, withExtension: "ttf", subdirectory: "Frameworks/TTBaseUIKit.framework") {
            urlBundle = url
            TTBaseFunc.shared.printLog(object: "::Fonts podFont applied by CocoaPods Frameworks/TTBaseUIKit.framework")
        }
        if let urlPackage =  Bundle.module.url(forResource: name, withExtension: "ttf") {
            urlBundle = urlPackage
            TTBaseFunc.shared.printLog(object: "::Fonts podFont applied by urlPackage Bundle.module.url")
        }
        
        TTBaseFunc.shared.printLog(object: "::Fonts podFont urlBundle: \(String(describing: urlBundle))")
        
        guard let url = urlBundle else { return nil }
        guard let data = NSData(contentsOf: url) else { return nil }
        guard let provider = CGDataProvider(data: data) else { return nil } //convert the data into a provider
        guard let cgFont = CGFont(provider) else { return nil }//convert provider to cgfont
        let fontName = cgFont.postScriptName as String?  ?? ""//crashes if can't get name
        CTFontManagerRegisterGraphicsFont(cgFont, nil) //Registers the font, like the plist
        
        TTBaseFunc.shared.printLog(object: "::Fonts podFont fontName: \(fontName)")
        
        return UIFont(name: fontName, size: size)
    }
}


extension UIFont {
    
    public static func getFontIcon(ProWithSize size:CGFloat) -> UIFont? {
        return Fonts.podFont(name: Config.Value.fontImageNamePro, size: size)
    }
    public static func getFontIcon(FreeWithSize size:CGFloat) -> UIFont? {
        return Fonts.podFont(name: Config.Value.fontImageNameFree, size: size)
    }
}

extension UISegmentedControl {
    public func removeBorders(withColor nornal:UIColor, selected:UIColor, hightLight:UIColor) {
        setBackgroundImage(imageWithColor(color: nornal), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: hightLight), for: .highlighted, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: selected), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.clear), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    // create a 1x1 image with this color
    private func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width:  1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor);
        context!.fill(rect);
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!
    }
}


extension UIImage {

    /// to rotate root image by degree
    ///
    public static func imageRotatedByDegrees(oldImage: UIImage, deg degrees: CGFloat) -> UIImage {
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x: 0, y: 0, width: oldImage.size.width, height: oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat.pi / 180)
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat.pi / 180))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x: -oldImage.size.width / 2, y: -oldImage.size.height / 2, width: oldImage.size.width, height: oldImage.size.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    /// to rotate root image by radians
    ///
    public func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    public class func resizeImage(_ image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContextWithOptions(CGSize(width: newWidth, height: newHeight), false,  UIScreen.main.scale)
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return (newImage ?? UIImage())
    }
    
    public static func fontAwesomeIconWithName(nameString: String, size: CGSize, iconColor: UIColor, backgroundColor: UIColor = UIColor.clear) -> UIImage? {
        
        TTBaseFunc.shared.printLog(object: "::fontAwesomeIconWithName nameString: \(nameString)")
        #if targetEnvironment(macCatalyst)
            return nil
        #else
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = NSTextAlignment.center
            
            if nameString.contains("") { return nil }
            // Taken from FontAwesome.io's Fixed Width Icon CSS
            let fontAspectRatio: CGFloat = 1.28571429
            
            let fontSize = min(size.width / fontAspectRatio, size.height)
        guard let fontName:UIFont = UIFont.getFontIcon(ProWithSize: fontSize) else { return nil}
        
            TTBaseFunc.shared.printLog(object: "::fontAwesomeIconWithName fontName:UIFont: \(fontName)")
        
            let attributedString = NSAttributedString(string: nameString, attributes: [NSAttributedString.Key.font: fontName, NSAttributedString.Key.foregroundColor: iconColor, NSAttributedString.Key.backgroundColor: backgroundColor, NSAttributedString.Key.paragraphStyle: paragraph])
            UIGraphicsBeginImageContextWithOptions(size, false , 0.0)
            attributedString.draw(in: CGRect(x: 0, y: (size.height - fontSize) / 2, width: size.width, height: fontSize))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image
        #endif
    }
    
    public convenience init?(fromTTBaseUIKit name:String) {
         let url = Bundle(for: Fonts.self).url(forResource: name, withExtension: "", subdirectory: "TTBaseUIKit.bundle")
         self.init(named: url?.path ?? "")
         self.accessibilityIdentifier = name
    }
    
    public static func noImage() -> UIImage? {
        let image = UIImage(fromTTBaseUIKit: Config.Value.noImageName)
        image?.accessibilityIdentifier = Config.Value.noImageName
        return image
    }
    
    public static func logoDef() -> UIImage? {
        let image = UIImage(fromTTBaseUIKit: Config.Value.logoDefName)
        image?.accessibilityIdentifier = Config.Value.logoDefName
        return image
    }
    
    public static func noImageOption1() -> UIImage? {
        let image = UIImage(fromTTBaseUIKit: "img.NoImage1.png")
        image?.accessibilityIdentifier = "img.NoImage1.png"
        return image
    }
    public static func noImageOption2() -> UIImage? {
        let image = UIImage(fromTTBaseUIKit: "img.NoImage2.png")
        image?.accessibilityIdentifier = "img.NoImage2.png"
        return image
    }
    
    public func tinted(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate).draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    public func addImagePadding(x: CGFloat, y: CGFloat) -> UIImage? {
        let width: CGFloat = size.width + x
        let height: CGFloat = size.height + y
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0)
        let origin: CGPoint = CGPoint(x: (width - size.width) / 2, y: (height - size.height) / 2)
        draw(at: origin)
        let imageWithPadding = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageWithPadding
    }
    
}

extension UIImageView {
    public static func viewNoImage() -> UIImageView {
        let imageView:UIImageView = UIImageView()
        imageView.image = UIImage(fromTTBaseUIKit: Config.Value.noImageName)
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

//MARK:// NSMutableAttributedString
extension NSMutableAttributedString {
    
    @discardableResult public func addStypeForExistText(_ text: String, textColor:UIColor, systemFontsize:CGFloat, weight: UIFont.Weight)  -> NSMutableAttributedString {
        
        guard let substringRange = self.string.range(of: text) else { return self}
        let nsRange = NSRange(substringRange, in: self.string)
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: systemFontsize, weight: weight), .foregroundColor : textColor]
        self.addAttributes(attrs, range: nsRange)
        return self
    }
    
    @discardableResult public func addBoldStypeForExistText(_ text: String, textColor:UIColor, systemFontsize:CGFloat)  -> NSMutableAttributedString {
        
        guard let substringRange = self.string.range(of: text) else { return self}
        let nsRange = NSRange(substringRange, in: self.string)
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: systemFontsize, weight: .bold), .foregroundColor : textColor]
        self.addAttributes(attrs, range: nsRange)
        return self
    }
    
    @discardableResult public func addStrikethroughStypeForExistText(_ text: String, textColor:UIColor, systemFontsize:CGFloat)  -> NSMutableAttributedString{
        
        guard let substringRange = self.string.range(of: text) else { return self}
        let nsRange = NSRange(substringRange, in: self.string)
        
        var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)]
        attrs[.font] = UIFont.systemFont(ofSize: systemFontsize)
        attrs[.foregroundColor] = textColor
        self.addAttributes(attrs, range: nsRange)
        return self
    }
    
    @discardableResult public func textStyle(withText text: String, textColor:UIColor, font:UIFont) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor : textColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult public func bold(_ text: String, textColor:UIColor, systemFontsize:CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: systemFontsize, weight: .bold), .foregroundColor : textColor]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult public func normal(_ text: String, textColor:UIColor, systemFontsize:CGFloat) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: systemFontsize, weight: .regular), .foregroundColor : textColor]
        let nomalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(nomalString)
        
        return self
    }
    
    @discardableResult public func strikethrough(_ text: String, textColor:UIColor, systemFontsize:CGFloat) -> NSMutableAttributedString {
        var attrs: [NSAttributedString.Key: Any] = [.strikethroughStyle: NSNumber(integerLiteral: NSUnderlineStyle.single.rawValue)]
        attrs[.font] = UIFont.systemFont(ofSize: systemFontsize)
        attrs[.foregroundColor] = textColor
        let nomalString = NSMutableAttributedString(string:text, attributes: attrs)
        append(nomalString)
        
        return self
    }
    
}

//MARK: Data
extension Data {
    @discardableResult public func getTokenByString() -> String {
        let token = self.map { String(format: "%02.2hhx", $0) }.joined()
        return token
    }
}
