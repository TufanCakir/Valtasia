//
//  DailyRewardManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import Combine
import Foundation

final class DailyRewardManager: ObservableObject {

    static let shared = DailyRewardManager()

    @Published private(set) var currentDay: Int = 1
    @Published private(set) var canClaimToday: Bool = false

    private let lastClaimKey = "daily_last_claim"
    private let dayKey = "daily_current_day"

    private init() {
        load()
        checkAvailability()
    }

    // MARK: - Rewards Definition

    struct Reward {
        let coins: Int
        let crystals: Int
        let exp: Int
    }

    let rewards: [Reward] = [
        .init(coins: 200, crystals: 5, exp: 50),
        .init(coins: 300, crystals: 5, exp: 70),
        .init(coins: 400, crystals: 10, exp: 90),
        .init(coins: 500, crystals: 10, exp: 120),
        .init(coins: 600, crystals: 15, exp: 150),
        .init(coins: 800, crystals: 20, exp: 200),
        .init(coins: 1500, crystals: 50, exp: 500),  // Day 7 Big Reward
    ]

    // MARK: - Claim Logic

    func claim() {

        guard canClaimToday else { return }

        let reward = rewards[currentDay - 1]

        CoinManager.shared.add(reward.coins)
        CrystalManager.shared.add(reward.crystals)
        PlayerProgressManager.shared.addEXP(reward.exp)

        saveClaimDate()

        advanceDay()
        canClaimToday = false
    }

    private func advanceDay() {

        currentDay += 1

        if currentDay > rewards.count {
            currentDay = 1
        }

        UserDefaults.standard.set(currentDay, forKey: dayKey)
    }

    // MARK: - Date Check

    private func checkAvailability() {

        let lastClaim =
            UserDefaults.standard.object(forKey: lastClaimKey) as? Date

        if let lastClaim {
            canClaimToday = !Calendar.current.isDateInToday(lastClaim)
        } else {
            canClaimToday = true
        }
    }

    private func saveClaimDate() {

        UserDefaults.standard.set(Date(), forKey: lastClaimKey)
    }

    private func load() {

        currentDay = max(1, UserDefaults.standard.integer(forKey: dayKey))
    }
}
