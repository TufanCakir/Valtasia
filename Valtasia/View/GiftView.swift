//
//  GiftView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftView: View {

    @ObservedObject var coins = CoinManager.shared
    @ObservedObject var crystals = CrystalManager.shared
    @ObservedObject var progress = PlayerProgressManager.shared

    var body: some View {

        VStack {

            // MARK: Header
            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            ScrollView {

                VStack(spacing: 20) {

                    Text("🎁 Gifts")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.top)

                    // MARK: Gift Rows
                    GiftRow(
                        giftId: "gift_coins",
                        title: "Coins",
                        value: coins.coins,
                        icon: "bitcoinsign.circle.fill",
                        iconColor: .yellow,
                        colors: [.yellow, .orange]
                    ) {
                        CoinManager.shared.add(500)
                    }

                    GiftRow(
                        giftId: "gift_crystals",
                        title: "Crystals",
                        value: crystals.crystals,
                        icon: "diamond.fill",
                        iconColor: .cyan,
                        colors: [.cyan, .purple]
                    ) {
                        CrystalManager.shared.add(50)
                    }

                    GiftRow(
                        giftId: "gift_exp",
                        title: "EXP Potion",
                        value: progress.exp,
                        icon: "sparkles",
                        iconColor: .blue,
                        colors: [.green, .blue]
                    ) {
                        PlayerProgressManager.shared.addEXP(100)
                    }

                    // MARK: Player Progress Card

                    playerProgressCard
                        .padding(.top, 10)

                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension GiftView {

    var playerProgressCard: some View {

        ZStack {

            LinearGradient(
                colors: [.black.opacity(0.9), .purple.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 12) {

                Text("Player Progress")
                    .font(.headline)
                    .foregroundStyle(.white)

                Text("Level \(progress.level)")
                    .font(.title2.bold())
                    .foregroundStyle(.cyan)

                ProgressView(
                    value: Double(progress.exp),
                    total: Double(progress.requiredEXP)
                )
                .tint(.cyan)
                .padding(.horizontal)

                Text("\(progress.exp) / \(progress.requiredEXP) EXP")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.7), .purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .cyan.opacity(0.3), radius: 14)
    }
}
