//
//  EmptyStateView.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-27.
//

import SwiftUI

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Icon
            ZStack {
                Circle()
                    .fill(Color.ttSurface)
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 32, weight: .light))
                    .foregroundColor(.ttTextTertiary)
            }
            
            // Text
            VStack(spacing: 8) {
                Text(title)
                    .font(TTFont.heading2)
                    .foregroundColor(.ttTextPrimary)
                
                Text(subtitle)
                    .font(TTFont.bodyMedium)
                    .foregroundColor(.ttTextTertiary)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 400)
            }
            
            // Action Button
            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text(actionTitle)
                    }
                }
                .buttonStyle(.ttPrimary)
                .padding(.top, 8)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.ttBackground)
    }
}

#Preview {
    EmptyStateView(
        icon: "antenna.radiowaves.left.and.right.slash",
        title: "No Device Connected",
        subtitle: "Connect an iOS device running TTBaseUIKit to start debugging. Make sure both devices are on the same network.",
        actionTitle: "Scan for Devices"
    )
    .preferredColorScheme(.dark)
}
