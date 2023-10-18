//
//  TTBaseSUISpacer.swift
//
//
//  Created by TuanTruong on 17/10/2023.
//

import SwiftUI

public struct TTBaseSUISpacer: View {
    
    public var maxWidth:CGFloat? = nil
    public var maxHeight:CGFloat? = nil
    public var viewDefBgColor: Color = TTBaseUIKitConfig.getViewConfig().viewStackDefColor
    public var viewDefCornerRadius: CGFloat = 0

    public init() {
    }
    
    public init(maxHeight: CGFloat? = nil) {
        self.maxHeight = maxHeight
    }
    
    public init(maxWidth: CGFloat? = nil) {
        self.maxWidth = maxWidth
    }
    
    public init(maxWidth: CGFloat? = nil, maxHeight:CGFloat?) {
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }
    
    public init(withBg bg:Color, radius:CGFloat, maxWidth: CGFloat) {
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.maxWidth = maxWidth
    }

    public init(withBg bg:Color, radius:CGFloat, maxHeight: CGFloat) {
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.maxHeight = maxHeight
    }
    
    public init(withBg bg:Color, radius:CGFloat, maxWidth: CGFloat? = nil, maxHeight:CGFloat? = nil) {
        self.viewDefBgColor = bg
        self.viewDefCornerRadius = radius
        self.maxWidth = maxWidth
        self.maxHeight = maxHeight
    }

    public var body: some View {
        Rectangle()
            .foregroundColor(self.viewDefBgColor)
            .frame(maxWidth: self.maxWidth, maxHeight: self.maxHeight)
            .cornerRadius(self.viewDefCornerRadius)
    }
    
}

//MARK: Demo

struct TTBaseSUISpacerVerDemo : View {
    var body: some View {
        VStack(alignment: .center, spacing: 10.0) {
            Text("Top View").padding().background(Color.pink).cornerRadius(8.0)
            
            TTBaseSUISpacer(withBg: .green.opacity(0.2), radius: 8.0) // Expands to fill available space
            
            Text("Middle View").padding().background(Color.blue).cornerRadius(8.0)
            
            //Spacer().frame(height: 90) // Creates a fixed height for the spacer
            TTBaseSUISpacer(withBg: .gray.opacity(0.2), radius: 8.0, maxHeight: 40.0)
            
            Text("Bottom View").padding().background(Color.gray).cornerRadius(8.0)
        }
    }
}

struct TTBaseSUISpacerHorDemo : View {
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 10.0) {
                Text("Top View").padding().background(Color.pink).cornerRadius(8.0)
                TTBaseSUISpacer(withBg: .green.opacity(0.2), radius: 8.0) // Expands to fill available space
            }
            HStack(alignment: .center, spacing: 10.0) {
                TTBaseSUISpacer(withBg: .green.opacity(0.2), radius: 8.0) // Expands to fill available space
                Text("Center View").padding().background(Color.pink).cornerRadius(8.0)
            }
            HStack(alignment: .center, spacing: 10.0) {
                Text("Bottom View").padding().background(Color.pink).cornerRadius(8.0)
                TTBaseSUISpacer(withBg: .green.opacity(0.3), radius: 8.0) // Expands to fill available space
                TTBaseSUISpacer(withBg: .blue.opacity(0.3), radius: 8.0, maxWidth: 20.0)
                TTBaseSUISpacer(withBg: .red.opacity(0.3), radius: 8.0) // Expands to fill available space
            }
        }
    }
}

struct TTBaseSUISpacer_Previews: PreviewProvider {
    static var previews: some View {
        TTBaseSUISpacerHorDemo()
        .frame(maxWidth: .infinity)
        .cornerRadius(8.0)
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
