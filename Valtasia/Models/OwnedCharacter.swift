//
//  OwnedCharacter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation
import SwiftUI

final class OwnedCharacter: Codable, Identifiable {

    let id: String
    let baseId: String
    let base: Character

    var level: Int = 1
    var exp: Int = 0
    var stars: Int = 1   // ⭐ 1–7 (7 = Corrupted)

    // MARK: - ⭐ STAR MULTIPLIER

    var starMultiplier: Double {
        switch stars {
        case 1: return 1.0
        case 2: return 1.05
        case 3: return 1.10
        case 4: return 1.18
        case 5: return 1.26
        case 6: return 1.35
        case 7: return 1.55   // 🔥 CORRUPTED BOOST
        default: return 1.0
        }
    }
    
    // MARK: - STAR COLOR

    var starColor: Color {
        if isCorrupted {
            return .green   // 🔥 corrupted override
        }
        return base.rarity.color
    }

    var starGradient: LinearGradient {
        if isCorrupted {
            return LinearGradient(
                colors: [.red, .purple, .black],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [base.rarity.color, .white.opacity(0.6)],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
    // MARK: - ⭐ STATES

    var isMaxStar: Bool {
        stars == 7
    }

    var isCorrupted: Bool {
        stars == 7
    }

    // MARK: - EXP SYSTEM

    var requiredEXP: Int {
        Int(100 * pow(1.12, Double(level - 1)))
    }

    // MARK: - INIT

    init(base: Character) {
        self.id = UUID().uuidString
        self.baseId = base.id
        self.base = base
    }

    // MARK: - PROGRESSION

    func addStars(_ amount: Int = 1) {
        let oldStars = stars
        stars = min(stars + amount, 7)

        if stars == 7 && oldStars < 7 {
            print("🔥 \(base.name) has become CORRUPTED!")
        }
    }

    func addEXP(_ amount: Int) {
        exp += amount

        while exp >= requiredEXP {
            exp -= requiredEXP
            level += 1
            print("⭐ \(base.name) LEVEL UP → \(level)")
        }
    }
}
