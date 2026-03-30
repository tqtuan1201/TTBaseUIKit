//
//  TTBaseAPIService.swift
//  TTBaseUIKit
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - HTTP Method
public enum TTHTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
    case PATCH
}

// MARK: - API Endpoint Protocol
/// Define API endpoints in a clean, declarative style.
///
/// Usage:
/// ```swift
/// enum ProductEndpoint: TTAPIEndpoint {
///     case list(limit: Int, skip: Int)
///     case detail(id: Int)
///     case search(query: String)
///
///     var path: String {
///         switch self {
///         case .list:          return "/products"
///         case .detail(let id): return "/products/\(id)"
///         case .search:        return "/products/search"
///         }
///     }
///
///     var method: TTHTTPMethod { .GET }
///
///     var queryItems: [URLQueryItem]? {
///         switch self {
///         case .list(let limit, let skip):
///             return [URLQueryItem(name: "limit", value: "\(limit)"),
///                     URLQueryItem(name: "skip",  value: "\(skip)")]
///         case .search(let query):
///             return [URLQueryItem(name: "q", value: query)]
///         default: return nil
///         }
///     }
/// }
/// ```
public protocol TTAPIEndpoint {
    var path: String { get }
    var method: TTHTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
}

// MARK: - Default implementations
public extension TTAPIEndpoint {
    var method: TTHTTPMethod { .GET }
    var queryItems: [URLQueryItem]? { nil }
    var headers: [String: String]? { nil }
    var body: Data? { nil }
}

// MARK: - API Error
public enum TTAPIError: LocalizedError {
    case invalidURL
    case networkError(Error)
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case noData
    case cancelled
    
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .httpError(let code, _):
            return "Server error (HTTP \(code))"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .noData:
            return "No data received"
        case .cancelled:
            return "Request cancelled"
        }
    }
    
    public var statusCode: Int? {
        if case .httpError(let code, _) = self { return code }
        return nil
    }
}

// MARK: - API Response
public struct TTAPIResponse<T: Decodable> {
    public let data: T
    public let httpResponse: HTTPURLResponse?
    public let rawData: Data
    
    public var statusCode: Int { httpResponse?.statusCode ?? 0 }
}

// MARK: - Base API Service
/// A reusable, generic API service for making network requests.
///
/// Subclass or compose with this to build feature-specific API services.
///
/// Usage:
/// ```swift
/// class ProductService: TTBaseAPIService {
///     static let shared = ProductService(baseURL: "https://dummyjson.com")
///
///     func fetchProducts(limit: Int, skip: Int) async throws -> ProductResponse {
///         try await request(ProductEndpoint.list(limit: limit, skip: skip))
///     }
/// }
/// ```
open class TTBaseAPIService {
    
    // MARK: - Properties
    public let baseURL: String
    public let session: URLSession
    public let decoder: JSONDecoder
    
    /// Enable/disable request logging (uses TTBaseFunc.printLog)
    public var isLoggingEnabled: Bool = true
    
    /// Default headers applied to all requests
    public var defaultHeaders: [String: String] = [
        "Content-Type": "application/json",
        "Accept": "application/json"
    ]
    
    // MARK: - Init
    public init(
        baseURL: String,
        timeoutInterval: TimeInterval = 15,
        cachePolicy: URLRequest.CachePolicy = .returnCacheDataElseLoad,
        decoder: JSONDecoder? = nil
    ) {
        self.baseURL = baseURL
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInterval
        config.requestCachePolicy = cachePolicy
        self.session = URLSession(configuration: config)
        
        self.decoder = decoder ?? {
            let d = JSONDecoder()
            return d
        }()
    }
    
    // MARK: - Core Request
    /// Perform a type-safe API request and decode response.
    public func request<T: Decodable>(_ endpoint: TTAPIEndpoint) async throws -> T {
        let response: TTAPIResponse<T> = try await performRequest(endpoint)
        return response.data
    }
    
