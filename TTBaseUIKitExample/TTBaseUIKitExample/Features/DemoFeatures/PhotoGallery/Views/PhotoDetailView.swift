//
//  PhotoDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import UIKit

// MARK: - PhotoDetailView
@available(iOS 15.0, *)
struct PhotoDetailView: View {
    let photo: JPPhoto
    @State private var imageScale: CGFloat = 1.0
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Spacer()
            
            // Photo with pinch-to-zoom
            AsyncImage(url: URL(string: photo.url)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(imageScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    imageScale = value
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        imageScale = 1.0
                                    }
                                }
                        )
                case .failure:
                    Color(.systemGray5)
                        .overlay(
                            VStack(spacing: 8) {
                                Image(systemName: "photo.fill")
                                    .font(.system(size: 36))
                                    .foregroundColor(.gray)
                                Text("Failed to load")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        )
                case .empty:
                    Color.clear
                        .overlay(
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        )
                @unknown default:
                    Color.clear
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 300)
            
            // Photo Info
            VStack(alignment: .leading, spacing: 8) {
                Text(photo.title.capitalized)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Text("Photo #\(photo.id) • Album #\(photo.albumId)")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.6))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .navigationBarTitle("Photo", displayMode: .inline)
        .onAppear { PhotoGalleryTabBarHelper.hideTabBar() }
    }
}
