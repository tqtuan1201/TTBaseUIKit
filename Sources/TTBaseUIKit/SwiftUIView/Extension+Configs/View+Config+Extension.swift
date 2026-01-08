import Foundation
import SwiftUI

extension UINavigationBarAppearance {
    public func setColor(title: UIColor? = nil, background: UIColor? = nil) {
        configureWithTransparentBackground()
        if let titleColor = title {
            largeTitleTextAttributes = [.foregroundColor: titleColor]
            titleTextAttributes = [.foregroundColor: titleColor]
        }
        backgroundColor = background
        UINavigationBar.appearance().scrollEdgeAppearance = self
        UINavigationBar.appearance().standardAppearance = self
    }
}

extension UIColor {
    public func toColor() -> Color {
        return Color(self)
    }
}

public extension Color {
    static func fromHex(value:String) -> Color {
        return Color(UIColor.init(hexV2: value))
    }
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}

private struct SizePreferenceKey: PreferenceKey {
  static var defaultValue: CGSize = .zero
  static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

private struct ViewFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

public extension View {

    func maxWidth(alignment:Alignment = .center) -> some View {
        return self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func maxHeight(alignment:Alignment = .center) -> some View {
        return self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func bg(byDef def:Color = TTBaseUIKitConfig.getViewConfig().viewDefColor.toColor()) -> some View {
        return self.background(def)
    }
    
    func size(width:CGFloat)  -> some View {
        return self.frame(width: width)
    }
    
    func size(height:CGFloat)  -> some View {
        return self.frame(height: height)
    }
    
    func size(width:CGFloat, height:CGFloat)  -> some View {
        return self.frame(width: width, height: height)
    }
    
    func sizeSquare(width:CGFloat)  -> some View {
        return self.frame(width: width, height: width)
    }
    
    func bg(byUIColor color:UIColor = TTBaseUIKitConfig.getViewConfig().viewDefColor) -> some View {
        return self.bg(byDef: color.toColor())
    }

    @ViewBuilder func hidden(_ shouldHide: Bool) -> some View {
        switch shouldHide {
        case true: self.hidden()
        case false: self
        }
    }
    
    @ViewBuilder func bgByView<Content>(@ViewBuilder content: () -> Content, align:Alignment = .center) -> some View where Content : View {
        if #available(iOS 15.0, *) {
            self.background(alignment: align, content: content)
        } else {
            // Fallback on earlier versions
            self.background(content(), alignment: align)
        }
    }
}

public extension View {
    
    func onTapHandle(action:@escaping ( () -> ())) -> some View {
        self.gesture( TapGesture().onEnded(action) )
    }
    
    func corner(byDef conner:CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_BUTTON, antialiased:Bool = true) -> some View {
        return self.cornerRadius(conner, antialiased: antialiased)
    }

    func detectSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
              Color.clear.disabled(true)
              .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
          }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
    
    func detectFrame(onChange: @escaping (CGRect) -> Void) -> some View {
        background(
          GeometryReader { geometryProxy in
              Color.clear.disabled(true)
                .preference(key: ViewFrameKey.self, value: geometryProxy.frame(in: .global))
          }
        )
        .onPreferenceChange(ViewFrameKey.self, perform: onChange)
    }
    
    
    @ViewBuilder func enableGlassEffect<Content>(cornerRadius:CGFloat? = nil, @ViewBuilder content: () -> Content, align:Alignment = .center) -> some View where Content : View {      
        #if compiler(>=6.2)
                if #available(iOS 26.0, *) {
                    if let _cornerRadius = cornerRadius {
                        self.corner(byDef: _cornerRadius).glassEffect(Glass.clear, in: RoundedRectangle(cornerRadius:_cornerRadius))
                    } else {
                        self.glassEffect(Glass.clear)
                    }
                } else {
                    if #available(iOS 15.0, *) {
                        self.background(alignment: align, content: content)
                    } else {
                        self.background( content() )
                    }
                }
        #else
                if #available(iOS 15.0, *) {
                    self.background(alignment: align, content: content)
                } else {
                    self.background( content() )
                }
        #endif
    }
    
    @ViewBuilder func skeleton(active: Bool = true, isShimmering:Bool = true, isLight:Bool = true) -> some View {
        if active {
            if isShimmering {
                self.redacted(reason: .placeholder).shimmering(active: active, gradient: isLight ? Shimmer.defaultLightViewGradient : Shimmer.defaultGradient)
            } else {
                self.redacted(reason: .placeholder)
            }
        } else {
            self.unredacted()
        }
    }
    
    @ViewBuilder func skeleton(active: Bool = true, isShimmering:Bool = true, animation: Animation = Shimmer.defaultAnimation, gradient: Gradient = Shimmer.defaultGradient, bandSize:CGFloat = 0.28) -> some View {
        if active {
            if isShimmering {
                self.redacted(reason: .placeholder).shimmering(active: active, animation: animation, gradient: gradient, bandSize: bandSize)
            } else {
                self.redacted(reason: .placeholder)
            }
        } else {
            self.unredacted()
        }
    }
    
}
