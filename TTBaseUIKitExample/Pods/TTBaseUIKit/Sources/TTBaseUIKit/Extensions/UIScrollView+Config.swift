//
//  UIScrollView+Config.swift
//  TTBaseUIKit
//
//  Created by Tuan Truong Quang on 10/9/20.
//  Copyright © 2020 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {

    public var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }

    public  var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }

    public var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    public var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return scrollViewBottomOffset
    }

}
