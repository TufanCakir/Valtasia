//
//  GameHeaderView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct GameHeaderView: View {

    @EnvironmentObject var appModel: AppModel

    @ObservedObject var coins = CoinManager.shared
    @ObservedObject var gems = GemManager.shared
    @ObservedObject var corruptedCoins = CorruptedCoinManager.shared
    @ObservedObject var corruptedGems = CorruptedGemManager.shared

    @State private var showCurrencySheet = false
    @ObservedObject var progress = PlayerProgressManager.shared

    var theme: UITheme {
        appModel.homeMode == .portal ? .portal : .island
    }

    var body: some View {

        HStack(spacing: 16) {

            levelSection

            Spacer()

            currencySection
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)

        .background(
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )

        .overlay(
            Rectangle()
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

extension GameHeaderView {

    var levelSection: some View {

        VStack(alignment: .leading, spacing: 6) {

            HStack(spacing: 6) {

                Image("icon_exp")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)

                Text("LV \(progress.level)")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }

            expBar
                .frame(width: 120)
        }
    }
}

extension GameHeaderView {

    var expBar: some View {

        GeometryReader { geo in

            let maxEXP = max(progress.requiredEXP, 1)
            let ratio = CGFloat(progress.exp) / CGFloat(maxEXP)

            ZStack(alignment: .leading) {

                Capsule()
                    .fill(Color.white.opacity(0.15))

                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.cyan, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geo.size.width * ratio)
                    .animation(.easeOut(duration: 0.25), value: ratio)
            }
        }
        .frame(height: 10)
    }
}

extension GameHeaderView {

    var currencySection: some View {

        HStack(spacing: 14) {

            // ⭐ Normale
            currencyItem(icon: "icon_gem", value: gems.gems)
            currencyItem(icon: "icon_coin", value: coins.coins)

            // ⭐ Info Button
            Button {
                showCurrencySheet = true
            } label: {
                Image(systemName: "info.circle")
                    .foregroundStyle(.white)
                    .font(.title3)
            }
        }
        .sheet(isPresented: $showCurrencySheet) {
            CurrencyOverviewSheet()
                .environmentObject(appModel)  // ⭐ NICHT VERGESSEN
        }
    }

    func currencyItem(icon: String, value: Int) -> some View {

        HStack(spacing: 6) {

            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)

            Text(value.formatted())
                .font(.subheadline.bold())
                .foregroundStyle(.white)
        }
    }

    func currencyCard(
        icon: String,
        gradient: [Color],
        value: Int
    ) -> some View {

        HStack(spacing: 10) {

            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)

            Text(value.formatted())
                .font(.subheadline.bold())
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
            .opacity(0.18)
        )

        .clipShape(Capsule())

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
    }
}
