//
//  CombatCalculator.swift
//  Valtasia
//
//  Created by Tufan Cakir on 01.03.26.
//

import Foundation

enum CombatCalculator {

    // MARK: - Public API

    static func basicDamage(
        owned: OwnedCharacter,
        crack: Crack,
        enemyDefense: Double = 0
    ) -> DamageResult {

        let stats = scaledStats(for: owned)

        let baseDamage =
            stats.attack +
            stats.energy * 0.25

        let modified =
            baseDamage * crack.damageMultiplier

        return finalDamage(
            from: modified,
            owned: owned,
            enemyDefense: enemyDefense
        )
    }

    static func skillDamage(
        owned: OwnedCharacter,
        skill: Skill,
        enemyDefense: Double = 0
    ) -> DamageResult {

        let stats = scaledStats(for: owned)

        let baseDamage =
            stats.attack * skill.multiplier

        return finalDamage(
            from: baseDamage,
            owned: owned,
            enemyDefense: enemyDefense
        )
    }
}

//
// MARK: - Models
//

struct DamageResult {
    let amount: Int
    let isCrit: Bool
}

//
// MARK: - Internal
//

private extension CombatCalculator {

    struct ScaledStats {
        let attack: Double
        let energy: Double
        let critChance: Double
        let critDamage: Double
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

        // ⭐ Future JSON Hook möglich
        let critChance = 0.10
        let critDamage = 1.75

        return ScaledStats(
            attack: attack,
            energy: energy,
            critChance: critChance,
            critDamage: critDamage
        )
    }

    static func finalDamage(
        from raw: Double,
        owned: OwnedCharacter,
        enemyDefense: Double
    ) -> DamageResult {

        var damage = raw

        // ⭐ Damage Variation (±10%)
        let variation =
            Double.random(in: 0.9...1.1)

        damage *= variation

        // ⭐ Defense Reduction
        damage -= enemyDefense
        damage = max(damage, 1)

        // ⭐ Crit Roll
        let stats = scaledStats(for: owned)

        let isCrit =
            Double.random(in: 0...1)
            <= stats.critChance

        if isCrit {
            damage *= stats.critDamage
        }

        return DamageResult(
            amount: Int(damage),
            isCrit: isCrit
        )
    }
}
