//
//  ExchangeManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import Foundation

final class ExchangeManager: ObservableObject {

    static let shared = ExchangeManager()

    @Published var offers: [ExchangeOffer] = []

    @Published private(set)
        var purchased: [String: Int] = [:]

    private let purchaseKey =
        "exchange_purchases"

    private init() {

        loadOffers()
        loadPurchases()
    }

    // MARK: Load JSON

    private func loadOffers() {

        do {

            offers =
                try JSONLoader.load("exchange")

        } catch {

            print(error)
        }
    }

    // MARK: Buy

    func buy(
        offer: ExchangeOffer
    ) -> Bool {

        let bought =
            purchased[offer.id] ?? 0

        guard bought < offer.purchaseLimit
        else { return false }

        // coins spend
        guard
            CoinManager.shared
                .spend(offer.coinCost)
        else { return false }

        // gems add
        GemManager.shared
            .add(offer.gemReward)

        purchased[offer.id] =
            bought + 1

        save()

        return true
    }

    func remaining(
        _ offer: ExchangeOffer
    ) -> Int {

        let bought =
            purchased[offer.id] ?? 0

        return max(
            0,
            offer.purchaseLimit - bought
        )
    }

    // MARK: Save

    private func save() {

        UserDefaults.standard.set(
            purchased,
            forKey: purchaseKey
        )
    }

    private func loadPurchases() {

        purchased =
            UserDefaults.standard
            .dictionary(
                forKey: purchaseKey
            ) as? [String: Int]
            ?? [:]
    }
}
