//
//  ProductCategoryViewModel.swift
//  TMS_APP
//
//  Created by TuanTruong on 24/9/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation

// MARK: - ViewModel
@MainActor
final class ProductCategoryViewModel: ObservableObject {

    @Published private(set) var categories: [ProductCategoryItem] = []
    @Published var selected: ProductCategoryItem? = nil
    @Published internal var isLoading: Bool = true
    
    init() {
        DispatchQueue.main.async {
            self.fetch()
        }
    }
}

extension ProductCategoryViewModel {
    
    func select(_ item: ProductCategoryItem?) {
        self.selected = item
    }
    
     func fetch() {
        Task {
            self.isLoading = true
            var items: [ProductCategoryItem] = []
            items.insert(ProductCategoryItem.createAllItems(), at: 0)
            self.categories = items
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.selected = self.categories.first
                self.isLoading  = false
            }
        }
    }
}










