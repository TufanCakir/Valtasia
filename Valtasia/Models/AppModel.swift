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

        for world in worlds {
            for node in world.worldNodes {
                if node.levels.contains(where: { $0.id == levelId }) {
                    return world
                }
            }
        }

        return nil
    }

    func worldForLevel(_ levelId: String) -> World? {

        worlds.first { world in

            world.worldNodes.contains { node in

                node.levels.contains { level in
                    level.id == levelId
                }
            }
        }
    }

    // MARK: Start Level

    func startLevel(_ levelId: String) {

        selectedLevelId = levelId
    }

    // MARK: Victory

    func completeLevel() {

        guard let world = selectedWorld,
            let levelId = selectedLevelId
        else { return }

        progress.markLevelCleared(levelId)

        progress.updateWorldClearedIfNeeded(world)

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

            // Starter Team z.B. erster Character
            if let starter = baseCharacters.first {

                teamManager.activeTeam = [
                    OwnedCharacter(base: starter)
                ]
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
