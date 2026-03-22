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
    @Published private(set) var purchasedNormal: [String: Int] = [:]
    @Published private(set) var purchasedCorrupted: [String: Int] = [:]

    private let purchaseKeyNormal = "exchange_purchases_normal"
    private let purchaseKeyCorrupted = "exchange_purchases_corrupted"

    private init() {
        loadOffers()
        loadPurchases()
    }

    // MARK: - Remaining
    func remaining(_ offer: ExchangeOffer, isCorrupted: Bool) -> Int {

        let bought = isCorrupted
            ? purchasedCorrupted[offer.id] ?? 0
            : purchasedNormal[offer.id] ?? 0

        return max(0, offer.purchaseLimit - bought)
    }

    // MARK: - Reset
    func reset() {
        purchasedNormal = [:]
        purchasedCorrupted = [:]
        save()
    }

    // MARK: - Load JSON
    private func loadOffers() {
        do {
            offers = try JSONLoader.load("exchange")
        } catch {
            print("❌ Failed to load exchange:", error)
        }
    }

    // MARK: - Buy
    func buy(offer: ExchangeOffer, isCorrupted: Bool) -> Bool {

        let bought = isCorrupted
            ? purchasedCorrupted[offer.id] ?? 0
            : purchasedNormal[offer.id] ?? 0

        guard bought < offer.purchaseLimit else { return false }

        let success: Bool

        if isCorrupted {

            guard let cost = offer.corruptedCoinCost,
                  let reward = offer.corruptedGemReward
            else { return false }

            success = CorruptedCoinManager.shared.spend(cost)

            if success {
                CorruptedGemManager.shared.add(reward)
                purchasedCorrupted[offer.id] = bought + 1
            }

        } else {

            guard let cost = offer.coinCost,
                  let reward = offer.gemReward
            else { return false }

            success = CoinManager.shared.spend(cost)

            if success {
                GemManager.shared.add(reward)
                purchasedNormal[offer.id] = bought + 1
            }
        }

        guard success else { return false }

        save()
        return true
    }

    // MARK: - Persistence
    private func save() {
        UserDefaults.standard.set(purchasedNormal, forKey: purchaseKeyNormal)
        UserDefaults.standard.set(purchasedCorrupted, forKey: purchaseKeyCorrupted)
    }

    private func loadPurchases() {
        purchasedNormal =
            UserDefaults.standard.dictionary(forKey: purchaseKeyNormal)
            as? [String: Int] ?? [:]

        purchasedCorrupted =
            UserDefaults.standard.dictionary(forKey: purchaseKeyCorrupted)
            as? [String: Int] ?? [:]
    }
}
