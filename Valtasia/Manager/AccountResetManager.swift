//
//  AccountResetManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import Foundation

final class AccountResetManager {

    static func resetAll() {

        let defaults = UserDefaults.standard

        // 🔥 Kompletter UserDefaults Reset
        if let bundleID = Bundle.main.bundleIdentifier {
            defaults.removePersistentDomain(forName: bundleID)
        }

        defaults.synchronize()
    }
}
