//
//  BaseUIProgressView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/13/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseUIProgressView: UIProgressView {
    open var periodValue:Float { get { return 0.004 } }
    
    fileprivate var timer:Timer?
    fileprivate var numberOfProcess:Float = 0
    fileprivate var processing:Float = 0 {
        didSet{
            DispatchQueue.main.async { [weak self] in self?.progress = (self?.processing ?? 0) }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: .zero)
        self.setupBaseUIView()
    }
    
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK:// For base funcs
extension TTBaseUIProgressView {
    fileprivate func setupBaseUIView() {
        self.setConerRadius(with: 0)
        self.clipsToBounds = false
        self.layer.cornerRadius = 0
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = TTView.processViewBgColor
        self.progressTintColor = TTView.processViewProcessColor
        self.trackTintColor = TTView.processViewTrackColor
    }
    
    @objc fileprivate func setUpdateProcess() {
        UIView.animate(withDuration: 0.2) {
            self.numberOfProcess += self.periodValue
            self.setProgress(self.numberOfProcess, animated: true)
        }
        if self.numberOfProcess > 1 {
            self.numberOfProcess = 0
        }
    }
    
}

//MARK:// For public funcs
extension TTBaseUIProgressView {
    public func onStart() {
        self.processing = 0
        self.timer = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(self.setUpdateProcess), userInfo: nil, repeats: true)
        self.timer?.fire()
    }
    
    public func onFinished() {
        UIView.animate(withDuration: 0.4) { self.setProgress(1, animated: true) }
        self.timer?.invalidate()
    }
}
