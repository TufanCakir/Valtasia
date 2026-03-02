//
//  AppModel.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import SwiftUI

final class AppModel: ObservableObject {

    let teamManager = TeamManager()
    let progress = ProgressManager()
    let coinManager = CoinManager.shared
    let crystalManager = CrystalManager.shared

    // ⭐ HIER
    private let starterKey = "valtasia_starter_given"

    @Published var worlds: [World] = []

    @Published var selectedWorld: World?
    @Published var selectedNode: WorldNode?
    @Published var selectedLevelId: String?

    init() {
        loadCharacters()
        loadWorlds()
    }

    // MARK: Start Node

    func startNode(_ node: WorldNode, in world: World) {

        selectedWorld = world
        selectedNode = node
    }

    func world(containing levelId: String) -> World? {

        worlds.first { world in

            world.worldNodes.contains { node in

                node.levels.contains {

                    $0.id == levelId
                }
            }
        }
    }

    // MARK: Start Level
    func startLevel(_ levelId: String) {

        guard teamManager.activeTeam.isEmpty == false else {

            print("⚠️ Team empty")
            return
        }

        selectedLevelId = levelId
    }

    // MARK: Victory
    func completeLevel() {

        guard let levelId = selectedLevelId else { return }

        guard let world = world(containing: levelId) else {

            print("❌ World not found for level:", levelId)
            selectedLevelId = nil
            return
        }

        // ⭐ Clear + Unlock prüfen
        progress.markLevelCleared(
            levelId,
            in: world
        )

        selectedLevelId = nil
    }

    func level(for id: String) -> Level? {

        worlds
            .flatMap { $0.worldNodes }
            .flatMap { $0.levels }
            .first { $0.id == id }
    }

    // MARK: Load
    private func loadCharacters() {

        do {

            let baseCharacters: [Character] =
                try JSONLoader.load("characters")

            let defaults = UserDefaults.standard

            let starterGiven =
                defaults.bool(forKey: starterKey)

            guard !starterGiven else { return }

            if let starter = baseCharacters.first {

                let owned =
                    OwnedCharacter(base: starter)

                teamManager.ownedCharacters.append(owned)
                teamManager.activeTeam = [owned]

                defaults.set(true, forKey: starterKey)
            }

        } catch {

            print(error)
        }
    }

    private func loadWorlds() {
        do {
            worlds =
                try JSONLoader.load("worlds")
            selectedWorld = worlds.first
        } catch {
            print(error)
        }
    }
}
