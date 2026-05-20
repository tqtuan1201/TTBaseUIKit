//
//  JSONTextView.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  JSONTextView.swift
//  TTBaseUIKit
//

import SwiftUI
import UIKit

public struct JSONTextView: UIViewRepresentable {

    public let json: String
    public let searchText: String

    public init(json: String, searchText: String = "") {
        self.json = json
        self.searchText = searchText
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    public func makeUIView(context: Context) -> UITextView {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = true
        tv.backgroundColor = LogViewTheme.uiCodeSurface
        tv.indicatorStyle = .white
        tv.font = UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        tv.alwaysBounceVertical = true
        tv.keyboardDismissMode = .interactive
        tv.layer.cornerRadius = CGFloat(TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL)
        tv.clipsToBounds = true
        return tv
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        guard context.coordinator.lastJSON != json ||
                context.coordinator.lastSearchText != searchText else {
            return
        }

        let previousOffset = uiView.contentOffset
        let shouldRestoreOffset = context.coordinator.lastJSON == json
        let attributed = JSONTextView.makeAttributed(
            json: json,
            searchText: searchText,
            baseFont: UIFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        )
        uiView.attributedText = attributed
        context.coordinator.lastJSON = json
        context.coordinator.lastSearchText = searchText

        if shouldRestoreOffset {
            uiView.setContentOffset(previousOffset, animated: false)
        } else {
            uiView.setContentOffset(.zero, animated: false)
        }
    }

    public final class Coordinator {
        fileprivate var lastJSON: String = ""
        fileprivate var lastSearchText: String = ""
    }

    // MARK: - Syntax Highlighting
    public static func makeAttributed(
        json: String,
        searchText: String,
        baseFont: UIFont
    ) -> NSAttributedString {
        let baseColor = LogViewTheme.uiPrimaryText
        let keyColor = LogViewTheme.uiAccent
        let stringColor = LogViewTheme.uiSuccess
        let numberColor = LogViewTheme.uiWarning
        let boolColor = LogViewTheme.uiPurple
        let nullColor = LogViewTheme.uiMutedText
        let bracketColor = LogViewTheme.uiSecondaryText
        let highlightBg = LogViewTheme.uiWarning.withAlphaComponent(0.26)

        let result = NSMutableAttributedString(string: json, attributes: [
            .font: baseFont,
            .foregroundColor: baseColor
        ])

        // Search highlight
        if !searchText.isEmpty {
            var searchStart = json.startIndex
            while searchStart < json.endIndex,
                  let found = json.range(
                    of: searchText,
                    options: [.caseInsensitive, .diacriticInsensitive],
                    range: searchStart..<json.endIndex
                  ) {
                let fullRange = NSRange(found, in: json)
                if fullRange.location != NSNotFound {
                    result.addAttribute(.backgroundColor, value: highlightBg, range: fullRange)
                }
                searchStart = found.upperBound
            }
        }

        // JSON syntax patterns
        let patterns: [(String, UIColor)] = [
            // Keys: "key":
            (#""[^"\\]*(?:\\.[^"\\]*)*"(?=\s*:)"#, keyColor),
            // String values (not keys)
            (#""[^"\\]*(?:\\.[^"\\]*)*"(?:\s*[,\]\}\n])"#, stringColor),
            // Numbers
            (#"-?\d+\.?\d*(?:[eE][+-]?\d+)?(?=\s*[,\]\}\n]|$)"#, numberColor),
            // Booleans
            (#"\btrue\b"#, boolColor),
            (#"\bfalse\b"#, boolColor),
            // Null
            (#"\bnull\b"#, nullColor),
            // Brackets
            (#"[\[\]\{\}]"#, bracketColor),
        ]

        for (pattern, color) in patterns {
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                let range = NSRange(location: 0, length: json.utf16.count)
                let matches = regex.matches(in: json, options: [], range: range)
                for match in matches {
                    result.addAttribute(.foregroundColor, value: color, range: match.range)
                }
            } catch {
                // ignore invalid patterns
            }
        }

        return result
    }
}
