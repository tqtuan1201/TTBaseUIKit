//
//  ContactsBookView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - ContactsBookView
struct ContactsBookView: View {
    @StateObject private var viewModel = ContactsViewModel()
    
    private let avatarColors: [Color] = [
        .blue, .purple, .orange, .green, .red, .blue.opacity(0.8), .purple.opacity(0.8), .pink, .blue.opacity(0.6), .green.opacity(0.7)
    ]
    
    var body: some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: Color(.systemGroupedBackground)) {
            if viewModel.isLoading {
                skeletonView
            } else {
                contentView
            }
        }
        .navigationBarTitle("Contacts Book", displayMode: .inline)
        .onAppear {
            UITabBar.hideTabBar(animated: true)
            Task { await viewModel.loadContacts() }
        }
    }
    
    private var contentView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                // Search
                TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                    Image(systemName: "magnifyingglass").foregroundColor(.secondary)
                    TextField("Search contacts...", text: $viewModel.searchText).font(.system(size: 15))
                }
                .pAll(12)
                .cornerRadius(12)
                .bg(byDef: Color.white)
                
                // Stats
                TTBaseSUIHStack(alignment: .center, spacing: 0, bg: .clear) {
                    contactsStat(icon: "person.crop.circle.fill", value: "\(viewModel.filteredContacts.count)", label: "Contacts", color: .purple.opacity(0.8))
                    Divider().frame(height: 30)
                    contactsStat(icon: "building.2", value: "\(Set(viewModel.contacts.map { $0.company.name }).count)", label: "Companies", color: .orange)
                    Divider().frame(height: 30)
                    contactsStat(icon: "globe", value: "\(Set(viewModel.contacts.map { $0.address.city }).count)", label: "Cities", color: .green)
                }
                .cornerRadius(12)
                .bg(byDef: Color.white)
                .baseShadow(color: .black.opacity(0.04), radius: 3, x: 0, y: 1)
                
                // Contact Cards
                ForEach(Array(viewModel.filteredContacts.enumerated()), id: \.element.id) { idx, contact in
                    NavigationLink(destination: ContactDetailView(contact: contact, color: avatarColors[idx % avatarColors.count])) {
                        contactCard(contact, index: idx)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .pAll(16)
        }
    }
    
    private func contactsStat(icon: String, value: String, label: String, color: Color) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            Image(systemName: icon).font(.system(size: 16)).foregroundColor(color)
            TTBaseSUIText(withBold: .SUB_TITLE, text: value, align: .center)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }
        .maxWidth()
        .pAll(10)
    }
    
    private func contactCard(_ contact: JPUser, index: Int) -> some View {
        let color = avatarColors[index % avatarColors.count]
        return TTBaseSUIHStack(alignment: .center, spacing: 12, bg: .clear) {
            TTBaseSUIText(withBold: .TITLE, text: contact.initials, align: .center, color: .white)
                .frame(width: 50, height: 50)
                .background(
                    LinearGradient(gradient: Gradient(colors: [color, color.opacity(0.7)]),
                                   startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .clipShape(Circle())
            
            TTBaseSUIVStack(alignment: .leading, spacing: 4, bg: .clear) {
                TTBaseSUIText(withBold: .TITLE, text: contact.name, align: .leading)
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "envelope.fill").font(.system(size: 10)).foregroundColor(.blue)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: contact.email, align: .leading, color: .secondary).lineLimit(1)
                }
                TTBaseSUIHStack(alignment: .center, spacing: 4, bg: .clear) {
                    Image(systemName: "building.2").font(.system(size: 10)).foregroundColor(.purple)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: contact.company.name, align: .leading, color: .secondary).lineLimit(1)
                }
            }
            .maxWidth(alignment: .leading)
            
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundColor(.secondary)
        }
        .pAll(14).cornerRadius(14).bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
    
    private var skeletonView: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .leading, spacing: 10, bg: .clear) {
                ForEach(0..<8, id: \.self) { _ in
                    TTBaseSUIHStack(alignment: .center, spacing: 12, bg: Color(.systemBackground)) {
                        Circle().fill(Color(.systemGray5)).frame(width: 50, height: 50)
                        TTBaseSUIVStack(alignment: .leading, spacing: 6, bg: .clear) {
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 16).frame(maxWidth: 160)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 200)
                            RoundedRectangle(cornerRadius: 4).fill(Color(.systemGray5)).frame(height: 12).frame(maxWidth: 140)
                        }
                        .maxWidth(alignment: .leading)
                    }
                    .pAll(14).cornerRadius(14).bg(byDef: Color.white)
                    .skeleton(active: true, isShimmering: true, isLight: true)
                }
            }
            .pAll(16)
        }
    }
}
