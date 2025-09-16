//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 4/13/23.
//

import SwiftUI

public struct TTBaseSUIImage: View {
    
    public var imageName: String = Config.Value.noImageName
    public var radius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_IMAGE
    public var contentMode: ContentMode = .fill
    public var imageColor: Color? = nil
    
    public var image:Image = Image(uiImage: UIImage(fromTTBaseUIKit: "img.NoImage2.png") ?? UIImage())

    public init() {
    }
    
    public init(withname name:String) {
        self.image = Image(name)
    }
    
    public init(withname name:String, conner:CGFloat) {
        self.image = Image(name)
        self.radius = conner
    }
    
    public init(withname name:String, color:Color) {
        self.image = Image(name)
        self.imageColor = color
    }
    
    public init(withname name:String, color:Color, contentMode: ContentMode) {
        self.image = Image(name)
        self.imageColor = color
        self.contentMode = contentMode
    }
    
    public init(withname name:String, contentMode: ContentMode) {
        self.image = Image(name)
        self.contentMode = contentMode
    }
    
    public var body: some View {
        if let _imageColor = self.imageColor {
            self.setIcon(color: _imageColor).aspectRatio(contentMode: self.contentMode)
        } else {
            self.image.resizable().aspectRatio(contentMode: self.contentMode)
        }
    }
}

extension TTBaseSUIImage {
    public func getBaseImage() -> Image {
        return self.image
    }

    public func setIcon(color: Color) -> some View {
        return self.image.resizable().renderingMode(.template).foregroundColor(color)
    }
}

//MARK: Previews
 fileprivate struct DemoTTBaseSUIImage: View {
    var body: some View {
        TTBaseSUIView(content: {
            VStack {
                Text("TTBaseSUIImage")
                TTBaseSUIImage()
                    .scaledToFill()
                    .frame(width: 200, height:200, alignment: .center)
                    //.shadow(color: .black, radius: 10, x: 0, y: 0)
            }
        })
    }
}

struct DemoTTBaseSUIImage_Previews: PreviewProvider {
    static var previews: some View {
        DemoTTBaseSUIImage()
    }
}
