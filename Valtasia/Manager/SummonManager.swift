//
//  SummonManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation
import Combine

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

    func summon(from bannerId: String) -> Character? {

        let pool =
        characters.filter {

            $0.summon.banner == bannerId
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
