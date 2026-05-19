//
//  NewUserProfileView.swift
//  TTBaseUIKitExample
//
//  Created by TuanTruong on 13/5/26.
//  [TTBaseUIKit-AI-Agents]: TTBaseUIKit Agent Support is active 🚀
//

import SwiftUI
import TTBaseUIKit

// MARK: - NewUserProfileView
struct NewUserProfileView: View {

    @StateObject private var viewModel = NewUserProfileViewModel()

    var body: some View {
        TTBaseSUIScroll(alignment: .vertical, showIndicators: false) {
            TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
                // Loading State
                if viewModel.isLoading {
                    skeletonView
                } else if let user = viewModel.user {
                    // Profile Header
                    profileHeaderCard(user: user)

                    // Info Cards
                    personalInfoCard(user: user)
                    companyInfoCard(user: user)
                    locationInfoCard(user: user)
                    physicalInfoCard(user: user)
                } else if let error = viewModel.errorMessage {
                    errorView(message: error)
                }
            }
            .pAll(XSize.P_CONS_DEF)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarTitle("New User Profile", displayMode: .inline)
        .onAppear {
            viewModel.fetchUser()
            UITabBar.hideTabBar(animated: true)
        }
    }

    // MARK: - Profile Header Card
    private func profileHeaderCard(user: DJUser) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear) {
            // Avatar with initials
            avatarView(user: user)

            // Name
            TTBaseSUIText(withBold: .HEADER, text: user.fullName, align: .center)

            // Age Badge
            ageBadge(age: user.age)

            // View More Button
            TTBaseSUIButton(type: .NO_BG_COLOR, title: "View More")
                .pTop(8)
        }
        .pAll(XSize.P_L)
        .maxWidth()
        .bg(byDef: .white)
        .corner(byDef: XSize.CORNER_RADIUS * 2)
        .baseShadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 4)
    }

    // MARK: - Avatar View
    private func avatarView(user: DJUser) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 100)

            Text(user.initials)
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.white)
        }
    }

    // MARK: - Age Badge
    private func ageBadge(age: Int) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: 4, bg: .clear) {
            Text("\(age) years old")
                .font(.system(size: XFont.SUB_TITLE_H, weight: .medium))
                .foregroundColor(Color(.secondaryLabel))
        }
        .pAll(XSize.P_S)
        .bg(byDef: Color(.systemGray5))
        .corner(byDef: XSize.CORNER_RADIUS)
    }

    // MARK: - Personal Info Card
    private func personalInfoCard(user: DJUser) -> some View {
        infoCard(
            title: "Personal Info",
            icon: "person.fill",
            iconColor: .blue,
            items: [
                ("envelope.fill", "Email", user.email),
                ("phone.fill", "Phone", user.phone),
                ("calendar", "Birthday", user.birthDate),
                ("graduationcap.fill", "University", user.university)
            ]
        )
    }

    // MARK: - Company Info Card
    private func companyInfoCard(user: DJUser) -> some View {
        infoCard(
            title: "Company",
            icon: "building.2.fill",
            iconColor: .purple,
            items: [
                ("briefcase.fill", "Company", user.company.name),
                ("person.text.rectangle", "Title", user.company.title),
                ("gearshape.fill", "Department", user.company.department)
            ]
        )
    }

    // MARK: - Location Info Card
    private func locationInfoCard(user: DJUser) -> some View {
        infoCard(
            title: "Location",
            icon: "mappin.circle.fill",
            iconColor: .orange,
            items: [
                ("house.fill", "Address", user.address.address),
                ("building", "City", user.address.city),
                ("map", "State", "\(user.address.state) (\(user.address.stateCode))"),
                ("number", "Postal Code", user.address.postalCode)
            ]
        )
    }

    // MARK: - Physical Info Card
    private func physicalInfoCard(user: DJUser) -> some View {
        infoCard(
            title: "Physical",
            icon: "figure.stand",
            iconColor: .green,
            items: [
                ("ruler", "Height", user.formattedHeight),
                ("scalemass", "Weight", user.formattedWeight),
                ("eye", "Eye Color", user.eyeColor),
                ("comb.fill", "Hair", "\(user.hair.color) - \(user.hair.type)")
            ]
        )
    }

    // MARK: - Info Card Component
    private func infoCard(title: String, icon: String, iconColor: Color, items: [(String, String, String)]) -> some View {
        TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
            // Header
            TTBaseSUIHStack(alignment: .center, spacing: 8, bg: .clear) {
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
                TTBaseSUIText(withBold: .TITLE, text: title, align: .leading)
            }
            .pAll(XSize.P_CONS_DEF)

            Divider()

            // Items
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                    Image(systemName: item.0)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.secondaryLabel))
                        .frame(width: 20)

                    TTBaseSUIText(withType: .SUB_SUB_TILE, text: item.1, align: .leading, color: Color(.secondaryLabel))
                        .frame(width: 80, alignment: .leading)

                    TTBaseSUIText(withType: .SUB_TITLE, text: item.2, align: .leading)
                        .maxWidth(alignment: .leading)
                        .lineLimit(2)
                }
                .pAll(.horizontal, XSize.P_CONS_DEF)
                .pAll(.vertical, XSize.P_S + 2)

                if idx < items.count - 1 {
                    TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
                        Divider()
                    }
                    .pLeading(XSize.P_CONS_DEF + 30)
                }
            }
        }
        .maxWidth()
        .bg(byDef: .white)
        .corner(byDef: XSize.CORNER_RADIUS)
        .baseShadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }

    // MARK: - Skeleton View
    private var skeletonView: some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_CONS_DEF, bg: .clear) {
            // Header skeleton
            TTBaseSUIVStack(alignment: .center, spacing: 12, bg: .clear) {
                Circle()
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 100)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 150, height: 20)

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color(.systemGray5))
                    .frame(width: 100, height: 16)
            }
            .pAll(XSize.P_L)
            .maxWidth()
            .bg(byDef: .white)
            .corner(byDef: XSize.CORNER_RADIUS * 2)

            // Card skeletons
            ForEach(0..<4, id: \.self) { _ in
                TTBaseSUIVStack(alignment: .leading, spacing: 0, bg: .clear) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(height: 40)
                        .pAll(XSize.P_CONS_DEF)

                    Divider()

                    ForEach(0..<3, id: \.self) { _ in
                        TTBaseSUIHStack(alignment: .center, spacing: 10, bg: .clear) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: 20, height: 20)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(width: 80, height: 14)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(.systemGray5))
                                .frame(height: 14)
                        }
                        .pAll(.horizontal, XSize.P_CONS_DEF)
                        .pAll(.vertical, XSize.P_S + 2)
                    }
                }
                .maxWidth()
                .bg(byDef: .white)
                .corner(byDef: XSize.CORNER_RADIUS)
            }
        }
        .skeleton(active: true)
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        TTBaseSUIVStack(alignment: .center, spacing: XSize.P_L, bg: .clear) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)

            TTBaseSUIText(withType: .SUB_TITLE, text: message, align: .center, color: Color(.secondaryLabel))

            TTBaseSUIButton(type: .DEFAULT, title: "Retry") {
                viewModel.fetchUser()
            }
        }
        .pAll(XSize.P_L * 2)
        .maxWidth()
        .bg(byDef: .white)
        .corner(byDef: XSize.CORNER_RADIUS)
        .baseShadow()
    }
}

// MARK: - Preview
struct NewUserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewUserProfileView()
        }
    }
}
