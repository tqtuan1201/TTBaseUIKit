//
//  PhotoGalleryService.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation

// MARK: - PhotoGalleryService (Native URLSession)
final class PhotoGalleryService {
    static let shared = PhotoGalleryService()
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session: URLSession
    private let decoder = JSONDecoder()
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 15
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    func fetchAlbums() async throws -> [JPAlbum] {
        try await request(path: "/albums")
    }
    
    func fetchPhotos(albumId: Int) async throws -> [JPPhoto] {
        try await request(path: "/albums/\(albumId)/photos")
    }
    
    func fetchAllPhotos(limit: Int = 50) async throws -> [JPPhoto] {
        try await request(path: "/photos", queryItems: [URLQueryItem(name: "_limit", value: "\(limit)")])
    }
    
    // MARK: - Private Generic Request
    private func request<T: Decodable>(path: String, queryItems: [URLQueryItem]? = nil) async throws -> T {
        guard var components = URLComponents(string: baseURL + path) else {
            throw URLError(.badURL)
        }
        if let queryItems = queryItems, !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }
}
