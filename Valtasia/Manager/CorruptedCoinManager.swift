//
//  CorruptedCoinManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import Foundation
import Combine

final class CorruptedCoinManager: ObservableObject {

    static let shared = CorruptedCoinManager()

    @Published private(set) var coins: Int = 0

    private let key = "valtasia_corrupted_coins"

    private init() {
        load()
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
