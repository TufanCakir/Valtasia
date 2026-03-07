//
//  EventDatabase.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

class EventDatabase {

    static let shared = EventDatabase()

    private(set) var levels: [EventLevel] = []

    init() {

        do {

            levels = try JSONLoader.load("event_levels")

        } catch {

            print(error)

        }

    }

    func level(id: String) -> EventLevel? {

        levels.first { $0.id == id }

    }

}
