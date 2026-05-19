//
//  CategoryItem.swift
//  TMS_APP
//
//  Created by TuanTruong on 24/9/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation

struct ProductCategoryItem : Codable, Identifiable, Hashable {

    var id : String?
    var name : String?
    var mediaUrl:String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case mediaUrl = "mediaUrl"
    }

    init() {}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        mediaUrl = try? values.decodeIfPresent(String.self, forKey: .mediaUrl)
    }

    static func createAllItems() -> ProductCategoryItem {
        var item:ProductCategoryItem = ProductCategoryItem()
        item.id = "-1"
        item.name = XText("App.Product.Category.All")
        item.mediaUrl = "icon.star"
        return item
    }
    
    func isSelectAll() -> Bool {
        return self.id == "-1"
    }
    
    func getId() -> String {
        if self.isSelectAll() { return "" }
        return self.id ?? ""
    }
}

extension ProductCategoryItem {
    /// Create a single mock CategoryItem
    /// - Parameters:
    ///   - id: Optional id. Defaults to a random UUID string.
    ///   - name: Display name. Defaults to "Category".
    ///   - url: Optional URL string. Defaults to nil.
    /// - Returns: A `CategoryItem` with provided or default values.
    static func mock(
        id: String = UUID().uuidString,
        name: String = "Category",
        url: String? = nil
    ) -> ProductCategoryItem {
        var item = ProductCategoryItem()
        item.id = id
        item.name = name
        item.mediaUrl = url
        return item
    }

    /// A single default mock item
    static var mock: ProductCategoryItem { .mock() }

    /// A few sample items for previews/tests
    static var mockSamples: [ProductCategoryItem] {
        [
            .mock(name: "News", url: "https://example.com/news"),
            .mock(name: "Sports", url: "https://example.com/sports"),
            .mock(name: "Technology", url: "https://example.com/tech")
        ]
    }
}

struct ProductItemResponse : Codable {

    var hasNext : Bool?
    var hasPrevious : Bool?
    var items : [ProductItemModel]?
    var pageIndex : Int?
    var pageSize : Int?
    var totalCount : Int?


    enum CodingKeys: String, CodingKey {
        case hasNext = "hasNext"
        case hasPrevious = "hasPrevious"
        case items = "items"
        case pageIndex = "pageIndex"
        case pageSize = "pageSize"
        case totalCount = "totalCount"
    }

    init() {}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        hasNext = try? values.decodeIfPresent(Bool.self, forKey: .hasNext)
        hasPrevious = try? values.decodeIfPresent(Bool.self, forKey: .hasPrevious)
        items = try? values.decodeIfPresent([ProductItemModel].self, forKey: .items)
        pageIndex = try? values.decodeIfPresent(Int.self, forKey: .pageIndex)
        pageSize = try? values.decodeIfPresent(Int.self, forKey: .pageSize)
        totalCount = try? values.decodeIfPresent(Int.self, forKey: .totalCount)
    }


}
struct ProductItemModel : Codable, Identifiable, Hashable {

    var avatarUrl : String?
    var basePrice : Double?
    var categoryName : String?
    var createdBy : String?
    var createdByName : String?
    var createdTime : String?
    var discountAmount : Double?
    var discountValue : Double?
    
    
    var discountAmountToDisplay : Double?
    var discountPercentToDisplay:Double?
    
    var id : String?
    var isActive : Bool?
    var isAppDisplay : Bool?
    var isRetail : Bool?
    var price : Double?
    var productName : String?
    var quantityVariant : Int?
    var salePrice : Double?
    var shopCode : String?
    var shopId : String?
    var shopName : String?
    var sku : String?
    
    var minPriceToDisplay:Double?
    var salePriceToDisplay:Double?
    var discountValueToDisplay:Double?
    var priceToDisplay:Double?
    
    enum CodingKeys: String, CodingKey {
        
        case salePriceToDisplay = "salePriceToDisplay"
        case discountValueToDisplay = "discountValueToDisplay"
        case priceToDisplay = "priceToDisplay"
        
        
        case discountAmountToDisplay = "discountAmountToDisplay"
        case discountPercentToDisplay = "discountPercentToDisplay"
        
        
        case avatarUrl = "avatarUrl"
        case basePrice = "basePrice"
        case categoryName = "categoryName"
        case createdBy = "createdBy"
        case createdByName = "createdByName"
        case createdTime = "createdTime"
        case discountAmount = "discountAmount"
        case discountValue = "discountValue"
        case id = "id"
        case isActive = "isActive"
        case isAppDisplay = "isAppDisplay"
        case isRetail = "isRetail"
        case price = "price"
        case productName = "productName"
        case quantityVariant = "quantityVariant"
        case salePrice = "salePrice"
        case shopCode = "shopCode"
        case shopId = "shopId"
        case shopName = "shopName"
        case sku = "sku"
        case minPriceToDisplay = "minPriceToDisplay"
    }

