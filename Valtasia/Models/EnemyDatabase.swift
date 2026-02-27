//
//  EnemyDatabase.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

final class EnemyDatabase {

    static let shared = EnemyDatabase()

    private(set) var enemies: [Enemy] = []

    private init() {
        loadEnemies()
    }

    private func loadEnemies() {
        do {
            enemies = try JSONLoader.load("enemies")
            print("EnemyDatabase loaded:", enemies.count)
        } catch {
            print("Failed loading enemies:", error)
        }
    }

    func enemy(id: String) -> Enemy? {
        enemies.first { $0.id == id }
    }
}
