//
//  TTBaseDebugKit.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 25/7/25.
//

import Foundation
import UIKit
import UIKit
import PencilKit

fileprivate class DrawingViewController: UIViewController {
    var image: UIImage
    var onFinish: ((UIImage) -> Void)?

    private let canvasView = PKCanvasView()

    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        // Background image
        let bgImageView = UIImageView(image: image)
        bgImageView.frame = view.bounds
        bgImageView.contentMode = .scaleAspectFit
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(bgImageView)

        // Canvas view
        canvasView.frame = view.bounds
        canvasView.backgroundColor = .clear

        // Gán công cụ vẽ mới
        canvasView.tool = PKInkingTool(.pen, color: .red, width: 10)
        
        if #available(iOS 14.0, *) {
            canvasView.drawingPolicy = .anyInput
        } else {
            // Fallback on earlier versions
        }
        canvasView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(canvasView)

        // iOS 14+: hiển thị tool picker
        if #available(iOS 14.0, *) {
            if (self.view.window ?? UIApplication.shared.windows.first) != nil {
                let toolPicker = PKToolPicker()
                toolPicker.setVisible(true, forFirstResponder: canvasView)
                toolPicker.addObserver(canvasView)
                canvasView.becomeFirstResponder()
            }
        }

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneTapped))
    }

    @objc func doneTapped() {
        let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
        let finalImage = renderer.image { ctx in
            view.layer.render(in: ctx.cgContext)
        }
        dismiss(animated: true) {
            self.onFinish?(finalImage)
        }
    }
}

public extension UIViewController {
    
    func captureScreenshot() -> UIImage? {
           let renderer = UIGraphicsImageRenderer(size: view.bounds.size)
           return renderer.image { context in
               view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
           }
       }
    
    func presentDrawAndShare(image:UIImage?) {
        guard let _image = image else { return }

        let drawVC = DrawingViewController(image: _image)
        let nav = UINavigationController(rootViewController: drawVC)

        drawVC.onFinish = { finalImage in
            self.runOnMainThread {
                UIPasteboard.general.image = finalImage
                let activityVC = UIActivityViewController(activityItems: [finalImage, "Kindly check and resolve this issue!"], applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self.view
                self.present(activityVC, animated: true)
            }
        }

        self.present(nav, animated: true)
    }
}


//MARK: Main funcs
public extension UIView {
    