    init() {}

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        discountAmountToDisplay = try? values.decodeIfPresent(Double.self, forKey: .discountAmountToDisplay)
        discountPercentToDisplay = try? values.decodeIfPresent(Double.self, forKey: .discountPercentToDisplay)
        minPriceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .minPriceToDisplay)
        
        
        avatarUrl = try? values.decodeIfPresent(String.self, forKey: .avatarUrl)
        basePrice = try? values.decodeIfPresent(Double.self, forKey: .basePrice)
        categoryName = try? values.decodeIfPresent(String.self, forKey: .categoryName)
        createdBy = try? values.decodeIfPresent(String.self, forKey: .createdBy)
        createdByName = try? values.decodeIfPresent(String.self, forKey: .createdByName)
        createdTime = try? values.decodeIfPresent(String.self, forKey: .createdTime)
        discountAmount = try? values.decodeIfPresent(Double.self, forKey: .discountAmount)
        discountValue = try? values.decodeIfPresent(Double.self, forKey: .discountValue)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        isActive = try? values.decodeIfPresent(Bool.self, forKey: .isActive)
        isAppDisplay = try? values.decodeIfPresent(Bool.self, forKey: .isAppDisplay)
        isRetail = try? values.decodeIfPresent(Bool.self, forKey: .isRetail)
        price = try? values.decodeIfPresent(Double.self, forKey: .price)
        productName = try? values.decodeIfPresent(String.self, forKey: .productName)
        quantityVariant = try? values.decodeIfPresent(Int.self, forKey: .quantityVariant)
        salePrice = try? values.decodeIfPresent(Double.self, forKey: .salePrice)
        shopCode = try? values.decodeIfPresent(String.self, forKey: .shopCode)
        shopId = try? values.decodeIfPresent(String.self, forKey: .shopId)
        shopName = try? values.decodeIfPresent(String.self, forKey: .shopName)
        sku = try? values.decodeIfPresent(String.self, forKey: .sku)
        
        salePriceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .salePriceToDisplay)
        discountValueToDisplay = try? values.decodeIfPresent(Double.self, forKey: .discountValueToDisplay)
        priceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .priceToDisplay)
        
    }
    
    func getDiscountToDisplay() -> String {
        return ""
    }
    
    func isShowSalePrice() -> Bool {
        return self.salePriceToDisplay != self.minPriceToDisplay
    }
    
    func getSalePrice() -> Double {
        return self.salePrice ?? 0.0
    }
    
    func getMinPriceTDL() -> String {
        return  "0 đ"
    }
    
    func getPriceToDL() -> String {
        return  "0 đ"
    }
    
}

extension ProductItemModel {
    /// Create a single mock ProductItemModel
    /// - Parameters:
    ///   - id: Optional id. Defaults to a random UUID string.
    ///   - productName: Display name. Defaults to "Product".
    ///   - categoryName: Category display name. Defaults to "General".
    ///   - price: Regular price. Defaults to 100.
    ///   - salePrice: Optional sale price. Defaults to nil.
    ///   - avatarUrl: Optional image URL.
    ///   - sku: Optional stock keeping unit.
    /// - Returns: A `ProductItemModel` with provided or default values.
    static func mock(
        id: String = UUID().uuidString,
        productName: String = "Product",
        categoryName: String = "General",
        price: Double = 100,
        salePrice: Double? = nil,
        avatarUrl: String? = nil,
        sku: String? = nil
    ) -> ProductItemModel {
        var item = ProductItemModel()
        item.id = id
        item.productName = productName
        item.categoryName = categoryName
        item.price = price
        item.salePrice = salePrice
        item.basePrice = price
        item.discountAmount = (salePrice != nil) ? max(0, price - (salePrice ?? price)) : nil
        item.discountValue = (salePrice != nil) ? max(0, (price - (salePrice ?? price)) / price) : nil
        item.avatarUrl = avatarUrl
        item.sku = sku
        item.isActive = true
        item.isAppDisplay = true
        item.isRetail = true
        item.quantityVariant = 1
        item.createdBy = "admin"
        item.createdByName = "Admin"
        item.createdTime = "2025-09-01T10:00:00Z"
        item.shopCode = "HQ"
        item.shopId = "shop_1"
        item.shopName = "Main Store"
        return item
    }

    /// A single default mock item
    static var mock: ProductItemModel { .mock() }

    /// Eight sample items for previews/tests
    static var mockSamples: [ProductItemModel] {
        [
            .mock(
                productName: "iPhone 16 Pro",
                categoryName: "Phones",
                price: 1199,
                salePrice: 1099,
                avatarUrl: "",
                sku: "IP16P-128"
            ),
            .mock(
                productName: "iPad Air (M2)",
                categoryName: "Tablets",
                price: 799,
                salePrice: 749,
                avatarUrl: "",
                sku: "IPAD-AIR-M2"
            ),
            .mock(
                productName: "MacBook Air 15\"",
                categoryName: "Laptops",
                price: 1299,
                salePrice: nil,
                avatarUrl: "",
                sku: "MBA-15-BASE"
            ),
            .mock(
                productName: "Apple Watch Series 10",
                categoryName: "Wearables",
                price: 499,
                salePrice: 459,
                avatarUrl: "",
                sku: "AW-S10-41"
            ),
            .mock(
                productName: "AirPods Pro (2nd Gen)",
                categoryName: "Audio",
                price: 249,
                salePrice: 219,
                avatarUrl: "",
                sku: "APP2-MAGSAFE"
            ),
            .mock(
                productName: "Magic Keyboard",
                categoryName: "Accessories",
                price: 99,
                salePrice: nil,
                avatarUrl: "",
                sku: "MK-ENG"
            ),
            .mock(
                productName: "Studio Display",
                categoryName: "Displays",
                price: 1599,
                salePrice: 1499,
                avatarUrl: "",
                sku: "SD-STD-GLS"
            ),
            .mock(
                productName: "HomePod mini",
                categoryName: "Smart Home",
                price: 99,
                salePrice: 89,
                avatarUrl: "",
                sku: "HPM-WHITE"
            )
        ]
    }
}


extension Double {
    func formatDiscount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        let number = formatter.string(from: NSNumber(value: self)) ?? "\(self)"
        return "\(number)%"
    }
}
