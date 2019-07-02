import UIKit
import Foundation

protocol BorderDrawer {
    var borderDefColor: UIColor { get }
    var borderDefWidth: CGFloat { get }
}

protocol ViewDrawer {
    var viewDefBgColor: UIColor { get }
    var viewDefCornerRadius: CGFloat { get }
}

protocol SkeletonMarkView {

}

protocol TextDrawer {
    var textDefColor: UIColor { get }
    var textDefHeight: CGFloat { get }
    var textDefIsUpper:Bool { get }
    var fontDef:UIFont { get }
}

protocol CircleDrawer {
    
}

extension CircleDrawer where Self: UIView {
    func drawCircle() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.width/2
    }
}
extension BorderDrawer where Self: UIView {
    
    func drawBorder() {
        self.layer.borderColor = borderDefColor.cgColor
        self.layer.borderWidth = borderDefWidth
    }
}



extension ViewDrawer where Self: UIView {
    
    func drawView() {
        self.backgroundColor       = viewDefBgColor
        self.layer.cornerRadius    = viewDefCornerRadius
        self.clipsToBounds         = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension SkeletonMarkView where Self: UIView {
    
    func drawSkeletonView() {
        if self.viewWithTag(CONSTANT.TAG_VIEW.MARK_SKELETON.rawValue) != nil { return }
        let skeletonMarkView:TTBaseSkeletonMarkView = TTBaseSkeletonMarkView()
        skeletonMarkView.viewWithTag(CONSTANT.TAG_VIEW.MARK_SKELETON.rawValue)
        self.addSubview(skeletonMarkView)
        skeletonMarkView.setFullContraints(constant: 0)
    }
    
    func removeSkeletonView() {
        self.viewWithTag(CONSTANT.TAG_VIEW.MARK_SKELETON.rawValue)?.removeFromSuperview()
    }
}

extension TextDrawer where Self: UILabel {
    
    func drawLable() {
        
        self.textColor             = textDefColor
        self.font                  = fontDef
        self.text                  = textDefIsUpper ? text?.uppercased() : text
        self.textAlignment         = .center
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clear
    }
}

extension TextDrawer where Self: UITextView {
    
    func drawTextView() {
        
        self.font                  = fontDef
        self.textColor             = textDefColor
        self.text                  = textDefIsUpper ? text?.uppercased() : text
        self.textAlignment         = .left
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension TextDrawer where Self: UIButton {
    
    func drawButton() {
        self.titleLabel?.font                  = fontDef
        self.titleLabel?.textColor             = textDefColor
        self.titleLabel?.text                  = textDefIsUpper ? self.titleLabel?.text?.uppercased() : self.titleLabel?.text
        self.setTitleColor(textDefColor, for: UIControl.State.normal)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}

