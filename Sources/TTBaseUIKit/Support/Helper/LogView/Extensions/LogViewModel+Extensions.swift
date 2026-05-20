//
//  LogViewModel+Extensions.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogViewModel+Extensions.swift
//  TTBaseUIKit
//

import Foundation
import UIKit

public enum HTTPMethod: String, CaseIterable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
    case head = "HEAD"
    case options = "OPTIONS"
    case unknown = ""

    public var displayName: String {
        switch self {
        case .get: return "GET"
        case .post: return "POST"
        case .put: return "PUT"
        case .delete: return "DELETE"
        case .patch: return "PATCH"
        case .head: return "HEAD"
        case .options: return "OPTIONS"
        case .unknown: return "ALL"
        }
    }
}

// MARK: - HTTP Status Category
public enum HTTPStatusCategory: CaseIterable {
    case all
    case success      // 2xx
    case redirect     // 3xx
    case clientError  // 4xx
    case serverError  // 5xx
    case unknown

    public init(statusCode: Int) {
        switch statusCode {
        case Int.min..<1: self = .unknown
        case 200..<300: self = .success
        case 300..<400: self = .redirect
        case 400..<500: self = .clientError
        case 500..<600: self = .serverError
        default: self = .unknown
        }
    }

    public var displayName: String {
        switch self {
        case .all: return "ALL"
        case .success: return "2xx"
        case .redirect: return "3xx"
        case .clientError: return "4xx"
        case .serverError: return "5xx"
        case .unknown: return "---"
        }
    }

    public var title: String {
        switch self {
        case .all: return "All"
        case .success: return "Success"
        case .redirect: return "Redirect"
        case .clientError: return "Client"
        case .serverError: return "Server"
        case .unknown: return "Unknown"
        }
    }

    public var systemImageName: String {
        switch self {
        case .all: return "tray.full"
        case .success: return "checkmark.seal"
        case .redirect: return "arrow.triangle.branch"
        case .clientError: return "exclamationmark.triangle"
        case .serverError: return "xmark.octagon"
        case .unknown: return "questionmark.circle"
        }
    }

    public var tintColor: UIColor {
        switch self {
        case .all: return TTBaseUIKitConfig.getViewConfig().buttonBgDef
        case .success: return .systemGreen
        case .redirect: return .systemBlue
        case .clientError: return .systemOrange
        case .serverError: return .systemRed
        case .unknown: return .systemGray
        }
    }
}

// MARK: - LogViewModel Extensions
extension LogViewModel {

    public var stableID: String {
        "\(time.timeIntervalSince1970)-\(name)-\(urlRequest)-\(request.count)-\(response.count)"
    }

    public var httpMethod: HTTPMethod {
        if self.method.isEmpty {
            guard !urlRequest.isEmpty else { return .unknown }
            let upper = urlRequest.uppercased()
            for method in HTTPMethod.allCases where method != .unknown {
                if upper.hasPrefix(method.rawValue) {
                    return method
                }
            }
            return .unknown
        } else {
            return HTTPMethod.init(rawValue: self.method) ?? .unknown
        }
    }

    public var endpoint: String {
        guard !urlRequest.isEmpty else { return urlRequest }
        let method = httpMethod
        if method != .unknown {
            return String(urlRequest.dropFirst(method.rawValue.count)).trimmingCharacters(in: .whitespaces)
        }
        return urlRequest
    }

    public var statusCode: Int {
        let raw = response.prefix(3)
        return Int(raw) ?? 0
    }

    public var statusCategory: HTTPStatusCategory {
        HTTPStatusCategory(statusCode: statusCode)
    }

    public var statusText: String {
        let raw = response.prefix(3)
        guard let code = Int(raw) else { return "---" }
        return HTTPURLResponse.localizedString(forStatusCode: code)
    }

    public var statusDisplayText: String {
        guard statusCode > 0 else { return "No status" }
        return "\(statusCode) \(statusText.capitalized)"
    }

    public var formattedRequest: String {
        prettyPrintJSON(request)
    }

    public var formattedResponse: String {
        prettyPrintJSON(response)
    }

    public var formattedURL: String {
        endpoint.isEmpty ? urlRequest : endpoint
    }

    public var formattedTime: String {
        time.dateString(withFormatString: "HH:mm:ss")
    }

