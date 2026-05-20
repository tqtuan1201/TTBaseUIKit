//
//  LogListViewModel.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogListViewModel.swift
//  TTBaseUIKit
//

import Foundation
import Combine

public final class LogListViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published public var searchText: String = ""
    @Published public var selectedMethod: HTTPMethod = .unknown
    @Published public var selectedStatusCategory: HTTPStatusCategory = .all
    @Published public var sortAscending: Bool = false
    @Published private(set) public var filteredLogs: [LogViewModel] = []

    // MARK: - Private
    private var allLogs: [LogViewModel] = []
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Computed
    public var totalCount: Int { allLogs.count }
    public var filteredCount: Int { filteredLogs.count }
    public var successCount: Int { count(for: .success) }
    public var redirectCount: Int { count(for: .redirect) }
    public var clientErrorCount: Int { count(for: .clientError) }
    public var serverErrorCount: Int { count(for: .serverError) }
    public var unknownCount: Int { count(for: .unknown) }
    public var issueCount: Int { clientErrorCount + serverErrorCount }

    public var hasActiveFilter: Bool {
        !searchText.isEmpty || selectedMethod != .unknown || selectedStatusCategory != .all
    }

    public var isEmpty: Bool {
        allLogs.isEmpty
    }

    public var exportTitle: String {
        hasActiveFilter ? "Filtered Logs (\(filteredCount)/\(totalCount))" : "Network Logs (\(totalCount))"
    }

    public var exportText: String {
        let logs = filteredLogs.isEmpty ? allLogs : filteredLogs
        guard !logs.isEmpty else { return "No API logs available." }
        return logs.map { $0.developerExportText }.joined(separator: "\n\n---\n\n")
    }

    // MARK: - Init
    public init() {
        setupBindings()
    }

    // MARK: - Setup
    private func setupBindings() {
        Publishers.CombineLatest4($searchText, $selectedMethod, $selectedStatusCategory, $sortAscending)
            .debounce(for: .milliseconds(150), scheduler: RunLoop.main)
            .sink { [weak self] search, method, statusCategory, ascending in
                self?.applyFilters(
                    searchText: search,
                    method: method,
                    statusCategory: statusCategory,
                    ascending: ascending
                )
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    public func loadLogs() {
        allLogs = LogViewHelper.share.getLogs()
        applyFilters(
            searchText: searchText,
            method: selectedMethod,
            statusCategory: selectedStatusCategory,
            ascending: sortAscending
        )
    }

    public func refreshLogs() {
        loadLogs()
    }

    public func toggleSortOrder() {
        sortAscending.toggle()
    }

    public func clearFilters() {
        searchText = ""
        selectedMethod = .unknown
        selectedStatusCategory = .all
        sortAscending = false
    }

    public func resetAllLogs() {
        LogViewHelper.share.resetLogs()
        allLogs = []
        filteredLogs = []
    }

    // MARK: - Private
    public func count(for category: HTTPStatusCategory) -> Int {
        guard category != .all else { return allLogs.count }
        return allLogs.filter { $0.statusCategory == category }.count
    }

    private func applyFilters(
        searchText: String,
        method: HTTPMethod,
        statusCategory: HTTPStatusCategory,
        ascending: Bool
    ) {
        var result = allLogs

        if !searchText.isEmpty {
            let lower = searchText.lowercased()
            result = result.filter { log in
                log.searchableText.lowercased().contains(lower)
            }
        }

        if method != .unknown {
            result = result.filter { $0.httpMethod == method }
        }

        if statusCategory != .all {
            result = result.filter { $0.statusCategory == statusCategory }
        }

        if ascending {
            result = result.sorted { $0.time.compare($1.time) == .orderedAscending }
        } else {
            result = result.sorted { $0.time.compare($1.time) == .orderedDescending }
        }

        filteredLogs = result
    }
}
