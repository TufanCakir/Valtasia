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

        guard let banner =
            banners.first(where: { $0.id == bannerId })
        else { return [] }

        let entries =
            Array(banner.pool.prefix(banner.poolLimit))

        return entries.compactMap { entry in

            guard let character =
                characters.first(where: {
                    $0.id == entry.characterId
                })
            else { return nil }

            return CharacterRate(
                character: character,
                rate: entry.rate,
                isRateUp: entry.rateUp
            )
        }
        .sorted { $0.rate > $1.rate }
    }

    func summon(from bannerId: String) -> Character? {

        guard let banner =
            banners.first(where: { $0.id == bannerId })
        else { return nil }

        let entries =
            Array(banner.pool.prefix(banner.poolLimit))

        guard !entries.isEmpty else { return nil }

        let totalRate =
            entries.reduce(0) { $0 + $1.rate }

        let roll =
            Double.random(in: 0..<totalRate)

        var current = 0.0

        for entry in entries {

            current += entry.rate

            if roll <= current {

                return characters.first {
                    $0.id == entry.characterId
                }
            }
        }

        return nil
    }
}

struct CharacterRate: Identifiable {

    let id = UUID()
    let character: Character
    let rate: Double
    let isRateUp: Bool
}
