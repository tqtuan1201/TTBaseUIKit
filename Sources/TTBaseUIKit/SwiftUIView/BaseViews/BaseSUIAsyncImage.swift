//
//  BaseSUIAsyncImage.swift
//  TTBaseUIKit
//
//  Created by TTBaseUIKit on 9/3/26.
//  Copyright © 2019 Truong Quang Tuan. All rights reserved.
//

import SwiftUI

/// Wraps `AsyncImage` (iOS 15+) with TTBaseUIKit defaults: placeholder skeleton,
/// error fallback image, corner radius, and content mode — all from config tokens.
///
/// Falls back to a `TTBaseSUIImage` placeholder on iOS 14 and below.
///
/// Usage:
/// ```swift
/// // Basic URL string
/// TTBaseSUIAsyncImage(urlString: "https://example.com/photo.jpg")
///
/// // With explicit size + corner
/// TTBaseSUIAsyncImage(urlString: url, contentMode: .fill, cornerRadius: TTSize.CORNER_IMAGE)
///     .sizeSquare(width: 80)
///
/// // Circle clip
/// TTBaseSUIAsyncImage(urlString: url, type: .CIRCLE)
///     .sizeSquare(width: 60)
/// ```
public struct TTBaseSUIAsyncImage: View {

    // MARK: - Type

    public enum TYPE {
        case DEFAULT          // rectangular with cornerRadius
        case CIRCLE           // clipped to circle
    }

    // MARK: - Stored Properties

    public var urlString: String?
    public var url: URL?
    public var contentMode: ContentMode      = .fill
    public var cornerRadius: CGFloat         = TTBaseUIKitConfig.getSizeConfig().CORNER_IMAGE
    public var type: TYPE                    = .DEFAULT

    /// Shown while loading
    public var placeholderColor: Color       = Color(TTBaseUIKitConfig.getViewConfig().viewBgSkeleton)
    /// Shown on error
    public var errorImageName: String        = Config.Value.noImageName

    // MARK: - Inits

    /// Init 1: URL string
    public init(urlString: String?) {
        self.urlString = urlString
        self.url       = urlString.flatMap { URL(string: $0) }
    }

    /// Init 2: URL string + contentMode + cornerRadius
    public init(urlString: String?, contentMode: ContentMode, cornerRadius: CGFloat) {
        self.urlString    = urlString
        self.url          = urlString.flatMap { URL(string: $0) }
        self.contentMode  = contentMode
        self.cornerRadius = cornerRadius
    }

    /// Init 3: URL string + type (DEFAULT / CIRCLE)
    public init(urlString: String?, type: TYPE) {
        self.urlString = urlString
        self.url       = urlString.flatMap { URL(string: $0) }
        self.type      = type
    }

    /// Init 4: URL object
    public init(url: URL?) {
        self.url = url
    }

    /// Init 5: full
    public init(
        urlString: String? = nil,
        url: URL? = nil,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = TTBaseUIKitConfig.getSizeConfig().CORNER_IMAGE,
        type: TYPE = .DEFAULT,
        placeholderColor: Color = Color(TTBaseUIKitConfig.getViewConfig().viewBgSkeleton),
        errorImageName: String = "img.NoImage.png"
    ) {
        self.urlString       = urlString
        self.url             = url ?? urlString.flatMap { URL(string: $0) }
        self.contentMode     = contentMode
        self.cornerRadius    = cornerRadius
        self.type            = type
        self.placeholderColor = placeholderColor
        self.errorImageName  = errorImageName
    }

    // MARK: - Body

    public var body: some View {
        if #available(iOS 15.0, *) {
            self.buildAsyncImage()
        } else {
            // Fallback: show placeholder for iOS 14
            self.buildPlaceholder()
        }
    }

    // MARK: - Builders

    @available(iOS 15.0, *)
    @ViewBuilder
    private func buildAsyncImage() -> some View {
        AsyncImage(url: self.url) { phase in
            switch phase {
            case .empty:
                self.buildPlaceholder()
                    .skeleton(active: true, isShimmering: true, isLight: true)

            case .success(let image):
                self.applyClip(
                    image
                        .resizable()
                        .aspectRatio(contentMode: self.contentMode)
                )

            case .failure:
                TTBaseSUIImage(withname: self.errorImageName, contentMode: self.contentMode)

            @unknown default:
                self.buildPlaceholder()
            }
        }
    }

    @ViewBuilder
    private func applyClip<V: View>(_ view: V) -> some View {
        switch self.type {
        case .CIRCLE:
            view.clipShape(Circle())
        default:
            view.cornerRadius(self.cornerRadius)
        }
    }

    @ViewBuilder
    private func buildPlaceholder() -> some View {
        self.placeholderColor
            .cornerRadius(self.type == .CIRCLE ? 9999 : self.cornerRadius)
    }
}

// MARK: - Preview

#Preview {
    TTBaseSUIVStack(alignment: .center, spacing: TTSize.P_CONS_DEF * 2, bg: Color.clear) {
        TTBaseSUIText(withBold: .SUB_TITLE, text: ".DEFAULT (no URL → placeholder)", align: .center, color: Color(TTView.textSubTitleColor))
        TTBaseSUIAsyncImage(urlString: nil)
            .size(width: 140, height: 100).padding()

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".CIRCLE (no URL → placeholder)", align: .center, color: Color(TTView.textSubTitleColor))
        TTBaseSUIAsyncImage(urlString: nil, type: .CIRCLE)
            .sizeSquare(width: 80).padding()

        TTBaseSUIText(withBold: .SUB_TITLE, text: ".DEFAULT (real URL)", align: .center, color: Color(TTView.textSubTitleColor))
        TTBaseSUIAsyncImage(urlString: "https://picsum.photos/200/140")
            .size(width: 200, height: 140).padding()
    }
    .pAll(TTSize.P_CONS_DEF * 2)
    .bg(byDef: TTView.viewBgColor.toColor())
    .corner()
}
