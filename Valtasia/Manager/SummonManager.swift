//
//  SummonManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class SummonManager: ObservableObject {

    @Published var characters: [Character] = []
    @Published var banners: [SummonBanner] = []

    private var characterMap: [String: Character] = [:]

    init() {
        loadCharacters()
        loadBanners()
    }

    // MARK: - Loading

    private func loadCharacters() {
        do {
            characters = try JSONLoader.load("characters")
            characterMap = Dictionary(
                uniqueKeysWithValues:
                    characters.map { ($0.id, $0) }
            )
            print("Loaded Characters:", characters.count)
        } catch {
            print(error)
        }
    }

    private func loadBanners() {
        do {
            banners = try JSONLoader.load("summon")
        } catch {
            print(error)
        }
    }

    // MARK: - Pool Entries

    private func entries(
        for banner: SummonBanner,
        applyLimit: Bool
    ) -> [SummonPoolEntry] {

        if applyLimit, banner.poolLimit > 0 {
            return Array(banner.pool.prefix(banner.poolLimit))
        } else {
            return banner.pool
        }
    }

    // MARK: - Rates (Info Sheet)

    /// Shows FULL pool unless poolLimit > 0
    func rates(for bannerId: String) -> [CharacterRate] {

        guard
            let banner =
                banners.first(where: { $0.id == bannerId })
        else { return [] }

        let entries = entries(
            for: banner,
            applyLimit: false  // ⭐ alle anzeigen
        )

        return entries.compactMap { entry in
            guard
                let character =
                    characterMap[entry.characterId]
            else { return nil }

            return CharacterRate(
                character: character,
                rate: entry.rate,
                isRateUp: entry.rateUp
            )
        }
        .sorted { $0.rate > $1.rate }
    }

    // MARK: - Summon Logic

    /// Uses poolLimit if set
    func summon(from bannerId: String) -> Character? {

        guard
            let banner =
                banners.first(where: { $0.id == bannerId })
        else { return nil }

        let entries = entries(
            for: banner,
            applyLimit: true  // ⭐ Limit gilt nur fürs Ziehen
        )

        guard !entries.isEmpty else { return nil }

        let totalRate =
            entries.reduce(0.0) { $0 + max(0, $1.rate) }

        guard totalRate > 0 else { return nil }

        let roll =
            Double.random(in: 0..<totalRate)

        var current = 0.0

        for entry in entries {
            current += max(0, entry.rate)

            if roll <= current {
                return characterMap[entry.characterId]
            }
        }

        // Fallback (Floating point safety)
        return characterMap[entries.last!.characterId]
    }
}

// MARK: - View Model

struct CharacterRate: Identifiable {

    let id = UUID()
    let character: Character
    let rate: Double
    let isRateUp: Bool
}