    public var formattedDateTime: String {
        time.dateString(withFormatString: "dd/MM/yyyy HH:mm:ss")
    }

    public var serviceName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unknown service" : name
    }

    public var requestByteCount: Int {
        request.data(using: .utf8)?.count ?? request.count
    }

    public var responseByteCount: Int {
        response.data(using: .utf8)?.count ?? response.count
    }

    public var formattedRequestSize: String {
        formatBytes(requestByteCount)
    }

    public var formattedResponseSize: String {
        formatBytes(responseByteCount)
    }

    public var formattedTotalSize: String {
        formatBytes(requestByteCount + responseByteCount)
    }

    public var requestPreview: String {
        let lines = request.components(separatedBy: "\n")
        if let first = lines.first, !first.isEmpty {
            let trimmed = first.trimmingCharacters(in: .whitespaces)
            return trimmed.count > 100 ? String(trimmed.prefix(100)) + "..." : trimmed
        }
        return request.isEmpty ? "(empty)" : request
    }

    public var responsePreview: String {
        let trimmed = response.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "(empty)" }
        return trimmed.count > 120 ? String(trimmed.prefix(120)) + "..." : trimmed
    }

    public var searchableText: String {
        [
            name,
            urlRequest,
            endpoint,
            request,
            response,
            "\(statusCode)",
            statusText
        ]
        .joined(separator: "\n")
    }

    public var cURLText: String {
        var components: [String] = [
            "curl -X \(httpMethod == .unknown ? "GET" : httpMethod.rawValue)",
            "'\(escapedShell(endpoint))'"
        ]

        let payload = formattedRequest.trimmingCharacters(in: .whitespacesAndNewlines)
        if !payload.isEmpty && payload != "(empty)" {
            components.append("-H 'Content-Type: application/json'")
            components.append("-d '\(escapedShell(payload))'")
        }

        return components.joined(separator: " \\\n  ")
    }

    public var developerExportText: String {
        """
        [\(httpMethod.displayName)] \(formattedURL)
        Service: \(serviceName)
        Status: \(statusDisplayText)
        Time: \(formattedDateTime)
        Size: request \(formattedRequestSize), response \(formattedResponseSize), total \(formattedTotalSize)

        === REQUEST ===
        \(formattedRequest)

        === RESPONSE ===
        \(formattedResponse)

        === cURL ===
        \(cURLText)
        """
    }

    private func prettyPrintJSON(_ string: String) -> String {
        let trimmed = normalizedJSONPayload(from: string)
        guard let data = trimmed.data(using: .utf8) else { return trimmed }
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            let prettyData = try JSONSerialization.data(withJSONObject: json, options: [.prettyPrinted, .sortedKeys])
            return String(data: prettyData, encoding: .utf8) ?? trimmed
        } catch {
            return trimmed
        }
    }

    private func normalizedJSONPayload(from string: String) -> String {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard Int(trimmed.prefix(3)) != nil else { return trimmed }

        let payload = String(trimmed.dropFirst(3)).trimmingCharacters(in: .whitespacesAndNewlines)
        guard payload.hasPrefix("{") || payload.hasPrefix("[") else { return trimmed }
        return payload
    }

    private func formatBytes(_ bytes: Int) -> String {
        guard bytes >= 1024 else { return "\(bytes) B" }
        let kb = Double(bytes) / 1024.0
        guard kb >= 1024 else { return String(format: "%.1f KB", kb) }
        return String(format: "%.1f MB", kb / 1024.0)
    }

    private func escapedShell(_ value: String) -> String {
        value.replacingOccurrences(of: "'", with: "'\\''")
    }

    public var methodColor: UIColor {
        switch httpMethod {
        case .get:    return .systemGreen
        case .post:   return .systemBlue
        case .put:    return .systemOrange
        case .delete: return .systemRed
        case .patch:  return .systemPurple
        default:      return .systemGray
        }
    }

    public var statusColor: UIColor {
        switch statusCategory {
        case .all:          return TTBaseUIKitConfig.getViewConfig().buttonBgDef
        case .success:      return .systemGreen
        case .redirect:     return .systemBlue
        case .clientError: return .systemOrange
        case .serverError:  return .systemRed
        case .unknown:      return .systemGray
        }
    }
}