    func onStartRunTTBaseDebugKit() {
        if ( self.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW") as? UIView) == nil {
            
            self.enableTTBaseDebugKit()
            
            let controlView:TTBaseUIView = self.addControlPanelView()
            self.layer.setValue(controlView, forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_CONTROL_VIEW")
            
            self.addSubview(controlView)
            controlView.setLeadingAnchor(constant: 10).setTrailingAnchor(constant: 10)
                .setBottomAnchor(constant: 10, isMarginsGuide: true)
            
            self.layer.setValue(self, forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW")
            
        } else {
            self.disableTTBaseDebugKit()
        }
    }
    
    func enableTTBaseDebugKit() {
        
        self.addDebugOverlay()
        
        for subview in self.subviews {
            if subview.viewWithTag( -321222) == nil {
                subview.enableTTBaseDebugKit()
            }
        }
    }
    
    func disableTTBaseDebugKit() {
        let debugView = self.viewWithTag(-123333)
        
        let oldColor: CGColor = (self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_BORDER_COLOR") as? UIColor ?? UIColor.clear).cgColor
        let oldWidth: CGFloat = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_BORDER_WIDTH") as? CGFloat ?? 0.0
        let oldBound: Bool = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_CLIPS_TO_BOUNDS") as? Bool ?? true
        
        if let oldFrame: CGRect = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_FRAME") as? CGRect {
            debugView?.frame = oldFrame
        }
        
        debugView?.layer.borderColor = oldColor
        debugView?.layer.borderWidth = oldWidth
        debugView?.clipsToBounds = oldBound
        self.viewWithTag(-123321)?.removeFromSuperview()
        self.viewWithTag(-321222)?.removeFromSuperview()
        
        for subview in self.subviews {
            subview.disableTTBaseDebugKit()
        }
        
        if let rootView: UIView = self.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW") as? UIView {
            if let control: TTBaseUIView = rootView.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_CONTROL_VIEW") as? TTBaseUIView {
                control.removeFromSuperview()
            }
        }
        self.layer.setValue(nil, forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW")
    }
}




private var tapActionKey: Void?
private var tapTTBaseDebugKit: UITapGestureRecognizer?

fileprivate extension UIView {
    
    
    func onHiddenBolderAndData() {
        let debugView = self.viewWithTag(-123333)
        
        let oldColor: CGColor = (self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_BORDER_COLOR") as? UIColor ?? UIColor.clear).cgColor
        let oldWidth: CGFloat = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_BORDER_WIDTH") as? CGFloat ?? 0.0
        let oldBound: Bool = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_CLIPS_TO_BOUNDS") as? Bool ?? true
        
        if let oldFrame: CGRect = self.layer.value(forKey: "TTBASE_DEBUGKIT_OLD_FRAME") as? CGRect {
            debugView?.frame = oldFrame
        }
        
        debugView?.layer.borderColor = oldColor
        debugView?.layer.borderWidth = oldWidth
        debugView?.clipsToBounds = oldBound
        self.viewWithTag(-123321)?.removeFromSuperview()
        self.viewWithTag(-321222)?.removeFromSuperview()
        
        for subview in self.subviews {
            subview.onHiddenBolderAndData()
        }
    }
    
    func onTestContraints() {
        if let rootView: UIView = self.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW") as? UIView {
            let allviews = rootView.subviewsRecursive()
            for v in allviews {
                if v.hasAmbiguousLayout {
                    print("⚠️ \(type(of: v)) Ambiguous Layout: \(v.description)")
                    v.backgroundColor = .red.withAlphaComponent(0.7)
                }
            }
        }
    }
    
    func onResetData() {
        if let rootView: UIView = self.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW") as? UIView {
            let allviews = rootView.subviewsRecursive()
            for v in allviews {
                if let labelView = v as? TTBaseUILabel {
                    if labelView.layer.value(forKey: "TTBASE_DEBUGKIT_NAME_UI_LABEL") as? Bool ?? false {
                        //print("onResetData Skip for: \(labelView.text ?? "")")
                    } else {
                        if let oldText: String = labelView.layer.value(forKey: "TTBASE_DEBUGKIT_LABEL_TEXT") as? String {
                            labelView.text = oldText
                        }
                    }
                }
            }
        }
    }
    
    func onTestData() {
        if let rootView: UIView = self.layer.value(forKey: "TTBASE_DEBUGKIT_DEBUGKIT_ROOT_VIEW") as? UIView {
            let allviews = rootView.subviewsRecursive()
            for v in allviews {
                if let labelView = v as? TTBaseUILabel {
                    
                    if labelView.layer.value(forKey: "TTBASE_DEBUGKIT_NAME_UI_LABEL") as? Bool ?? false {
                        //print("onTestData Skip for: \(labelView.text ?? "")")
                    } else {
                        if labelView.layer.value(forKey: "TTBASE_DEBUGKIT_LABEL_TEXT") == nil {
                            labelView.layer.setValue(labelView.text, forKey: "TTBASE_DEBUGKIT_LABEL_TEXT")
                        }
                        let sampleTexts: [String] = [
                            "",
                            "Hello",
                            "Lorem ipsum dolor sit amet",
                            "Lorem ipsum\ndolor sit amet\ncheck how the layout handles text wrapping",
                            "A very very long sentence to check how the layout handles text wrapping A very very long sentence to check how the layout handles text wrapping  A very very long sentence to check how the layout handles text wrapping A very very long sentence to check how the layout handles text wrapping A very very long sentence to check how the layout handles text wrapping  A very very long sentence to check how the layout handles text wrapping",
                            "Multiline\nText\nCheck\nText\nCheck\nText\nCheck\nText\nCheck",
                            "Multiline\nText\nCheck"
                        ]
                        labelView.text = sampleTexts.randomElement() ?? ""
                    }
                }
            }
        }
    }
    
