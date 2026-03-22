//
//  CorruptedCoinManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import Combine
import Foundation

final class CorruptedCoinManager: ObservableObject {

    static let shared = CorruptedCoinManager()

    @Published private(set) var coins: Int = 0

    private let key = "valtasia_corrupted_coins"

    private init() {
        load()
    }

    func spend(_ amount: Int) -> Bool {
        guard amount > 0, coins >= amount else { return false }
        coins -= amount
        save()
        return true
    }

    func add(_ amount: Int) {
        guard amount > 0 else { return }
        coins += amount
        save()
    }

    func reset() {
        coins = 0
        save()
    }

    private func save() {
        UserDefaults.standard.set(coins, forKey: key)
    }

    private func load() {
        coins = UserDefaults.standard.integer(forKey: key)
    }
}
