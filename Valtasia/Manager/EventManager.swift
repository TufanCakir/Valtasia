//
//  EventManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine  // ⭐ hinzufügen
import Foundation

class EventManager: ObservableObject {  // ⭐ hinzufügen

    static let shared = EventManager()

    @Published var events: [GameEvent] = []  // ⭐ wichtig !!

    func load() {

        do {

            events = try JSONLoader.load("events")

            print("Loaded Events:", events.count)

        } catch {

            print(error)

        }
    }

    func activeEvents() -> [GameEvent] {

        let now = Date()

        return events.filter { event in

            let key = "event_start_\(event.id)"

            // Wenn noch kein Start gespeichert → jetzt starten
            if UserDefaults.standard.object(forKey: key) == nil {
                UserDefaults.standard.set(now, forKey: key)
            }

            guard let start = UserDefaults.standard.object(forKey: key) as? Date
            else {
                return false
            }

            guard
                let end = Calendar.current.date(
                    byAdding: .day,
                    value: 7,
                    to: start
                )
            else {
                return false
            }

            if now > end {
                UserDefaults.standard.set(now, forKey: key)
                return true
            }
            return true
        }
    }
}
