# SwiftUI View Template

```swift
struct <#ViewName#>: View {
    var body: some View {
        TTBaseSUIView {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_S) {
                TTBaseSUIText(withType: .TITLE, text: "Title")
            }
            .pAll(TTSize.P_S)
        }
        .bg(byUIColor: TTView.viewDefColor)
    }
}
```
