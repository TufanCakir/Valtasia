//
//  GemManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class GemManager: ObservableObject {

    static let shared = GemManager()

    @Published private(set) var gems: Int = 0

    private let key = "valtasia_gems"

    private init() {
        load()
    }
    
    func reset() {
        gems = 0
        save()
    }

    // MARK: Add

    func add(_ amount: Int) {

        guard amount > 0 else { return }

        gems += amount

        save()
    }

    // MARK: Spend

    @discardableResult
    func spend(_ amount: Int) -> Bool {

        guard gems >= amount else {
            return false
        }

        gems -= amount

        save()

        return true
    }

    private func save() {

        UserDefaults.standard.set(
            gems,
            forKey: key
        )
    }

    private func load() {

        gems =
            UserDefaults.standard.integer(
                forKey: key
            )
    }
}
