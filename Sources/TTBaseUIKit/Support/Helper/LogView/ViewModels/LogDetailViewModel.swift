//
//  LogDetailViewModel.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogDetailViewModel.swift
//  TTBaseUIKit
//

import Foundation

public enum LogDetailTab: Int, CaseIterable {
    case request = 0
    case response = 1

    public var title: String {
        switch self {
        case .request: return "Request"
        case .response: return "Response"
        }
    }
}

public final class LogDetailViewModel: ObservableObject {

    // MARK: - Published
    @Published public var selectedTab: LogDetailTab = .request
    @Published public var jsonSearchText: String = ""

    // MARK: - Model
    public let log: LogViewModel

    // MARK: - Computed
    public var currentJSON: String {
        selectedTab == .request ? log.formattedRequest : log.formattedResponse
    }

    public var rawJSON: String {
        selectedTab == .request ? log.request : log.response
    }

    public var shareText: String {
        let tabName = selectedTab == .request ? "REQUEST" : "RESPONSE"
        let header = "[\(log.httpMethod.displayName)] \(log.formattedURL) - \(log.statusDisplayText)"
        let body = currentJSON
        return "\(header)\n[\(tabName)]\n\n\(body)\n\n[Logged: \(log.formattedDateTime)]"
    }

    public var urlShareText: String {
        "[\(log.httpMethod.displayName)] \(log.urlRequest)"
    }

    public var statusCopyText: String {
        log.statusCode > 0 ? "\(log.statusCode) \(log.statusText)" : "---"
    }

    public var allShareText: String {
        """
        [\(log.httpMethod.displayName)] \(log.urlRequest)

        [Service: \(log.serviceName)]
        === REQUEST ===
        \(log.formattedRequest)

        === RESPONSE ===
        \(log.formattedResponse)

        [Status: \(statusCopyText)]
        [Time: \(log.formattedDateTime)]
        [Size: request \(log.formattedRequestSize), response \(log.formattedResponseSize)]
        """
    }

    public var cURLText: String {
        log.cURLText
    }

    public var requestSummary: String {
        "\(log.formattedRequestSize) request"
    }

    public var responseSummary: String {
        "\(log.formattedResponseSize) response"
    }

    // MARK: - Init
    public init(log: LogViewModel) {
        self.log = log
    }

}
