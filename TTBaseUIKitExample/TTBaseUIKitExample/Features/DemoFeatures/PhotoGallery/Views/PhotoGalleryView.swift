//
//  PhotoGalleryView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - PhotoGalleryView
@available(iOS 15.0, *)
struct PhotoGalleryView: View {
    @StateObject private var viewModel = PhotoGalleryViewModel()
    
    private let photoColumns = [
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3),
        GridItem(.flexible(), spacing: 3)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if viewModel.isLoading && viewModel.albums.isEmpty {
                skeletonView
            } else {
                contentView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationBarTitle("Photo Gallery", displayMode: .inline)
        .onAppear {
            PhotoGalleryTabBarHelper.hideTabBar()
            Task { await viewModel.loadData() }
        }
    }
    
    // MARK: - Content View
    private var contentView: some View {
        VStack(alignment: .leading, spacing: 0) {
            Picker("View", selection: $viewModel.viewMode) {
                ForEach(PhotoGalleryViewModel.ViewMode.allCases, id: \.rawValue) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(16)
            
            switch viewModel.viewMode {
            case .albums: albumsView
            case .allPhotos: allPhotosView
            }
        }
    }
    
    // MARK: - Albums View
    private var albumsView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(viewModel.albums.prefix(20)) { album in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        albumRow(album)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(16)
        }
    }
    
    // MARK: - Album Row
    private func albumRow(_ album: JPAlbum) -> some View {
        HStack(alignment: .center, spacing: 14) {
            Image(systemName: "photo.stack.fill")
                .font(.system(size: 22))
                .foregroundColor(.pink)
                .frame(width: 48, height: 48)
                .background(Color.pink.opacity(0.1))
                .cornerRadius(12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(album.title.capitalized)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                
                Text("Album #\(album.id) • User #\(album.userId)")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(14)
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    // MARK: - All Photos View
    private var allPhotosView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: photoColumns, spacing: 3) {
                ForEach(viewModel.photos) { photo in
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
    
    // MARK: - Skeleton View
    private var skeletonView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(0..<8, id: \.self) { _ in
                    HStack(alignment: .center, spacing: 14) {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(.systemGray5))
                            .frame(width: 48, height: 48)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 16)
                            
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 12)
                                .frame(maxWidth: 150)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(12)
                    .background(Color(.systemBackground))
                    .cornerRadius(14)
                    .redacted(reason: .placeholder)
                    .shimmer()
                }
            }
            .padding(16)
        }
    }
}

// MARK: - Shimmer Effect (Native SwiftUI)
struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geo in
                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: .clear, location: phase - 0.3),
                            .init(color: .white.opacity(0.4), location: phase),
                            .init(color: .clear, location: phase + 0.3)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(width: geo.size.width * 3)
                    .offset(x: -geo.size.width)
                }
                .clipped()
                .mask(RoundedRectangle(cornerRadius: 14))
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 1.6
                }
            }
    }
}

extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

// MARK: - TabBar Helper (Native UIKit, no TTBaseUIKit dependency)
enum PhotoGalleryTabBarHelper {
    static func hideTabBar() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }
            
            findTabBars(in: window).forEach { $0.isHidden = true }
        }
    }
    
    private static func findTabBars(in view: UIView) -> [UITabBar] {
        var result: [UITabBar] = []
        if let tabBar = view as? UITabBar { result.append(tabBar) }
        for subview in view.subviews {
            result.append(contentsOf: findTabBars(in: subview))
        }
        return result
    }
}