    func addControlPanelView() -> TTBaseUIView {
        
        let titleLabel:TTBaseUILabel = TTBaseUILabel.init(withType: .SUB_TITLE, text: "📐 TTBaseDebugKit\n\(self.getCurrentVCName())", align: .center)
        
        let attributed: NSMutableAttributedString = NSMutableAttributedString()
        attributed.bold("📐 TTBaseDebugKit©\n", textColor: UIColor.white, systemFontsize: TTFont.TITLE_H)
        
        attributed.normal("On \(self.getCurrentVCName())", textColor: UIColor.white, systemFontsize: TTFont.SUB_SUB_TITLE_H)
        
        titleLabel.setMutilLine(numberOfLine: 0, textAlignment: .center, mode: .byTruncatingTail)
        titleLabel.layer.setValue(true, forKey: "TTBASE_DEBUGKIT_NAME_UI_LABEL")
        titleLabel.setTextAttr(with: attributed)
        
        let shareScreen:TTBaseUIButton = TTBaseUIButton(textString: "Share", type: .DEFAULT, isSetSize: false, isSetHeight: false).setBgColor(color: .gray)
        let testData:TTBaseUIButton = TTBaseUIButton(textString: "Test Data", type: .DEFAULT, isSetSize: false, isSetHeight: false).setBgColor(color: .gray)
        let resetData:TTBaseUIButton = TTBaseUIButton(textString: "Reset Data", type: .DEFAULT, isSetSize: false, isSetHeight: false).setBgColor(color: .gray)
        let clearData:TTBaseUIButton = TTBaseUIButton(textString: "Clear", type: .DEFAULT, isSetSize: false, isSetHeight: false).setBgColor(color: .gray)
        let close:TTBaseUIButton = TTBaseUIButton(textString: "Close", type: .WARRING, isSetSize: false, isSetHeight: false).setBgColor(color: .red)
        
        
        let buttonStackView:TTBaseUIStackView = TTBaseUIStackView.init(axis: .horizontal, spacing: 4.0, alignment: .fill, distributionValue: .fillProportionally)
        buttonStackView.addArrangeSubviews(views: [shareScreen, testData, resetData, clearData, close])
        
        
        let bodyStackView:TTBaseUIStackView = TTBaseUIStackView.init(axis: .vertical, spacing: 10.0, alignment: .fill, distributionValue: .fill)
        bodyStackView.addArrangeSubviews(views: [titleLabel, buttonStackView])
        
        titleLabel.setVerticalContentHuggingPriority()
        buttonStackView.setHeightAnchor(constant: TTSize.H_BUTTON * 0.7)
        
        
        close.onTouchHandler = { _ in
            self.onResetData()
            self.disableTTBaseDebugKit()
        }
        
        clearData.onTouchHandler = { _ in
            self.onHiddenBolderAndData()
        }
        
        shareScreen.onTouchHandler = { _ in
            self.runOnMainThread {
                if let topVC = UIApplication.topViewController() {
                    topVC.presentDrawAndShare(image: topVC.captureScreenshot())
                }
            }
        }
        
        testData.onTouchHandler = { _ in
            self.onTestData()
        }
        
        resetData.onTouchHandler = { _ in
            self.onResetData()
        }
        
        let panel:TTBaseUIView = TTBaseUIView()
        panel.setBgColor(UIColor.black.withAlphaComponent(0.8)).setConerDef()
        panel.addSubviews(views: [bodyStackView])
        bodyStackView.setFullContraints(constant: TTSize.P_CONS_DEF)
        return panel
    }
    
