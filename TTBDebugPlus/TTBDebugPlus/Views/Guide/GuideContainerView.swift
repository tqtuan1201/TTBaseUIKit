//
//  GuideContainerView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//  Container view with tab picker for Integration Guide and Usage Guide
//

import SwiftUI

struct GuideContainerView: View {
    @State private var selectedGuideTab: GuideTab = .integration
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab picker
            HStack(spacing: 0) {
                ForEach(GuideTab.allCases, id: \.self) { tab in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedGuideTab = tab
                        }
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: tab.icon)
                                .font(.ttIcon(TTIcon.lg))
                            Text(tab.rawValue)
                                .font(TTFont.tabLabel)
                        }
                        .foregroundColor(selectedGuideTab == tab ? .ttPrimary : .ttTextSecondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 12)
                    }
                    .buttonStyle(.plain)
                    .overlay(
                        Rectangle()
                            .fill(selectedGuideTab == tab ? Color.ttPrimary : Color.clear)
                            .frame(height: 2),
                        alignment: .bottom
                    )
                }
                
                Spacer()
            }
            .background(Color.ttBackground)
            .overlay(
                Rectangle().fill(Color.ttBorder.opacity(0.3)).frame(height: 1),
                alignment: .bottom
            )
            
            // Content
            switch selectedGuideTab {
            case .integration:
                IntegrationGuideView()
            case .usage:
                UsageGuideView()
            }
        }
    }
}

enum GuideTab: String, CaseIterable {
    case integration = "iOS SDK Setup"
    case usage = "How to Use"
    
    var icon: String {
        switch self {
        case .integration: return "wrench.and.screwdriver"
        case .usage: return "book"
        }
    }
}

#Preview {
    GuideContainerView()
        .environment(ConnectionManager())
        .frame(width: 900, height: 700)
        .preferredColorScheme(.dark)
}
