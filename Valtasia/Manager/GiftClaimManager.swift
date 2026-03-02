//
//  GiftClaimManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import Foundation

final class GiftClaimManager {

    static let shared = GiftClaimManager()

    private let key = "claimed_gifts"

    private var claimed: Set<String> = []

    private init() {
        load()
    }

    // MARK: Check

    func isClaimed(_ id: String) -> Bool {

        claimed.contains(id)
    }

    // MARK: Claim

    func claim(_ id: String) {

        claimed.insert(id)
        save()
    }

    // MARK: Save

    private func save() {

        UserDefaults.standard.set(
            Array(claimed),
            forKey: key
        )
    }

    private func load() {

        let saved =
            UserDefaults.standard.stringArray(
                forKey: key
            ) ?? []

        claimed = Set(saved)
    }
}
