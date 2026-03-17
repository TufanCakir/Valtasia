//
//  EnemyInstance.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

final class EnemyInstance {

    let base: Enemy
    let level: Int

    var maxHP: Int
    var hp: Int

    init(
        base: Enemy,
        level: Int,
        hpMultiplier: Double = 1.0 // ⭐ NEU
    ) {
        self.base = base
        self.level = level

        let growth = base.growthRate ?? 1.08

        let scaledHP =
            Double(base.hp)
            * pow(growth, Double(level - 1))
            * hpMultiplier   // ⭐ HIER PASSIERT PORTAL SCALING

        self.maxHP = Int(scaledHP)
        self.hp = self.maxHP
    }
}
