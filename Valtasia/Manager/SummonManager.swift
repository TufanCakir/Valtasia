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

    init() {

        loadCharacters()
        loadBanners()
    }

    private func loadCharacters() {

        do {
            characters = try JSONLoader.load("characters")
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

    func rates(for bannerId: String) -> [CharacterRate] {

        guard
            let banner =
                banners.first(where: { $0.id == bannerId })
        else { return [] }

        let poolIDs =
            Array(banner.pool.prefix(banner.poolLimit))

        let pool =
            characters.filter { poolIDs.contains($0.id) }

        return
            pool
            .map {
                CharacterRate(
                    character: $0,
                    rate: $0.summon.rate,
                    isRateUp: $0.summon.rateUp
                )
            }
            .sorted { $0.rate > $1.rate }
    }

    func summon(from bannerId: String) -> Character? {

        guard
            let banner =
                banners.first(where: { $0.id == bannerId })
        else { return nil }

        // ⭐ Pool IDs aus JSON
        let poolIDs =
            Array(banner.pool.prefix(banner.poolLimit))

        let pool =
            characters.filter { char in
                poolIDs.contains(char.id)
            }

        guard !pool.isEmpty else { return nil }

        let totalRate =
            pool.reduce(0) { $0 + $1.summon.rate }

        let roll =
            Double.random(in: 0...totalRate)

        var current = 0.0

        for character in pool {

            current += character.summon.rate

            if roll <= current {
                return character
            }
        }

        return pool.randomElement()
    }
}

struct CharacterRate: Identifiable {

    let id = UUID()
    let character: Character
    let rate: Double
    let isRateUp: Bool
}
