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

extension SummonManager {

    // MARK: - Advanced Summon (Pity + Step-Up)
    func smartSummon(from banner: SummonBanner) -> Character? {
        // ⭐ 1. PITY CHECK
        if let pity = banner.pity, pity.enabled {
            let pulls = PityManager.shared.pulls(for: banner.id)
            if pulls + 1 >= pity.requiredPulls {
                PityManager.shared.reset(for: banner.id)
                if let entry = pity.guaranteedPool.randomElement() {
                    return self.characterMap[entry.characterId]
                }
            }
        }

        // ⭐ 2. STEP-UP CHECK
        let pool: [SummonPoolEntry]
        if let stepUp = banner.stepUp, stepUp.enabled {
            let step = currentStep(for: banner.id, maxSteps: stepUp.steps.count)
            let stepData = stepUp.steps.first { $0.step == step }

            // 🎁 Guaranteed step reward
            if let guaranteed = stepData?.guaranteed {
                advanceStep(for: banner.id, maxSteps: stepUp.steps.count)
                return self.characterMap[guaranteed.characterId]
            }

            pool = stepData?.pool ?? banner.pool
            advanceStep(for: banner.id, maxSteps: stepUp.steps.count)
        } else {
            pool = banner.pool
        }

        // ⭐ 3. Normal pull
        let character = weightedSummon(from: pool)

        // ⭐ 4. Increase pity
        PityManager.shared.addPull(for: banner.id)

        return character
    }

    // MARK: - Step Info (für UI)
    func currentStepData(for banner: SummonBanner) -> StepUpStep? {
        guard let stepUp = banner.stepUp, stepUp.enabled else { return nil }

        let step = currentStep(for: banner.id, maxSteps: stepUp.steps.count)  // ✅
        return stepUp.steps.first { $0.step == step }
    }

    // MARK: - Weighted Summon
    private func weightedSummon(from entries: [SummonPoolEntry]) -> Character? {
        let total = entries.reduce(0.0) { $0 + Swift.max(0, $1.rate) }
        guard total > 0 else { return nil }

        let roll = Double.random(in: 0..<total)
        var cumulative = 0.0

        for entry in entries {
            cumulative += Swift.max(0, entry.rate)
            if roll <= cumulative {
                return self.characterMap[entry.characterId]
            }
        }

        return self.characterMap[entries.last!.characterId]
    }

    // MARK: - Step Progress
    private func currentStep(for bannerId: String, maxSteps: Int) -> Int {
        let step = UserDefaults.standard.integer(forKey: "step_\(bannerId)")
        let normalized = (step == 0) ? 1 : step
        return Swift.min(maxSteps, Swift.max(1, normalized))
    }

    private func advanceStep(for bannerId: String, maxSteps: Int) {
        let key = "step_\(bannerId)"
        let current = UserDefaults.standard.integer(forKey: key)
        let next = current + 1
        if next > maxSteps {
            UserDefaults.standard.set(1, forKey: key)  // 🔁 Reset to Step 1
        } else {
            UserDefaults.standard.set(next, forKey: key)
        }
    }
}

// MARK: - View Models

struct CharacterRate: Identifiable {
    let id = UUID()
    let character: Character
    let rate: Double
    let isRateUp: Bool
}
