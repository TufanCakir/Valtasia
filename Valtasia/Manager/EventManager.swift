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
    @Published var categories: [EventCategoryInfo] = []  // ⭐ NEU

    func load() {
        do {
            let root: EventRoot = try JSONLoader.load("events")
            events = root.events
            categories = root.categories
            print("Loaded Events:", events.count)
        } catch {
            print(error)
        }
    }

    func crystalMultiplier() -> Double {

        activeEvents()
            .compactMap { $0.modifiers?.crystalMultiplier }
            .reduce(1.0, *)
    }

    func coinMultiplier() -> Double {

        activeEvents()
            .compactMap { $0.modifiers?.coinMultiplier }
            .reduce(1.0, *)
    }

    func title(for category: EventCategory) -> String {
        categories.first { $0.id == category.rawValue }?.title
            ?? category.rawValue.capitalized
    }

    func events(for category: EventCategory) -> [GameEvent] {
        activeEvents().filter { $0.category == category }
    }

    var bossEvents: [GameEvent] {
        events(for: .boss)
    }

    var storyEvents: [GameEvent] {
        events(for: .story)
    }

    var specialEvents: [GameEvent] {
        events(for: .special)
    }

    var buffEvents: [GameEvent] {
        events(for: .buff)
    }

    func expMultiplier() -> Double {

        activeEvents()
            .compactMap {
                $0.modifiers?.expMultiplier
            }
            .reduce(1.0, *)
    }

    func activeEvents() -> [GameEvent] {

        let now = Date()

        return events.filter { event in

            // 1️⃣ Datum Event (wenn definiert)
            if let startString = event.startDate,
                let endString = event.endDate
            {

                let formatter = ISO8601DateFormatter()

                guard let start = formatter.date(from: startString),
                    let end = formatter.date(from: endString)
                else { return false }

                return now >= start && now <= end
            }

            // 2️⃣ Auto Duration Event
            let duration = event.durationDays ?? 7

            let key = "event_start_\(event.id)"

            if UserDefaults.standard.object(forKey: key) == nil {
                UserDefaults.standard.set(now, forKey: key)
            }

            guard let start = UserDefaults.standard.object(forKey: key) as? Date
            else { return false }

            guard
                let end = Calendar.current.date(
                    byAdding: .day,
                    value: duration,
                    to: start
                )
            else { return false }

            return now <= end
        }
    }
}
