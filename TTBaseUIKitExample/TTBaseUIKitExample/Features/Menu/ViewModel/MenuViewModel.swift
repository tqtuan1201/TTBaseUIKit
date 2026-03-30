//
//  MenuViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - MenuViewModel
/// ViewModel for the main Menu screen.
/// Provides data access methods for UITableViewDataSource.
class MenuViewModel: BaseViewModel {
    
    private(set) var sections: [MenuSection] = MenuSection.createAll()
    var fromDate: Date = Date()
    var toDate: Date = Date().addingTimeInterval(2 * 24 * 60 * 60)
    
    // MARK: - Data Access
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfItems(in section: Int) -> Int {
        return sections[section].items.count
    }
    
    func item(at indexPath: IndexPath) -> MenuFunction {
        return sections[indexPath.section].items[indexPath.row]
    }
    
    func section(at index: Int) -> MenuSection {
        return sections[index]
    }
    
    func sectionType(at index: Int) -> MenuSection.TYPE {
        return sections[index].type
    }
    
    func sectionDescription(at index: Int) -> String {
        return sections[index].type.getDes()
    }
}
