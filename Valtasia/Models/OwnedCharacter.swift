//
//  OwnedCharacter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

final class OwnedCharacter: Codable, Identifiable {

    let id: String
    let baseId: String  // ⭐ wichtig für Dupe-Erkennung
    let base: Character

    var level: Int = 1
    var exp: Int = 0
    var stars: Int = 1  // ⭐ 1–6 Sterne

    // ⭐ EXP exponentiell
    var requiredEXP: Int {
        Int(100 * pow(1.12, Double(level - 1)))
    }

    // ⭐ Sterne-Bonus (für CombatCalculator)
    var starMultiplier: Double {
        1.0 + Double(stars - 1) * 0.15  // +15% pro Stern
    }

    init(base: Character) {
        self.id = UUID().uuidString
        self.baseId = base.id
        self.base = base
    }

    // ⭐ Sterne erhöhen
    func addStars(_ amount: Int = 1) {
        stars = min(stars + amount, 6)
    }

    // ⭐ EXP & LevelUp
    func addEXP(_ amount: Int) {
        exp += amount

        while exp >= requiredEXP {
            exp -= requiredEXP
            level += 1
            print("⭐ \(base.name) LEVEL UP → \(level)")
        }
    }
}
