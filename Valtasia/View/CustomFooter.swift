//
//  CustomFooter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct CustomFooter: View {

    @Binding var selectedTab: RootView.Tab

    var body: some View {

        HStack(spacing: 16) {

            footerButton(.home, "house.fill", "Home")
            footerButton(.team, "person.3.fill", "Team")
            footerButton(.summon, "sparkles", "Summon")
            footerButton(.shop, "cart.fill", "Shop")
            footerButton(.exchange, "arrow.2.circlepath", "Exchange")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 32)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.7),
                                    .purple.opacity(0.6),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: .cyan.opacity(0.35), radius: 20)
        .padding()
    }
}

extension CustomFooter {

    func footerButton(
        _ tab: RootView.Tab,
        _ icon: String,
        _ title: String
    ) -> some View {

        let selected = selectedTab == tab

        return Button {

            UIImpactFeedbackGenerator(style: .medium)
                .impactOccurred()

            withAnimation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.75
                )
            ) {
                selectedTab = tab
            }

        } label: {

            VStack(spacing: 6) {

                ZStack {

                    if selected {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        .cyan.opacity(0.6),
                                        .clear,
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 35
                                )
                            )
                            .frame(width: 50, height: 50)
                    }

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            selected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: [.cyan, .purple],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                : AnyShapeStyle(Color.white.opacity(0.6))
                        )
                }

                Text(title)
                    .font(.caption2.bold())
                    .foregroundStyle(
                        selected
                            ? Color.white
                            : Color.white.opacity(0.6)
                    )
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(selected ? 1.1 : 1)
        }
        .buttonStyle(.plain)
    }
}
