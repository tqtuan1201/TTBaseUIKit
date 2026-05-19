//
//  SUIView+Extensions.swift
//  TMS_APP
//
//  Created by TuanTruong on 7/11/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation
import SwiftUI
import TTBaseUIKit

extension View {
    func addTestLayout() -> some View {
        if EnvironmentsConfig.IS_TEST_LAYOUT {
            return self.background(Color.random)
        } else {
            return self.background(Color.clear)
        }
    }
}

extension Color {
    static var testLayoutColor: Color {
        if EnvironmentsConfig.IS_TEST_LAYOUT {
            return Color.random
        } else {
            return Color.clear
        }
    }
}


extension SizeConfig {
    func getPadding() -> CGFloat {
        return XSize.P_CONS_DEF * 2
    }
}
