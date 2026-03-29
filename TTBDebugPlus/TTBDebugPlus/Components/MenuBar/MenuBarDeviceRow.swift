//
//  MenuBarDeviceRow.swift
//  TTBDebugPlus
//
//  Created by TuanTruong on 2026-03-29.
//  Compact device row for menu bar dropdown
//

import SwiftUI

struct MenuBarDeviceRow: View {
    let session: DeviceSession
    
    @State private var isHovered = false
    
    var body: some View {
        HStack(spacing: 8) {
            // Device icon
            Image(systemName: session.isSimulator ? "laptopcomputer" : "iphone")
                .font(.system(size: 11))
                .foregroundColor(session.isOnline ? .ttSuccess : .secondary)
                .frame(width: 16)
            
            // Device info
            VStack(alignment: .leading, spacing: 1) {
                Text(session.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .lineLimit(1)
                
                Text(session.osVersionString)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Status dot
            Circle()
                .fill(session.isOnline ? Color.ttSuccess : Color.secondary.opacity(0.5))
                .frame(width: 6, height: 6)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 4)
                .fill(isHovered ? Color.primary.opacity(0.08) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            isHovered = hovering
        }
    }
}
