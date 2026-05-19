//
//  BaseEqualHeightGridView.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 18/5/26.
//


import Foundation
import SwiftUI
// PreferenceKey trả về chiều cao lớn nhất trong các giá trị được gửi lên
private struct MaxHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

public struct TTBaseEqualHeightGridView<Content: View, T: Identifiable>: View {
    
    public var items: [T]
    public var columns: [GridItem]
    public var spacing: CGFloat = 8
    public var bg: Color = .clear
    public var radius: CGFloat = 8
    
    @ViewBuilder var content: (T) -> Content

    @State private var maxHeight: CGFloat = 0

    public init(items: [T],
                columns: [GridItem],
                spacing: CGFloat = 8,
                bg: Color = .clear,
                radius: CGFloat = 8,
                @ViewBuilder content: @escaping (T) -> Content) {
        self.items = items
        self.columns = columns
        self.spacing = spacing
        self.bg = bg
        self.radius = radius
        self.content = content
    }

    public var body: some View {
        if #available(iOS 16.0, *) {
            TTBaseSUILazyVGrid(columns: columns, spacing: spacing, bg: bg, radius: radius) {
                ForEach(items) { item in
                    content(item)
                }
            }
        } else {
            TTBaseSUILazyVGrid(columns: columns, spacing: spacing, bg: bg, radius: radius) {
                ForEach(items) { item in
                    content(item)
                        .background(
                            GeometryReader { geo in
                                Color.clear
                                    .preference(key: MaxHeightPreferenceKey.self, value: geo.size.height)
                            }
                        )
                        .frame(height: maxHeight > 0 ? maxHeight : .infinity)
                }
            }
            .onPreferenceChange(MaxHeightPreferenceKey.self) { value in
                if value > 0 {
                    maxHeight = value
                }
            }
        }
    }
}