    func addDebugOverlay(color: UIColor = .red, labelText: String? = nil) {
        
        self.layer.setValue(UIColor(cgColor: self.layer.borderColor ?? UIColor.clear.cgColor), forKey: "TTBASE_DEBUGKIT_OLD_BORDER_COLOR")
        self.layer.setValue(self.layer.borderWidth, forKey: "TTBASE_DEBUGKIT_OLD_BORDER_WIDTH")
        self.layer.setValue(self.clipsToBounds, forKey: "TTBASE_DEBUGKIT_OLD_CLIPS_TO_BOUNDS")
        self.layer.setValue(self.frame, forKey: "TTBASE_DEBUGKIT_OLD_FRAME")
        
        self.tag = -123333
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 1.0
        self.clipsToBounds = false
        
        print(self)
        
        
        let nameDebugLabel = TTBaseUILabel.init(withType: .SUB_SUB_TILE, text: String(describing: type(of: self)), align: .left)
        nameDebugLabel.font = .boldSystemFont(ofSize: 10.0)
        nameDebugLabel.backgroundColor = UIColor.black.withAlphaComponent(0.99)
        nameDebugLabel.textColor = .white
        nameDebugLabel.tag = -321222
        nameDebugLabel.layer.setValue(true, forKey: "TTBASE_DEBUGKIT_NAME_UI_LABEL")
        nameDebugLabel.isUserInteractionEnabled = false
        let panelTouch:TTBaseUIView = TTBaseUIView()
        panelTouch.tag = -123321
        panelTouch.addSubview(nameDebugLabel)
        
        self.addSubview(panelTouch)
        
        nameDebugLabel.setFullContentHuggingPriority(priority: .defaultHigh)
        nameDebugLabel.setFullContraints(view: panelTouch, lead: 2, trail: 30, top: 2, bottom: 30)
        
        panelTouch.setBgColor(UIColor.clear)
        panelTouch.setLeadingAnchor(self, constant: 0).setTopAnchor(self, constant: 0)
        panelTouch.layer.zPosition = 99999
        panelTouch.onTap {
            DispatchQueue.main.async {
                let className:String =  String(describing: type(of: self))
                let message =
                    """
                    📦 ViewController: \(self.getCurrentVCName())\n
                    🧩 SuperView: \(self.superviewHierarchyDescription())
                    🔢 Frame: \(self.frame)
                    📦 ViewHierarchy: \(self.printViewHierarchy(self))\n
                    """
                self.debugSnapshot()
                UIApplication.topViewController()?.showAlert( message, andTitle: className)
            }
        }
    }
    
    func printViewHierarchy(_ view: UIView, level: Int = 0) {
        let indent = String(repeating: "–", count: level)
        print("\(indent)\(type(of: view)) frame: \(view.frame)")
        for subview in view.subviews {
            printViewHierarchy(subview, level: level + 1)
        }
    }
    
    @objc private func handleUIViewTap() {
        if let action = objc_getAssociatedObject(self, &tapActionKey) as? () -> Void {
            action()
        }
    }
}

public extension UIView {
    
    func onTap(_ handler: @escaping () -> Void) {
        isUserInteractionEnabled = true
        
        // Gán closure vào associated object
        objc_setAssociatedObject(self, &tapActionKey, handler, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        
        // Xoá các gesture cũ cùng loại (tránh double tap)
        gestureRecognizers?
            .filter { $0 is UITapGestureRecognizer }
            .forEach { removeGestureRecognizer($0) }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleUIViewTap))
        addGestureRecognizer(tapGesture)
    }
    
    func parentVC() -> UIViewController? {
        var responder: UIResponder? = self
        
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        
        return nil
    }
    
    func getCurrentVCName() -> String {
        if let vc = self.parentVC() {
            return NSStringFromClass(vc.classForCoder)
        }
        return ":("
    }
    
    func debugLog(_ message: String, file: String = #file, function: String = #function, line: Int = #line) -> String {
        let fileName = (file as NSString).lastPathComponent
        return "\n [\(fileName):\(line)] \(function) → \(message)"
    }
    
    func superviewHierarchyDescription() -> String {
        var description = "🔍 Superview hierarchy of \(type(of: self)):\n"
        var current = self.superview
        var level = 1
        
        while let view = current {
            let indent = String(repeating: "→ ", count: level)
            description += "\(indent)\(type(of: view))\n"
            current = view.superview
            level += 1
            if description.contains("UIViewController") { return description }
        }
        
        return description
    }
    
    func debugSnapshot() {
        print("🔢 TTBaseUIKit DebugKit ===================================")
        print("🧩 View: \(type(of: self))")
        print("📦 View : \(NSStringFromClass(self.classForCoder))")
        print("📦 ViewController: \(self.getCurrentVCName())")
        print("🧩 SuperView: \(self.superviewHierarchyDescription())")
        print("📦 Path: \(self.debugLog("Path"))")
        print("📦 Path: \(self.superview?.debugLog("Path") ?? "")")
        
        
        print("🔢 Frame: \(frame)")
        print("📦 Superview: \(String(describing: superview))")
        
        print("📦 ViewHierarchy: \(self.printViewHierarchy(self))")
        
        let stack = Thread.callStackSymbols.prefix(10).joined(separator: "\n")
        print("📜 Stack:\n\(stack)")
        
        for constraint in self.constraints {
            print("📦 Contrains: \(constraint)")
        }
    }
    
    
}
