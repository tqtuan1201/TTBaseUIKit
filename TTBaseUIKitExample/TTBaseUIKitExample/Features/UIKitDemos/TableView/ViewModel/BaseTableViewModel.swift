//
//  BaseTableViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/7/24.
//  Copyright © 2024 Truong Quang Tuan. All rights reserved.
//

import TTBaseUIKit

class BaseTableViewModel: BaseViewModel {
    
    fileprivate var items: [String] = [
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Believe you can and you're halfway there. - Theodore Roosevelt",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
        "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
        "Happiness is not something ready-made. It comes from your own actions. - Dalai Lama",
        "The best way to predict the future is to create it. - Peter Drucker",
        "Challenges are what make life interesting and overcoming them is what makes life meaningful. - Joshua J. Marine",
        "The only limit to our realization of tomorrow will be our doubts of today. - Franklin D. Roosevelt",
        "Believe in yourself and all that you are. Know that there is something inside you that is greater than any obstacle. - Christian D. Larson",
        "The future belongs to those who prepare for it today. - Malcolm X"
    ]
    
    var willRefreshData: ((_ vm: BaseTableViewModel) -> Void)?
}

// MARK: - Cell Config
extension BaseTableViewModel {
    
    func isShowEmptyDataSource() -> Bool { return self.items.isEmpty }
    
    func getItemByIndexPath(index: IndexPath) -> String? {
        guard items.indices.contains(index.row) else { return nil }
        return items[index.row]
    }
    
    func numberOfItemsToDisplay(session: Int) -> Int { items.count }
    func numberOfSections() -> Int { 1 }
}

// MARK: - API
extension BaseTableViewModel {
    
    func onFetchData() {
        guard beginFetching() else { return }
    }
}
