//
//  CoinManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation
import Combine

final class CoinManager: ObservableObject {

    static let shared = CoinManager()

    @Published private(set) var coins: Int = 0

    private let key = "valtasia_coins"

    private init() {
        load()
    }

    // MARK: Add

    func add(_ amount: Int) {

        guard amount > 0 else { return }

        coins += amount

        save()
    }

    // MARK: Spend

    @discardableResult
    func spend(_ amount: Int) -> Bool {

        guard coins >= amount else { return false }

        coins -= amount

        save()

        return true
    }

    // MARK: Save

    private func save() {

        UserDefaults.standard.set(
            coins,
            forKey: key
        )
    }

    // MARK: Load

    private func load() {

        coins =
        UserDefaults.standard.integer(
            forKey: key
        )
    }
}
