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
            
        }catch{
            
            print(error)
            
        }
    }
    
    func activeEvents() -> [GameEvent] {
        
        let now = Date()
        
        return events.filter {
            
            guard let start = $0.start.date else {
                return false
            }
            
            // ⭐ automatisch 7 Tage Dauer
            guard let end = Calendar.current.date(
                byAdding: .day,
                value: 7,
                to: start
            ) else {
                return false
            }
            
            print("Now:", now)
            print("Start:", start)
            print("End:", end)
            
            let active = now >= start && now <= end
            
            print("Is Active:", active)
            
            return active
        }
    }}

extension String {

    var date: Date? {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return formatter.date(from: self)
    }
}
