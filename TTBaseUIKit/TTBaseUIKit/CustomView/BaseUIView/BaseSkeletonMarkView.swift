//
//  BaseSkeletonMarkView.swift
//  TTBaseUIKit
//
//  Created by Truong Quang Tuan on 7/1/19.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import Foundation
import UIKit

open class TTBaseSkeletonMarkView : TTBaseUIView {
    open override func updateBaseUIView() {
        super.updateBaseUIView()
        self.backgroundColor = TTView.viewBgSkeleton
        self.setConerDef()
    }
}
