//
//  UserProfileView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 30/3/26.
//  Copyright © 2026 Truong Quang Tuan. All rights reserved.
//

import SwiftUI
import TTBaseUIKit

// MARK: - UserProfileView
struct UserProfileView: View {
    
    let user: DJUser
    
    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .center, spacing: 16, bg: .clear) {
                // Profile Header
                profileHeader
                
                // Info Cards
                personalInfoCard
                companyInfoCard
                locationInfoCard
                physicalInfoCard
            }
            .pAll(16)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle(user.fullName, displayMode: .inline)
        .onAppear { UITabBar.hideTabBar(animated: true) }
    }
    
    private var profileHeader: some View {
        TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear, radius: 20) {
            TTBaseSUIAsyncImage(urlString: user.image, type: .CIRCLE)
                .sizeSquare(width: 100)
                .pTop(20)
            
            TTBaseSUIText(withBold: .HEADER, text: user.fullName, align: .center)
            TTBaseSUIText(withType: .SUB_TITLE, text: "@\(user.username)", align: .center, color: .secondary)
            
            TTBaseSUIHStack(alignment: .center, spacing: 20, bg: .clear) {
                profileStat(value: "\(user.age)", label: "Age")
                Divider().frame(height: 30)
                profileStat(value: user.gender.capitalized, label: "Gender")
                Divider().frame(height: 30)
                profileStat(value: user.bloodGroup, label: "Blood")
            }
            .pAll(16)
        }
        .maxWidth()
        .bg(byDef: Color.white)
        .baseShadow(color: .black.opacity(0.06), radius: 5, x: 0, y: 2)
    }
    
    private func profileStat(value: String, label: String) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            TTBaseSUIText(withBold: .TITLE, text: value, align: .center)
            TTBaseSUIText(withType: .SUB_SUB_TILE, text: label, align: .center, color: .secondary)
        }
    }
    
    private var personalInfoCard: some View {
        infoCard(title: "Personal Info", icon: "person.fill", color: .blue, items: [
            ("envelope.fill", "Email", user.email),
            ("phone.fill", "Phone", user.phone),
            ("calendar", "Birthday", user.birthDate),
            ("graduationcap.fill", "University", user.university),
        ])
    }
    
    private var companyInfoCard: some View {
        infoCard(title: "Company", icon: "building.2.fill", color: .purple, items: [
            ("briefcase.fill", "Company", user.company.name),
            ("person.text.rectangle", "Title", user.company.title),
            ("gearshape.fill", "Department", user.company.department),
        ])
    }
    
    private var locationInfoCard: some View {
        infoCard(title: "Location", icon: "mappin.circle.fill", color: .orange, items: [
            ("house.fill", "Address", user.address.address),
            ("building", "City", user.address.city),
            ("map", "State", "\(user.address.state) (\(user.address.stateCode))"),
            ("number", "Postal Code", user.address.postalCode),
        ])
    }
    
    private var physicalInfoCard: some View {
        infoCard(title: "Physical", icon: "figure.stand", color: .green, items: [
            ("ruler", "Height", user.formattedHeight),
            ("scalemass", "Weight", user.formattedWeight),
            ("eye", "Eye Color", user.eyeColor),
            ("comb.fill", "Hair", "\(user.hair.color) - \(user.hair.type)"),
        ])
    }
    
    private func infoCard(title: String, icon: String, color: Color, items: [(String, String, String)]) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear, radius: 16) {
            // Header
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(color)
                TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
            }
            .pAll(14)
            
            Divider()
            
            // Items
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                    Image(systemName: item.0)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .frame(width: 20)
                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: item.1, align: .leading, color: .secondary)
                        .frame(width: 80, alignment: .leading)
                    TTBaseSUIText(withType: .SUB_TITLE, text: item.2, align: .leading)
                        .maxWidth(alignment: .leading)
                        .lineLimit(1)
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
