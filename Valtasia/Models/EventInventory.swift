//
//  EventInventory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import Foundation

final class EventInventory: ObservableObject {

    static let shared = EventInventory()

    @Published var tokens: Int = 0

    private let key = "event_tokens"

    init() {

        tokens = UserDefaults.standard.integer(forKey: key)

    }

    func addTokens(_ amount: Int) {

        tokens += amount

        UserDefaults.standard.set(tokens, forKey: key)

    }
}
