# SwiftUI Component Template

```swift
struct <#ComponentName#>: View {
    let title: String

    var body: some View {
        TTBaseSUIHStack(spacing: TTSize.P_S) {
            TTBaseSUIImage(name: "icon")
                .sizeSquare(width: TTSize.H_SMALL_ICON)
            TTBaseSUIText(withType: .TITLE, text: title)
        }
        .pAll(TTSize.P_S)
        .bg(byUIColor: TTView.viewDefColor)
        .corner(byDef: TTSize.CORNER_RADIUS)
    }
}
```
