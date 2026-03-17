//
//  CurrencyOverviewSheet.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import SwiftUI

struct CurrencyOverviewSheet: View {

    @ObservedObject var coins = CoinManager.shared
    @ObservedObject var gems = GemManager.shared
    @ObservedObject var corruptedCoins = CorruptedCoinManager.shared
    @ObservedObject var corruptedGems = CorruptedGemManager.shared

    var body: some View {

        VStack(spacing: 24) {

            Text("Currencies")
                .font(.title.bold())

            Divider()

            currencyRow("Coins", coins.coins)
            currencyRow("Gems", gems.gems)

            Divider()

            currencyRow("Corrupted Coins", corruptedCoins.coins)
            currencyRow("Corrupted Gems", corruptedGems.gems)

            Spacer()
        }
        .padding()
    }

    func currencyRow(_ title: String, _ value: Int) -> some View {
        HStack {
            Text(title)
            Spacer()
            Text(value.formatted())
                .bold()
        }
    }
}
