//
//  SwiftUIView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 3/7/25.
//

import SwiftUI
import Foundation

// MARK: - View Padding Helpers
public extension View {
     
    // MARK: All edges
    @inlinable
    
    
    func pAll(_ type:Edge.Set = .all,_ size:CGFloat = TTSize.P_S) -> some View {
        self.padding(type, size)
    }
    
    func pAll(_ size:CGFloat = TTSize.P_S) -> some View {
        self.padding(size)
    }
    
    // MARK: Horizontal
    @inlinable
    func pHorizontal(_ size:CGFloat? = nil) -> some View {
        self.padding(.horizontal, size)
    }

    // MARK: Vertical
    @inlinable
    func pVertical(_ size:CGFloat?) -> some View {
        self.padding(.vertical, size)
    }
    
    
    func fixedByHorizontal() -> some View {
        self.fixedSize(horizontal: true, vertical: false)
    }
    
    func fixedByVertical() -> some View {
        self.fixedSize(horizontal: false, vertical: true)
    }
    
    func fixedByAutoSize() -> some View {
        self.fixedSize(horizontal: true, vertical: true)
    }

    // MARK: Single edge
    @inlinable func pTop(_ size:CGFloat = TTSize.P_S) -> some View { padding(.top,      size) }
    @inlinable func pBottom(_ size:CGFloat = TTSize.P_S) -> some View { padding(.bottom,   size) }
    @inlinable func pLeading(_ size:CGFloat = TTSize.P_S) -> some View { padding(.leading,  size) }
    @inlinable func pTrailing(_ size:CGFloat = TTSize.P_S) -> some View { padding(.trailing, size) }
}
