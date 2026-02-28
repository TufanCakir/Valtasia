//
//  GameEvent.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

struct GameEvent: Codable, Identifiable, Hashable {

    var id: String
    var title: String
    var type: String

    var description: String?

    var start: String

    var modifiers: EventModifiers?

    var bossEnemy: String?
    var bossLevelId: String?

    var hero: String?
    var rateUpMultiplier: Double?

    // ⭐ ADD THIS

    var rewards: EventRewards?
}

struct EventRewards: Codable, Hashable {

    var coins: Int?
    var crystals: Int?
    var exp: Int?
    var eventToken: Int?

}

struct EventModifiers: Codable, Hashable {

    let crackColor: String?
    let spawnMultiplier: Double?
}
