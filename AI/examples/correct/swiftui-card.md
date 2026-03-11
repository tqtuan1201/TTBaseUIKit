# Correct Example: SwiftUI Card

```swift
struct SummaryCardView: View {
    let title: String
    let value: String

    var body: some View {
        TTBaseSUIView {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withType: .HEADER, text: title)
                TTBaseSUIText(withType: .TITLE, text: value)
            }
            .pAll(TTSize.P_S)
        }
        .bg(byUIColor: TTView.viewDefColor)
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
    }
}
```
