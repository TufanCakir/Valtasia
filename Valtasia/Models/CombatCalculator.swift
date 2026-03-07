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
            stats.attack + stats.energy * 0.25

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
        let level = owned.level

        // ⭐ Skill Curve (stärker als Basic)
        let skillCurve: Double = 1.18

        let levelMultiplier =
            pow(Double(level), skillCurve * 0.35)

        // ⭐ Energy macht Skills stärker
        let energyBonus =
            stats.energy * 0.35

        let baseDamage =
            (stats.attack + energyBonus)
            * skill.multiplier
            * levelMultiplier

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

extension CombatCalculator {

    fileprivate struct ScaledStats {
        let attack: Double
        let energy: Double
        let critChance: Double
        let critDamage: Double
    }

    fileprivate static func scaledStats(
        for owned: OwnedCharacter
    ) -> ScaledStats {

        let level = owned.level
        let growth = owned.base.rarity.growthRate
        let starMulti = owned.starMultiplier  // ⭐⭐⭐

        let multiplier =
            pow(growth, Double(level - 1))

        let attack =
            Double(owned.base.stats.attack)
            * multiplier
            * starMulti  // ⭐ Sterne buff

        let energy =
            Double(owned.base.stats.energyPower)
            * multiplier
            * starMulti  // ⭐ Sterne buff

        let critChance = 0.10
        let critDamage = 1.75

        return ScaledStats(
            attack: attack,
            energy: energy,
            critChance: critChance,
            critDamage: critDamage
        )
    }

    fileprivate static func finalDamage(
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
