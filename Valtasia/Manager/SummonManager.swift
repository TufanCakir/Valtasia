//
//  SummonManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class SummonManager: ObservableObject {

    // MARK: - Published

    @Published private(set) var characters: [Character] = []
    @Published private(set) var banners: [SummonBanner] = []
    @Published private(set) var categories: [SummonCategory] = []

    // MARK: - Private

    private var characterMap: [String: Character] = [:]

    // MARK: - Init

    init() {
        loadAll()
    }

    // MARK: - Loading

    private func loadAll() {
        loadCharacters()
        loadSummonData()
    }

    private func loadCharacters() {
        do {
            characters = try JSONLoader.load("characters")
            characterMap = Dictionary(
                uniqueKeysWithValues:
                    characters.map { ($0.id, $0) }
            )
            print("✅ Characters loaded:", characters.count)
        } catch {
            print("❌ Character load failed:", error)
        }
    }

    private func loadSummonData() {
        do {
            let root: SummonRoot = try JSONLoader.load("summons")
            banners = root.banners
            categories = root.categories
            print("🎴 Banners loaded:", banners.count)
        } catch {
            print("❌ Summon load failed:", error)
        }
    }

    // MARK: - Category Filter

    func banners(for categoryId: String) -> [SummonBanner] {
        banners.filter { $0.category == categoryId }
    }
}

// MARK: - Pool Handling

extension SummonManager {

    private func poolEntries(
        for banner: SummonBanner,
        applyLimit: Bool
    ) -> [SummonPoolEntry] {

        guard applyLimit, banner.poolLimit > 0 else {
            return banner.pool
        }

        return Array(banner.pool.prefix(banner.poolLimit))
    }
}

// MARK: - Rates (Info Screen)

extension SummonManager {

    /// Shows FULL pool in info screen
    func rates(for bannerId: String) -> [CharacterRate] {

        guard let banner = banners.first(where: { $0.id == bannerId }) else {
            return []
        }

        return poolEntries(for: banner, applyLimit: false)
            .compactMap { entry in
                guard let character = characterMap[entry.characterId] else {
                    return nil
                }

                return CharacterRate(
                    character: character,
                    rate: entry.rate,
                    isRateUp: entry.rateUp
                )
            }
            .sorted { $0.rate > $1.rate }
    }
}

// MARK: - Summon Logic

extension SummonManager {

    /// Uses poolLimit for actual pulls
    func summon(from bannerId: String) -> Character? {

        guard let banner = banners.first(where: { $0.id == bannerId }) else {
            return nil
        }

        let entries = poolEntries(for: banner, applyLimit: true)
        guard !entries.isEmpty else { return nil }

        let totalRate = entries.reduce(0.0) { $0 + max(0, $1.rate) }
        guard totalRate > 0 else { return nil }

        let roll = Double.random(in: 0..<totalRate)

        var cumulative = 0.0

        for entry in entries {
            cumulative += max(0, entry.rate)
            if roll <= cumulative {
                return characterMap[entry.characterId]
            }
        }

        // Floating point fallback
        return characterMap[entries.last!.characterId]
    }
}

// MARK: - View Models

struct CharacterRate: Identifiable {
    let id = UUID()
    let character: Character
    let rate: Double
    let isRateUp: Bool
}
