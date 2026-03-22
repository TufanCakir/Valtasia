//
//  CustomFooter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct CustomFooter: View {

    @EnvironmentObject var appModel: AppModel
    @Binding var selectedTab: RootView.Tab

    @ScaledMetric private var iconSize: CGFloat = 20

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        HStack {
            footerButton(.home, "house.fill", "Home")
            footerButton(.team, "person.3.fill", "Team")
            footerButton(.summon, "sparkles", "Summon")
            footerButton(.shop, "cart.fill", "Shop")
            footerButton(.exchange, "arrow.2.circlepath", "Exchange")
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)

        // 🔥 FLOATING BACKGROUND
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 26)
                    .fill(.ultraThinMaterial)  // 👈 Glass Effekt

                RoundedRectangle(cornerRadius: 26)
                    .fill(
                        LinearGradient(
                            colors: theme.headerGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .opacity(0.25)
                    )
            }
        )

        // 🔥 BORDER
        .overlay(
            RoundedRectangle(cornerRadius: 26)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
        )

        // 🔥 SHADOW = DEPTH
        .shadow(color: .black.opacity(0.4), radius: 12, y: 6)

        // 🔥 SAFE AREA FLOATING
        .padding(.horizontal)
        .padding(.bottom, 10)
        .padding()

        .animation(.easeInOut(duration: 0.25), value: appModel.homeMode)
    }

    func footerButton(
        _ tab: RootView.Tab,
        _ icon: String,
        _ title: String
    ) -> some View {

        let selected = selectedTab == tab

        return Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedTab = tab
        } label: {

            VStack(spacing: 4) {

                Image(systemName: icon)
                    .font(.system(size: iconSize, weight: .semibold))
                    .foregroundStyle(
                        selected
                            ? AnyShapeStyle(
                                LinearGradient(
                                    colors: theme.footerGradient,
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            : AnyShapeStyle(Color.white.opacity(0.7))
                    )
                    .scaleEffect(selected ? 1.15 : 1)

                Text(title)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(
                        selected ? .white : .white.opacity(0.7)
                    )
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)

            // 🔥 SELECTED GLOW BACKGROUND
            .background(
                ZStack {
                    if selected {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    colors: theme.footerGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                                .opacity(0.25)
                            )

                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                LinearGradient(
                                    colors: theme.footerGradient,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    }
                }
            )
            .animation(
                .spring(response: 0.3, dampingFraction: 0.7),
                value: selected
            )
        }
        .buttonStyle(.plain)
    }
}
