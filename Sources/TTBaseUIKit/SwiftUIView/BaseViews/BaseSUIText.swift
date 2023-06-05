
//
//  TTBaseSUIView.swift
//
//
//  Created by Tuan Truong Quang on 3/14/23.
//

import SwiftUI

/*
struct CustomText<Content: View>: View {
    private let content: String
    private let transform: (Text) -> Content
    
    init(_ content: String, transform: @escaping (Text) -> Content) {
        self.content = content
        self.transform = transform
    }
    
    var body: some View {
        // Apply whatever modifiers from environment, etc.
        let current = Text(content)
        /* ... */
        
        return transform(current)
    }
}
*/

public struct TTBaseSUIText: View {
    
    
    public var textDefColor: Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)
    
    public var textDefHeight: CGFloat = TTBaseUIKitConfig.getFontConfig().TITLE_H
    public var fontDef: UIFont = TTBaseUIKitConfig.getFontConfig().FONT
    public var type:TTBaseUILabel.TYPE = .TITLE
    
    public var align:TextAlignment = .leading
    public var text:String = ""
    public var padding:CGFloat = 0.0
    
    public var isBold:Bool = false
    public var isItalic:Bool = false
      
    public init(withType type:TTBaseUILabel.TYPE = .TITLE, text:String, align:TextAlignment = .leading, color:Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)) {
        self.type = type
        self.align = align
        self.text = text
        self.textDefColor = color
    }
    
    public init(withBold type:TTBaseUILabel.TYPE = .TITLE, text:String, align:TextAlignment = .leading, color:Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)) {
        self.type = type
        self.align = align
        self.text = text
        self.isBold = true
        self.textDefColor = color
    }
    
    public init(withItalic type:TTBaseUILabel.TYPE = .TITLE, text:String, align:TextAlignment = .leading, color:Color = Color(TTBaseUIKitConfig.getViewConfig().textDefColor)) {
        self.type = type
        self.align = align
        self.isItalic = true
        self.textDefColor = color
    }
    
    public var body: some View {
        var currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.TITLE_H)))
        switch self.type {
        case.HEADER_SUPER:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.HEADER_SUPER_H)))
        case .HEADER:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.HEADER_H)))
        case .TITLE:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.TITLE_H)))
        case .SUB_TITLE:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.SUB_TITLE_H)))
        case .SUB_SUB_TILE:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.SUB_SUB_TITLE_H)))
        case .NONE:
            currentText = Text(self.text).font(Font(self.fontDef.withSize(TTFont.TITLE_H)))
        }
        
        if #available(iOS 16.0, *) {
            return currentText.bold(self.isBold).italic(self.isItalic).foregroundColor(self.textDefColor).multilineTextAlignment(self.align)
            // Fallback on earlier versions
        } else {
            if self.isBold { currentText = currentText.bold()}
            if self.isItalic { currentText = currentText.italic()}
            return currentText.foregroundColor(self.textDefColor).multilineTextAlignment(self.align)
        }
    }
}

//MARK: Previews
fileprivate struct DemoTTBaseSUIText: View {
    var body: some View {
        TTBaseSUIView(content: {
            VStack(alignment: .center, spacing: 0) {
                TTBaseSUIText(withType: .HEADER_SUPER, text: "[HEADER_SUPER] The most important thing is to enjoy your life - to be happy - it's all that matters.", align: .center)
                    .foregroundColor(.blue)
                TTBaseSUIText(withType: .HEADER, text: "[HEADER] The most important thing is to enjoy your life - to be happy - it's all that matters.").background(Color.blue)
                    .foregroundColor(.blue)
                    .font(.system(size: 200))
                TTBaseSUIText(withType: .TITLE, text: "[TITLE] The most important thing is to enjoy your life - to be happy - it's all that matters.").background(Color.yellow)
                TTBaseSUIText(withType: .SUB_TITLE, text: "[SUB_TITLE] The most important thing is to enjoy your life - to be happy - it's all that matters.").background(Color.pink)
                TTBaseSUIText(withType: .SUB_SUB_TILE, text: "[SUB_SUB_TILE] The most important thing is to enjoy your life - to be happy - it's all that matters.")
                    .lineLimit(3)
            }
        })
        .padding()
        .background(Color.gray)
    }
}

struct DemoTTBaseSUIText_Previews: PreviewProvider {
    static var previews: some View {
        DemoTTBaseSUIText()
    }
}


