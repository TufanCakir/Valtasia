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

        VStack(spacing: 12) {

            HStack {

                levelSection

                Spacer()

                currencySection
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color.blue.opacity(0.35)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(
                    LinearGradient(
                        colors: [
                            .cyan.opacity(0.6),
                            .purple.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .shadow(
            color: .cyan.opacity(0.4),
            radius: 12
        )
    }
}

extension GameHeaderView {

    var levelSection: some View {

        VStack(alignment: .leading, spacing: 8) {

            HStack(spacing: 8) {

                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .shadow(color: .yellow.opacity(0.8), radius: 6)

                Text("LV \(progress.level)")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }

            expBar
        }
        .frame(maxWidth: 200, alignment: .leading)
    }
}

extension GameHeaderView {

    var expBar: some View {

        GeometryReader { geo in

            let maxEXP = max(progress.requiredEXP, 1)
            let ratio = CGFloat(progress.exp) / CGFloat(maxEXP)

            ZStack(alignment: .leading) {

                Capsule()
                    .fill(Color.black.opacity(0.6))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * ratio)
                    .shadow(
                        color: .cyan.opacity(0.8),
                        radius: 10
                    )
                    .animation(.easeOut(duration: 0.25), value: ratio)
            }
        }
        .frame(height: 12)
    }
}

extension GameHeaderView {

    var currencySection: some View {

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

    func currencyCard(
        icon: String,
        gradient: [Color],
        value: Int
    ) -> some View {

        HStack(spacing: 6) {

            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(.white)

            Text(value.formatted())
                .font(.footnote.bold())
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .leading,
                endPoint: .trailing
            )
            .opacity(0.25)
        )
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
        )
        .clipShape(Capsule())
        .shadow(
            color: gradient.first!.opacity(0.6),
            radius: 8
        )
    }
}
