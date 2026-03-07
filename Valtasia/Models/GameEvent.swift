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

    var category: EventCategory  // ⭐ NEU

    var description: String?
    var icon: String?
    var battleBackground: String?
    var modifiers: EventModifier?
    var startDate: String?
    var endDate: String?
    var durationDays: Int?
    var bossEnemy: String?
    var bossLevelId: String?
    var hero: String?
    var rateUpMultiplier: Double?
    var rewards: EventRewards?
}

struct EventRewards: Codable, Hashable {

    var coins: Int?
    var crystals: Int?
    var exp: Int?
    var eventToken: Int?

}

struct EventModifier: Codable, Hashable {

    let expMultiplier: Double?
    let coinMultiplier: Double?
    let crystalMultiplier: Double?

    let spawnMultiplier: Double?
}

enum EventCategory: String, Codable, CaseIterable, Hashable {
    case story = "story"
    case original = "original"
    case special = "special"
    case boss = "boss"
    case buff = "buff"
}
