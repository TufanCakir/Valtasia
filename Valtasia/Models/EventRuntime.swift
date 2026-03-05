//
//  EventRuntime.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

class EventRuntime {

    static let shared = EventRuntime()

    var activeEvent: GameEvent?
    var crackSpawnMultiplier: Double = 1.0
    var activeEventWorld: EventWorld?

    func activate(_ event: GameEvent) {

        activeEvent = event

        if event.type == "boss" {

            activeEventWorld = EventWorld(
                id: event.id,
                background: event.battleBackground ?? "ocean_bg",
                bossLevelId: event.bossLevelId ?? ""
            )
        }

        if let multi = event.modifiers?.spawnMultiplier {
            crackSpawnMultiplier = multi
        }
    }

    func clear() {
        activeEvent = nil
        activeEventWorld = nil
        crackSpawnMultiplier = 1.0
    }
}
