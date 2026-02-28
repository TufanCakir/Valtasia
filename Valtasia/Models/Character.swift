//
//  Character.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

struct Character: Codable, Identifiable, Hashable {

    let id: String
    let name: String
    let rarity: Rarity
    let role: String
    let skills: [Skill]
    let stats: Stats
    let energyType: String

    let summon: SummonInfo

    let sprite: String
    let skins: [Skin]

    // computed -> ok
    var defaultSkin: Skin? {
        skins.first(where: { $0.id == "default" }) ?? skins.first
    }

    struct Stats: Codable, Hashable {
        let hp: Int
        let attack: Int
        let energyPower: Int
        let attackSpeed: Double
    }

    struct Skin: Codable, Identifiable, Hashable {
        let id: String
        let sprite: String
    }
}

struct Skill: Codable, Identifiable, Hashable {

    let id: String
    let name: String
    let type: SkillType
    let multiplier: Double
    let particle: String?
    let color: String?
}
