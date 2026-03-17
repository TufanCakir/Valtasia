//
//  CurrencyOverviewSheet.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import SwiftUI

struct CurrencyOverviewSheet: View {

    @EnvironmentObject var appModel: AppModel

    @ObservedObject var coins = CoinManager.shared
    @ObservedObject var gems = GemManager.shared
    @ObservedObject var corruptedCoins = CorruptedCoinManager.shared
    @ObservedObject var corruptedGems = CorruptedGemManager.shared

    var theme: UITheme {
        appModel.homeMode == .portal ? .portal : .island
    }

    var body: some View {

        ZStack {

            // 🔥 Background
            LinearGradient(
                colors: theme.borderGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {

                Text("Currencies")
                    .font(.title.bold())
                    .foregroundStyle(.white)

                // ⭐ Normal
                currencyCard(
                    title: "Coins",
                    icon: "icon_coin",
                    value: coins.coins,
                    gradient: [.yellow, .orange]
                )

                currencyCard(
                    title: "Gems",
                    icon: "icon_gem",
                    value: gems.gems,
                    gradient: [.cyan, .blue]
                )

                // ⭐ Corrupted
                currencyCard(
                    title: "Corrupted Coins",
                    icon: "icon_c_coin",
                    value: corruptedCoins.coins,
                    gradient: [.green, .purple]
                )

                currencyCard(
                    title: "Corrupted Gems",
                    icon: "icon_c_gem",
                    value: corruptedGems.gems,
                    gradient: [.green, .purple]
                )

            }
            .padding()
        }
    }

    // MARK: Card

    func currencyCard(
        title: String,
        icon: String,
        value: Int,
        gradient: [Color]
    ) -> some View {

        HStack(spacing: 26) {

            Image(icon)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 50)

            VStack(alignment: .leading, spacing: 5) {

                Text(title)
                    .font(.title)
                    .foregroundStyle(.white)

                Text(value.formatted())
                    .font(.title.bold())
                    .foregroundStyle(.white)
            }

            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                colors: gradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: gradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(
            color: gradient.first?.opacity(0.4) ?? .clear,
            radius: 10
        )
    }
}

#Preview {
    CurrencyOverviewSheet()
        .environmentObject(AppModel())
}
