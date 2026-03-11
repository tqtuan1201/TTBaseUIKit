# Pattern Example: Card

```swift
struct CardPatternExample: View {
    var body: some View {
        TTBaseSUIView {
            TTBaseSUIVStack(alignment: .leading, spacing: TTSize.P_XS) {
                TTBaseSUIText(withType: .HEADER, text: "Card Title")
                TTBaseSUIText(withType: .SUB_TITLE, text: "Card subtitle")
            }
            .pAll(TTSize.P_S)
        }
        .bg(byUIColor: TTView.viewDefColor)
        .corner(byDef: TTSize.CORNER_PANEL)
        .baseShadow()
    }
}
```
