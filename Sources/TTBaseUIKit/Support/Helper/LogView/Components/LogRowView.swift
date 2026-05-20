//
//  LogRowView.swift
//  TTBaseUIKit
//
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//  LogRowView.swift
//  TTBaseUIKit
//

import SwiftUI
import UIKit

public struct LogRowView: View {

    public let log: LogViewModel
    public let isCompact: Bool
    public let onTap: () -> Void

    public init(log: LogViewModel, isCompact: Bool = false, onTap: @escaping () -> Void) {
        self.log = log
        self.isCompact = isCompact
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                severityStrip

                VStack(alignment: .leading, spacing: isCompact ? 7 : 10) {
                    HStack(alignment: .center, spacing: 8) {
                        methodBadge
                        serviceText
                        Spacer(minLength: 8)
                        statusBadge
                    }

                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        urlText
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(LogViewTheme.mutedText)
                    }

                    if !isCompact {
                        previewText
                    }

                    HStack(spacing: 8) {
                        metricPill(icon: "clock", text: log.formattedTime)
                        metricPill(icon: "arrow.up.doc", text: log.formattedRequestSize)
                        metricPill(icon: "arrow.down.doc", text: log.formattedResponseSize)
                        Spacer(minLength: 0)
                    }
                }
                .padding(.horizontal, CGFloat(isCompact ? TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF : TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 1.25))
                .padding(.vertical, CGFloat(isCompact ? 10 : TTBaseUIKitConfig.getSizeConfig().P_CONS_DEF * 1.25))
            }
            .background(LogViewTheme.elevatedSurface)
            .cornerRadius(CGFloat(TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL))
            .overlay(
                RoundedRectangle(cornerRadius: CGFloat(TTBaseUIKitConfig.getSizeConfig().CORNER_PANEL))
                    .stroke(LogViewTheme.border, lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.28), radius: 5, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
        .contextMenu {
            Button(action: { copyToPasteboard(log.urlRequest) }) {
                Label("Copy URL", systemImage: "link")
            }
            Button(action: { copyToPasteboard(log.endpoint) }) {
                Label("Copy Endpoint", systemImage: "point.topleft.down.curvedto.point.bottomright.up")
            }
            Button(action: { copyToPasteboard(log.cURLText) }) {
                Label("Copy cURL", systemImage: "chevron.left.slash.chevron.right")
            }
            Button(action: { copyToPasteboard(log.formattedRequest) }) {
                Label("Copy Request", systemImage: "arrow.up.doc")
            }
            Button(action: { copyToPasteboard(log.formattedResponse) }) {
                Label("Copy Response", systemImage: "arrow.down.doc")
            }
            Button(action: { copyToPasteboard(log.developerExportText) }) {
                Label("Copy Full Log", systemImage: "doc.on.doc")
            }
        }
    }

    // MARK: - Subviews
    private var severityStrip: some View {
        Rectangle()
            .fill(LogViewTheme.statusColor(for: log.statusCategory))
            .frame(width: 4)
    }

    private var methodBadge: some View {
        Text(log.httpMethod.displayName)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(LogViewTheme.background)
            .padding(.horizontal, 6)
            .padding(.vertical, 3)
            .background(LogViewTheme.methodColor(for: log.httpMethod))
            .cornerRadius(4)
    }

    private var serviceText: some View {
        Text(log.serviceName)
            .font(.system(size: 12, weight: .semibold))
            .foregroundColor(LogViewTheme.secondaryText)
            .lineLimit(1)
            .truncationMode(.middle)
    }

    private var urlText: some View {
        Text(log.endpoint.isEmpty ? log.urlRequest : log.endpoint)
            .font(.system(size: 13, weight: .medium))
            .foregroundColor(LogViewTheme.primaryText)
            .lineLimit(isCompact ? 1 : 2)
            .truncationMode(.middle)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var statusBadge: some View {
        Group {
            if log.statusCode > 0 {
                HStack(spacing: 4) {
                    Image(systemName: log.statusCategory.systemImageName)
                        .font(.system(size: 9, weight: .bold))
                    Text("\(log.statusCode)")
                        .font(.system(size: 11, weight: .semibold))
                }
                .foregroundColor(LogViewTheme.background)
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(LogViewTheme.statusColor(for: log.statusCategory))
                .cornerRadius(4)
            } else {
                EmptyView()
            }
        }
    }

    private var previewText: some View {
        let preview = log.requestPreview == "(empty)" ? log.responsePreview : log.requestPreview
        return Text(preview)
            .font(.system(size: 11))
            .foregroundColor(LogViewTheme.secondaryText)
            .lineLimit(2)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metricPill(icon: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
            Text(text)
                .font(.system(size: 10, weight: .medium))
                .lineLimit(1)
        }
        .foregroundColor(LogViewTheme.secondaryText)
        .padding(.horizontal, 7)
        .padding(.vertical, 4)
        .background(LogViewTheme.surface)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(LogViewTheme.subtleBorder, lineWidth: 1)
        )
    }

    private func copyToPasteboard(_ value: String) {
        UIPasteboard.general.string = value
    }
}
