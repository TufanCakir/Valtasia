//
//  CrystalManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class CrystalManager: ObservableObject {

    static let shared = CrystalManager()

    @Published private(set) var crystals: Int = 0

    private let key = "valtasia_crystals"

    private init() {
        load()
    }

    // MARK: Add

    func add(_ amount: Int) {

        guard amount > 0 else { return }

        crystals += amount

        save()
    }

    // MARK: Spend

    @discardableResult
    func spend(_ amount: Int) -> Bool {

        guard crystals >= amount else {
            return false
        }

        crystals -= amount

        save()

        return true
    }

    private func save() {

        UserDefaults.standard.set(
            crystals,
            forKey: key
        )
    }

    private func load() {

        crystals =
            UserDefaults.standard.integer(
                forKey: key
            )
    }
}
