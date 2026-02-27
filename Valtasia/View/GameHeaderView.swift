//
//  GameHeaderView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct GameHeaderView: View {

    @ObservedObject var coins = CoinManager.shared
    @ObservedObject var crystals = CrystalManager.shared
    @ObservedObject var progress = PlayerProgressManager.shared

    var body: some View {

        VStack {

            HStack(alignment: .center, spacing: 16) {

                levelSection

                Spacer()

                currencySection
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 14)
        }
        .background(headerBackground)
        .ignoresSafeArea(edges: .top)
    }
}

extension GameHeaderView {

    fileprivate var headerBackground: some View {

        ZStack {

            // Blur Material
            Rectangle()
                .fill(.ultraThinMaterial)

            // RPG Gradient
            LinearGradient(
                colors: [
                    .black.opacity(0.65),
                    .black.opacity(0.35),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .overlay(alignment: .bottom) {

            Divider()
                .background(.white.opacity(0.2))
        }
    }
}

extension GameHeaderView {

    fileprivate var levelSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 6) {

                Image(systemName: "star.circle.fill")
                    .foregroundStyle(.yellow)

                Text("LV \(progress.level)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }

            expBar
        }
    }

    fileprivate var expBar: some View {

        GeometryReader { geo in

            ZStack(alignment: .leading) {

                Capsule()
                    .fill(.black.opacity(0.5))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                .green,
                                .mint,
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(
                        width:
                            geo.size.width * CGFloat(progress.exp)
                            / CGFloat(progress.requiredEXP)
                    )
                    .shadow(color: .green.opacity(0.6), radius: 4)
            }
        }
        .frame(width: 160, height: 12)
    }
}

extension GameHeaderView {

    fileprivate var currencySection: some View {

        HStack(spacing: 12) {

            currencyCard(
                icon: "diamond.fill",
                gradient: [.cyan, .blue],
                value: crystals.crystals
            )

            currencyCard(
                icon: "bitcoinsign.circle.fill",
                gradient: [.yellow, .orange],
                value: coins.coins
            )
        }
    }

    fileprivate func currencyCard(
        icon: String,
        gradient: [Color],
        value: Int
    ) -> some View {

        HStack(spacing: 8) {

            Image(systemName: icon)
                .font(.headline)
                .foregroundStyle(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            Text(value.formatted())
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background {

            Capsule()
                .fill(.black.opacity(0.55))

                .overlay {

                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: gradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                }
        }
        .shadow(color: .black.opacity(0.4), radius: 6, y: 3)
    }
}
