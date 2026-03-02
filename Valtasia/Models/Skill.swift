//
//  Skill.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

struct Skill: Codable, Identifiable, Hashable {

    let id: String
    let name: String
    let type: SkillType
    let multiplier: Double

    let cooldown: Double?  // ⭐ NEU

    let particle: String?
    let color: String?
}
