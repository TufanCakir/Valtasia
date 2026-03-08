//
//  PityManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 08.03.26.
//

import Foundation

final class PityManager {

    static let shared = PityManager()
    private let prefix = "pity_"

    func pulls(for bannerId: String) -> Int {
        UserDefaults.standard.integer(forKey: prefix + bannerId)
    }

    func addPull(for bannerId: String) {
        let current = pulls(for: bannerId)
        UserDefaults.standard.set(current + 1, forKey: prefix + bannerId)
    }

    func reset(for bannerId: String) {
        UserDefaults.standard.set(0, forKey: prefix + bannerId)
    }
}
