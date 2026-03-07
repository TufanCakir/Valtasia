//
//  EventRoot.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

struct EventRoot: Codable {
    var categories: [EventCategoryInfo]
    var events: [GameEvent]
}
