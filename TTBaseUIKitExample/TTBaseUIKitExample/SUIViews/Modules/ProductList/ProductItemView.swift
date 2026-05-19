import SwiftUI
import TTBaseUIKit

struct ProductItemView: View {
    let product: ProductItemModel

    var body: some View {
        TTBaseSUIZStack(alignment: .topLeading) {
            TTBaseSUIVStack(alignment: .leading, spacing: XSize.P_XS) {
                productImage
                productName
                productPrice
                salePriceRow
                TTBaseSUISpacer(maxWidth: 1).bg(byDef: .clear)
            }
            discountBadge
        }
    }

    // MARK: - Subviews
    private var productImage: some View {
        TTBaseSUIHStack(alignment: .center, spacing: 1) {
            TTBaseSUISpacer(maxHeight: 1).bg(byDef: .clear)
            TTBaseSUIZStack(alignment: .topLeading) {
                TTBaseSUIImage(withname: "imageName")
                    .frame(height: 120)
                    .size(width: XSize.W / 2 - XSize.getPadding() * 3)
            }
            TTBaseSUISpacer(maxHeight: 1).bg(byDef: .clear)
        }
    }

    private var productName: some View {
        TTBaseSUIText(withBold: .TITLE, text: product.productName ?? "", align: .leading, color: XView.textDefColor.toColor())
            .lineLimit(4)
    }

    private var productPrice: some View {
        TTBaseSUIText(withBold: .TITLE, text: product.getMinPriceTDL(), align: .leading, color: XView.textWarringColor.toColor())
    }

    @ViewBuilder
    private var salePriceRow: some View {
        if product.isShowSalePrice() {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: "0", align: .leading, color: XView.iconColor.toColor())
        }
    }

    @ViewBuilder
    private var discountBadge: some View {
        let discountText = self.product.getDiscountToDisplay()
        if !discountText.isEmpty {
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: discountText, align: .leading, color: .white)
                .pVertical(XSize.P_XS)
                .bg(byDef: .red)
                .pTop()
        }
    }
}
