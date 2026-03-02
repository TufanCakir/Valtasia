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

    let maxHP: Int
    var hp: Int

    init(base: Enemy, level: Int) {

        self.base = base
        self.level = level

        let growth = base.growthRate ?? 1.08

        let scaledHP = Double(base.hp) * pow(growth, Double(level - 1))

        self.maxHP = Int(scaledHP)
        self.hp = self.maxHP
    }
}
