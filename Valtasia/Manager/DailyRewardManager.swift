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

    @Published private(set) var rewards: [DailyReward] = []
    @Published private(set) var currentDay: Int = 1
    @Published private(set) var canClaimToday: Bool = false

    private let lastClaimKey = "daily_last_claim"
    private let dayKey = "daily_current_day"

    private init() {
        rewards = DailyRewardLoader.load()
        load()
        checkAvailability()
    }

    // MARK: - RESET

    func reset() {
        currentDay = 1
        canClaimToday = true

        let d = UserDefaults.standard
        d.removeObject(forKey: lastClaimKey)
        d.set(1, forKey: dayKey)
    }

    // MARK: - CLAIM

    func claim() {
        guard canClaimToday else { return }
        guard let reward = rewardForToday else { return }

        apply(reward)

        saveClaimDate()
        advanceDay()
        canClaimToday = false
    }

    // MARK: - APPLY REWARD (🔥 ZENTRAL)
    private func apply(_ reward: DailyReward) {

        if let coins = reward.coins {
            CoinManager.shared.add(coins)
        }

        if let gems = reward.gems {
            GemManager.shared.add(gems)
        }

        if let exp = reward.exp {
            PlayerProgressManager.shared.addEXP(exp)
        }

        if let cCoins = reward.corruptedCoins {
            CorruptedCoinManager.shared.add(cCoins)
        }

        if let cGems = reward.corruptedGems {
            CorruptedGemManager.shared.add(cGems)
        }
    }

    // MARK: - HELPERS

    private var rewardForToday: DailyReward? {
        rewards.first(where: { $0.day == currentDay })
    }

    private func advanceDay() {
        currentDay += 1

        if currentDay > rewards.count {
            currentDay = 1
        }

        UserDefaults.standard.set(currentDay, forKey: dayKey)
    }

    // MARK: - DATE CHECK

    private func checkAvailability() {
        let lastClaim = UserDefaults.standard.object(forKey: lastClaimKey) as? Date

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
        let savedDay = UserDefaults.standard.integer(forKey: dayKey)
        currentDay = savedDay == 0 ? 1 : savedDay
    }
}
