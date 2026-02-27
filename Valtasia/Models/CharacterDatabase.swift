//
//  CharacterDatabase.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

final class CharacterDatabase {

    static let shared = CharacterDatabase()

    private(set) var characters: [Character] = []

    private init() {
        load()
    }

    private func load() {
        do {
            characters = try JSONLoader.load("characters")
            print("Loaded Characters:", characters.count)
        } catch {
            print("Character load error:", error)
        }
    }

    func characters(for banner: String) -> [Character] {
        characters.filter { $0.summon.banner == banner }
    }
}
