//
//  CombatCalculator.swift
//  Valtasia
//
//  Created by Tufan Cakir on 01.03.26.
//

import Foundation

enum CombatCalculator {

    // MARK: - Public Damage API

    static func basicDamage(
        owned: OwnedCharacter,
        crack: Crack
    ) -> Int {

        let stats = scaledStats(for: owned)

        let baseDamage =
            stats.attack
            + stats.energy * 0.25

        let modified =
            baseDamage * crack.damageMultiplier

        return finalDamage(from: modified)
    }

    static func skillDamage(
        owned: OwnedCharacter,
        skill: Skill
    ) -> Int {

        let stats = scaledStats(for: owned)

        let baseDamage =
            stats.attack * skill.multiplier

        return finalDamage(from: baseDamage)
    }
}

//
// MARK: - Internal Helpers
//

private extension CombatCalculator {

    struct ScaledStats {
        let attack: Double
        let energy: Double
    }

    static func scaledStats(
        for owned: OwnedCharacter
    ) -> ScaledStats {

        let level = owned.level
        let growth = owned.base.rarity.growthRate

        let multiplier =
            pow(growth, Double(level - 1))

        let attack =
            Double(owned.base.stats.attack)
            * multiplier

        let energy =
            Double(owned.base.stats.energyPower)
            * multiplier

        return ScaledStats(
            attack: attack,
            energy: energy
        )
    }

    static func finalDamage(
        from raw: Double
    ) -> Int {

        // 🔥 future hooks:
        // - crit
        // - buffs
        // - debuffs
        // - element counters

        let critMultiplier = rollCrit()

        return Int(raw * critMultiplier)
    }

    static func rollCrit() -> Double {

        let critChance = 0.10   // 10% default
        let critDamage = 1.75   // 75% bonus

        if Double.random(in: 0...1) <= critChance {
            return critDamage
        }

        return 1.0
    }
}
