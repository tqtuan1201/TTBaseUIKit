//
//  ContactDetailView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ContactDetailView
struct ContactDetailView: View {
    let contact: JPUser
    let color: Color
    
    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .center, spacing: 16, bg: .clear) {
                // Header
                contactHeader
                
                // Contact Info
                contactInfoCard
                
                // Company Info
                companyInfoCard
                
                // Address Info
                addressCard
            }
            .pAll(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle(contact.name, displayMode: .inline)
        .onAppear { UITabBar.hideTabBar(animated: true) }
    }
    
    private var contactHeader: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear) {
            // Avatar
            TTBaseSUIText(withBold: .HEADER, text: contact.initials, align: .center, color: .white)
                .frame(width: 90, height: 90)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.6)]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(Circle())
                .baseShadow(color: color.opacity(0.4), radius: 8, x: 0, y: 4)
            
            TTBaseSUIText(withBold: .HEADER, text: contact.name, align: .center)
            TTBaseSUIText(withType: .SUB_TITLE, text: "@\(contact.username)", align: .center, color: .secondary)
            
            // Quick Actions
            TTBaseSUIHStack(alignment: .center, spacing: 16, bg: .clear) {
                quickAction(icon: "phone.fill", label: "Call", color: .green)
                quickAction(icon: "envelope.fill", label: "Email", color: .blue)
                quickAction(icon: "globe", label: "Web", color: .purple)
            }
            .pVertical(8)
        }
        .pAll(20)
        .maxWidth()
        .cornerRadius(20)
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
    }
    
    private func quickAction(icon: String, label: String, color: Color) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 6, bg: .clear) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.1))
                .clipShape(Circle())
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }
    }
    
    private var contactInfoCard: some View {
        detailCard(title: "Contact Info", icon: "person.crop.circle.fill", color: .blue, items: [
            ("envelope.fill", "Email", contact.email),
            ("phone.fill", "Phone", contact.phone),
            ("globe", "Website", contact.website),
            ("at", "Username", contact.username),
        ])
    }
    
    private var companyInfoCard: some View {
        detailCard(title: "Company", icon: "building.2.fill", color: .purple, items: [
            ("building.2", "Name", contact.company.name),
            ("quote.bubble.fill", "Catchphrase", contact.company.catchPhrase),
            ("briefcase.fill", "Business", contact.company.bs),
        ])
    }
    
    private var addressCard: some View {
        detailCard(title: "Address", icon: "mappin.circle.fill", color: .orange, items: [
            ("house.fill", "Street", "\(contact.address.street), \(contact.address.suite)"),
            ("building", "City", contact.address.city),
            ("number", "Zipcode", contact.address.zipcode),
            ("location.fill", "Coordinates", "\(contact.address.geo.lat), \(contact.address.geo.lng)"),
        ])
    }
    
    private func detailCard(title: String, icon: String, color: Color, items: [(String, String, String)]) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear, radius: 16) {
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
            }
            .pAll(14)
            
            Divider()
            
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                TTBaseSUIHStack(alignment: .top, spacing: 10, bg: .clear) {
                    Image(systemName: item.0)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    TTBaseSUIVStack(alignment: .leading, spacing: 2, bg: .clear) {
                        TTBaseSUIText(withType: .SUB_SUB_TILE, text: item.1, align: .leading, color: .secondary)
                        TTBaseSUIText(withType: .SUB_TITLE, text: item.2, align: .leading)
                    }
                    .maxWidth(alignment: .leading)
                }
                .pAll(.horizontal, 14)
                .pAll(.vertical, 10)
                
                if idx < items.count - 1 {
                    Divider().padding(.leading, 44)
                }
            }
        }
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}
