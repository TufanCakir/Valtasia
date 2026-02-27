//
//  EnemyInstance.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

final class EnemyInstance {

    let base: Enemy
    var hp: Int

    init(base: Enemy) {
        self.base = base
        self.hp = base.hp  // ✅ statt base.stats.hp
    }
}
