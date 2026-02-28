//
//  OwnedCharacter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

final class OwnedCharacter: Codable, Identifiable {

    let id: String
    var level: Int = 1
    var exp: Int = 0

    let base: Character

    init(base: Character) {
        self.base = base
        self.id = UUID().uuidString
    }
}

extension OwnedCharacter {

    func addEXP(_ amount: Int) {

        exp += amount

        while exp >= requiredEXP {

            exp -= requiredEXP
            level += 1

            print("⭐ \(base.name) LEVEL UP → \(level)")
        }
    }

    var requiredEXP: Int {

        50 + level * 20
    }
}
