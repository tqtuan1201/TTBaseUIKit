//
//  CoverVerticalPresentationController.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 5/30/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTCoverVerticalPresentationController: TTBasePresentationController {
    
    open var inset:CGFloat { get { return 0 } }
    open var isAddSafeArea:Bool { get { return false}}
    
    open override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView, let presentedView = presentedView else { return .zero }
        
        // Make sure to account for the safe area insets
        var safeAreaFrame = containerView.bounds
        if self.isAddSafeArea {
            if #available(iOS 11.0, *) {
                safeAreaFrame = safeAreaFrame.inset(by: containerView.safeAreaInsets)
            }
        }
        let targetWidth = safeAreaFrame.width - 2 * inset
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize, withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow).height
        
        var frame = safeAreaFrame
        frame.origin.x += inset
        frame.origin.y += frame.size.height - targetHeight - inset
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        return frame
        
    }
    
    open override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    open override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        presentedView?.layer.cornerRadius = 0
    }
}