    /// Perform a type-safe API request and return full response (including raw data).
    public func requestFull<T: Decodable>(_ endpoint: TTAPIEndpoint) async throws -> TTAPIResponse<T> {
        return try await performRequest(endpoint)
    }
    
    /// Perform a request that doesn't expect a decoded body (e.g. DELETE).
    public func requestVoid(_ endpoint: TTAPIEndpoint) async throws {
        let _: TTAPIResponse<TTEmptyResponse> = try await performRequest(endpoint)
    }
    
    // MARK: - Internal Perform
    private func performRequest<T: Decodable>(_ endpoint: TTAPIEndpoint) async throws -> TTAPIResponse<T> {
        // Build URL
        guard var components = URLComponents(string: baseURL + endpoint.path) else {
            throw TTAPIError.invalidURL
        }
        
        if let queryItems = endpoint.queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        guard let url = components.url else {
            throw TTAPIError.invalidURL
        }
        
        // Build Request
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.httpBody = endpoint.body
        
        // Apply default headers
        for (key, value) in defaultHeaders {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        // Apply endpoint-specific headers (override defaults)
        if let endpointHeaders = endpoint.headers {
            for (key, value) in endpointHeaders {
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Log request
        logRequest(urlRequest, endpoint: endpoint)
        
        // Execute
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError where error.code == .cancelled {
            throw TTAPIError.cancelled
        } catch {
            throw TTAPIError.networkError(error)
        }
        
        // Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw TTAPIError.noData
        }
        
        // Log response
        logResponse(httpResponse, data: data, endpoint: endpoint)
        
        guard (200...299).contains(httpResponse.statusCode) else {
            throw TTAPIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
        
        // Decode
        do {
            let decoded = try decoder.decode(T.self, from: data)
            return TTAPIResponse(data: decoded, httpResponse: httpResponse, rawData: data)
        } catch {
            throw TTAPIError.decodingError(error)
        }
    }
    
    // MARK: - Logging
    private func logRequest(_ request: URLRequest, endpoint: TTAPIEndpoint) {
        guard isLoggingEnabled else { return }
        let method = endpoint.method.rawValue
        let url = request.url?.absoluteString ?? "N/A"
        TTBaseFunc.shared.printLog(object: "🌐 [\(method)] \(url)")
    }
    
    private func logResponse(_ response: HTTPURLResponse, data: Data, endpoint: TTAPIEndpoint) {
        guard isLoggingEnabled else { return }
        let status = response.statusCode
        let size = ByteCountFormatter.string(fromByteCount: Int64(data.count), countStyle: .memory)
        let url = response.url?.absoluteString ?? "N/A"
        TTBaseFunc.shared.printLog(object: "✅ [\(status)] \(url) — \(size)")
    }
}

// MARK: - Empty Response (for void requests)
public struct TTEmptyResponse: Decodable {}

// MARK: - Convenience: Simple Endpoint Struct
/// A simple, struct-based endpoint for quick one-off requests.
///
/// ```swift
/// let endpoint = TTSimpleEndpoint(path: "/users", method: .GET)
/// let users: [User] = try await apiService.request(endpoint)
/// ```
public struct TTSimpleEndpoint: TTAPIEndpoint {
    public let path: String
    public let method: TTHTTPMethod
    public let queryItems: [URLQueryItem]?
    public let headers: [String: String]?
    public let body: Data?
    
    public init(
        path: String,
        method: TTHTTPMethod = .GET,
        queryItems: [URLQueryItem]? = nil,
        headers: [String: String]? = nil,
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }
}

// MARK: - Convenience: Encodable Body
public extension TTAPIEndpoint where Self: Any {
    /// Helper to encode a Codable body to Data.
    static func encodeBody<T: Encodable>(_ value: T) -> Data? {
        try? JSONEncoder().encode(value)
    }
}
