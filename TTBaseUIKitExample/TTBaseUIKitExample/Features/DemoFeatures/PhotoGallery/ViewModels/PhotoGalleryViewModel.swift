//
//  PhotoGalleryViewModel.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - PhotoGalleryViewModel
@MainActor
final class PhotoGalleryViewModel: ObservableObject {
    @Published var albums: [JPAlbum] = []
    @Published var photos: [JPPhoto] = []
    @Published var selectedAlbum: JPAlbum?
    @Published var albumPhotos: [JPPhoto] = []
    @Published var isLoading = false
    @Published var isLoadingPhotos = false
    @Published var errorMessage: String?
    @Published var viewMode: ViewMode = .albums
    
    enum ViewMode: String, CaseIterable {
        case albums = "Albums"
        case allPhotos = "All Photos"
    }
    
    private let service = PhotoGalleryService.shared
    
    func loadData() async {
        guard !isLoading else { return }
        isLoading = true; errorMessage = nil
        do {
            async let albumsTask = service.fetchAlbums()
            async let photosTask = service.fetchAllPhotos(limit: 50)
            let (a, p) = try await (albumsTask, photosTask)
            albums = a; photos = p
        } catch { errorMessage = error.localizedDescription }
        isLoading = false
    }
    
    func loadAlbumPhotos(_ album: JPAlbum) async {
        selectedAlbum = album
        isLoadingPhotos = true
        do {
            albumPhotos = try await service.fetchPhotos(albumId: album.id)
        } catch { albumPhotos = [] }
        isLoadingPhotos = false
    }
}
