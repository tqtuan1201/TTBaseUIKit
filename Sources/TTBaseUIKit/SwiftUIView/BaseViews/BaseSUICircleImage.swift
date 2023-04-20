//
//  SwiftUIView.swift
//  
//
//  Created by Tuan Truong Quang on 4/17/23.
//

import SwiftUI


public struct TTBaseSUICircleImage: View {
    
    public var imageName: String = Config.Value.noImageName
    public var radius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_IMAGE
    public var contentMode: ContentMode = .fill

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
    
    public var body: some View {
        self.image
        .resizable()
        .aspectRatio(contentMode: self.contentMode)
        .clipShape(Circle())
    }
}

//MARK: Previews
 fileprivate struct DemoTTBaseSUICircleImage: View {
    var body: some View {
        TTBaseSUIView(content: {
            VStack {
                Text("TTBaseSUICircleImage")
                TTBaseSUICircleImage()
                    .frame(width: 200, height: 200, alignment: .center)
            }
        })
    }
}

struct DemoTTBaseSUICircleImage_Previews: PreviewProvider {
    static var previews: some View {
        DemoTTBaseSUICircleImage()
    }
}


