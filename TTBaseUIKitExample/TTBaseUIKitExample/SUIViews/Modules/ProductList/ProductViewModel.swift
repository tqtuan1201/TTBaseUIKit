//
//  ProductViewModel.swift
//  TMS_APP
//
//  Created by TuanTruong on 25/9/25.
//  Copyright © 2025 Tuan Truong Quang. All rights reserved.
//

import Foundation
import Combine

// MARK: - ViewModel
@MainActor
final class ProductViewModel: ObservableObject {

    @Published var selectedCategory: ProductCategoryItem? = nil
    @Published var items: [ProductItemModel] = []
    @Published var textSearch: String = ""
    @Published private(set) var isLoading: Bool = true

    private var bag = Set<AnyCancellable>()
    private var fetchTask: Task<Void, Never>? = nil

    init() {
        self.bind()
    }
    
    func isShowEmpty() -> Bool {
        return self.items.isEmpty && self.isLoading == false
    }
}

extension ProductViewModel {

    private func bind() {
        // Prepare individual publishers with explicit types and duplicate suppression
        let categoryIdPublisher = self.$selectedCategory.map({$0?.getId() ?? ""}).removeDuplicates()
        let searchTextPublisher = $textSearch

        // Combine both publishers, debounce to limit rapid changes, then trigger fetch
        Publishers.CombineLatest(categoryIdPublisher, searchTextPublisher)
            .debounce(for: .milliseconds(600), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in guard let self else { return }
                self.fetch()
            }
            .store(in: &self.bag)
    }
    
    private func fetch() {
        // Cancel any in-flight request to avoid race conditions
        self.fetchTask?.cancel()

        self.fetchTask = Task { [weak self] in guard let self else { return }
            
            self.items = ProductItemModel.mockSamples
            self.isLoading = true
            
            // Build parameters safely: avoid sending placeholder empty string IDs
            let categoryId = self.selectedCategory?.getId()
            let categoryIds: [String] = categoryId.map { [$0] } ?? []

            if EnvironmentsConfig.IS_DEV { try? await Task.sleep(nanoseconds: 1_000_000_000) }

            // If the task was cancelled during the wait, don't update state
            if Task.isCancelled { return }

            self.items = ProductItemModel.mockSamples
            self.isLoading = false
        }
    }
}

