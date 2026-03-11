# SwiftUI Screen Template

```swift
struct <#ScreenName#>: View {
    var body: some View {
        TTBaseSUIView {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_S) {
                TTBaseSUIText(withType: .HEADER, text: "Title")
                TTBaseSUIText(withType: .SUB_TITLE, text: "Subtitle")
            }
            .pAll(TTSize.P_M)
        }
        .bg(byUIColor: TTView.viewDefColor)
    }
}
```
