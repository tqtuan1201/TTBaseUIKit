//
//  AlbumDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - AlbumDetailView
@available(iOS 15.0, *)
struct AlbumDetailView: View {
    let album: JPAlbum
    @StateObject private var viewModel = PhotoGalleryViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Album Header
            VStack(alignment: .leading, spacing: 6) {
                Text(album.title.capitalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                
                Text("\(viewModel.albumPhotos.count) photos • User #\(album.userId)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(Color(.systemBackground))
            
            // Photos Grid
            if viewModel.isLoadingPhotos {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 3) {
                        ForEach(viewModel.albumPhotos) { photo in
                            NavigationLink(destination: PhotoDetailView(photo: photo)) {
                                AsyncImage(url: URL(string: photo.thumbnailUrl)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image.resizable().scaledToFill()
                                    case .failure:
                                        Color(.systemGray5)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .foregroundColor(.secondary)
                                            )
                                    case .empty:
                                        Color(.systemGray6)
                                            .overlay(ProgressView().scaleEffect(0.6))
                                    @unknown default:
                                        Color(.systemGray6)
                                    }
                                }
                                .frame(height: 120)
                                .frame(maxWidth: .infinity)
                                .clipped()
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("Album", displayMode: .inline)
        .onAppear {
            PhotoGalleryTabBarHelper.hideTabBar()
            Task { await viewModel.loadAlbumPhotos(album) }
        }
    }
}
