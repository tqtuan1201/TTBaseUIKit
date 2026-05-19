//
//  AllShipHomeItemModels.swift
//  TMS_APP
//
//  Created by TuanTruong on 31/10/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation
import TTBaseUIKit

public enum SCREEN_NAME: String, Codable {
    case HOME
}
 
// Han che dung data, pattern nay chi dung screenName | serviceScreenId
struct ScreenNotiModel {
    var screenName:SCREEN_NAME = .HOME
    var serviceScreenId:String = ""
    var redirectObjectContent: String = ""
    var autoSearch:Bool = false
}

struct ScreenCoordinatorModel {
    var item:ScreenNotiModel = ScreenNotiModel()
}

class ScreenCoordinator : TTCoordinator {
    
    fileprivate var viewModel:ScreenCoordinatorModel = ScreenCoordinatorModel()
    fileprivate var currVC: UIViewController?
    
    init(withCurrentVC vc:UIViewController, model:ScreenNotiModel) {
        self.viewModel.item = model
        self.currVC = vc
    }
    
    init( model:ScreenNotiModel) {
        self.viewModel.item = model
        self.currVC = UIApplication.topViewController()
    }
}
//MARK:// For start handle
extension ScreenCoordinator {
    
    func start() {
        DispatchQueue.main.async {
          
        }
    }
}

struct ActionItemModel : Codable {

    var objectId : String?
    var page : String?
    var type : Int?


    enum CodingKeys: String, CodingKey {
        case objectId = "objectId"
        case page = "page"
        case type = "type"
    }

    init() {}
    init(screenCoord  screenName:SCREEN_NAME) {
        self.page = screenName.rawValue
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        objectId = try? values.decodeIfPresent(String.self, forKey: .objectId)
        page = try? values.decodeIfPresent(String.self, forKey: .page)
        type = try? values.decodeIfPresent(Int.self, forKey: .type)
    }


}

struct HomeBannerResponse : Codable {

    var contentSectionCode : String?
    var sectionTitle:String?
    var displayType : Int?
    var items : [HomeBannerItemModel]?
    var priority : Int?


    enum CodingKeys: String, CodingKey {
        case sectionTitle = "sectionTitle"
        case contentSectionCode = "contentSectionCode"
        case displayType = "displayType"
        case items = "items"
        case priority = "priority"
    }

    init() {}
    init(localMenus items: [HomeBannerItemModel]) {
        self.items = items
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        sectionTitle = try? values.decodeIfPresent(String.self, forKey: .sectionTitle)
        contentSectionCode = try? values.decodeIfPresent(String.self, forKey: .contentSectionCode)
        displayType = try? values.decodeIfPresent(Int.self, forKey: .displayType)
        items = try? values.decodeIfPresent([HomeBannerItemModel].self, forKey: .items)
        priority = try? values.decodeIfPresent(Int.self, forKey: .priority)
    }


}

struct HomeBannerItemModel : Codable, Identifiable {
    
    var id:String = UUID().uuidString
    
    var actionPage : String?
    var actionType : Int?
    var basePriceToDisplay : Double?
    var discountAmountToDisplay : Double?
    var discountType : Double?
    var discountValueToDisplay : Double?
    var isActive : Bool?
    var itemName : String?
    var objectId : String?
    var objectType : Int?
    var priceToDisplay : Double?
    var priority : Int?
    var salePriceToDisplay : Double?
    var urlImage : String?
    var action:ActionItemModel?
    var isBestSeller:Bool?

    enum CodingKeys: String, CodingKey {
        case isBestSeller = "isBestSeller"
        case action = "action"
        case actionPage = "actionPage"
        case actionType = "actionType"
        case basePriceToDisplay = "basePriceToDisplay"
        case discountAmountToDisplay = "discountAmountToDisplay"
        case discountType = "discountType"
        case discountValueToDisplay = "discountValueToDisplay"
        case isActive = "isActive"
        case itemName = "itemName"
        case objectId = "objectId"
        case objectType = "objectType"
        case priceToDisplay = "priceToDisplay"
        case priority = "priority"
        case salePriceToDisplay = "salePriceToDisplay"
        case urlImage = "urlImage"
    }

    init() {
        self.itemName = "N/A"
        self.salePriceToDisplay = 0.0
    }

    init (withMenuLocal name:String, img:String, action:ActionItemModel?, isActive:Bool) {
        self.itemName = name
        self.urlImage = img
        self.action = action
        self.isActive = isActive
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        action = try? values.decodeIfPresent(ActionItemModel.self, forKey: .action)
        isBestSeller = try? values.decodeIfPresent(Bool.self, forKey: .isBestSeller)
        
        actionPage = try? values.decodeIfPresent(String.self, forKey: .actionPage)
        actionType = try? values.decodeIfPresent(Int.self, forKey: .actionType)
        basePriceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .basePriceToDisplay)
        discountAmountToDisplay = try? values.decodeIfPresent(Double.self, forKey: .discountAmountToDisplay)
        discountType = try? values.decodeIfPresent(Double.self, forKey: .discountType)
        discountValueToDisplay = try? values.decodeIfPresent(Double.self, forKey: .discountValueToDisplay)
        isActive = try? values.decodeIfPresent(Bool.self, forKey: .isActive)
        itemName = try? values.decodeIfPresent(String.self, forKey: .itemName)
        objectId = try? values.decodeIfPresent(String.self, forKey: .objectId)
        objectType = try? values.decodeIfPresent(Int.self, forKey: .objectType)
        priceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .priceToDisplay)
        priority = try? values.decodeIfPresent(Int.self, forKey: .priority)
        salePriceToDisplay = try? values.decodeIfPresent(Double.self, forKey: .salePriceToDisplay)
        urlImage = try? values.decodeIfPresent(String.self, forKey: .urlImage)
    }

    func isShowSalePrice() -> Bool {
        return self.salePriceToDisplay != self.priceToDisplay
    }
    
    func isEnable() -> Bool {
        return self.action != nil
    }
    
    static func creatMenuLocal() -> [HomeBannerItemModel] {
        var locals:[HomeBannerItemModel] = []
        return locals
    }
}

