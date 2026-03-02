//
//  ProgressManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class ProgressManager: ObservableObject {

    private let clearedLevelsKey = "clearedLevels"
    private let clearedWorldsKey = "clearedWorlds"

    // welche Level sind geschafft
    @Published var clearedLevels: Set<String> = []

    // welche Worlds sind komplett geschafft (optional, kann man auch berechnen)
    @Published var clearedWorlds: Set<String> = []

    init() {

        load()
    }

    private func save() {

        UserDefaults.standard.set(
            Array(clearedLevels),
            forKey: clearedLevelsKey
        )

        UserDefaults.standard.set(
            Array(clearedWorlds),
            forKey: clearedWorldsKey
        )
    }

    private func load() {

        if let levels =
            UserDefaults.standard.array(
                forKey: clearedLevelsKey
            ) as? [String]
        {

            clearedLevels =
                Set(levels)
        }

        if let worlds =
            UserDefaults.standard.array(
                forKey: clearedWorldsKey
            ) as? [String]
        {

            clearedWorlds =
                Set(worlds)
        }
    }

    func markLevelCleared(
        _ levelId: String,
        in world: World
    ) {

        clearedLevels.insert(levelId)

        updateWorldClearedIfNeeded(world)

        save()
    }

    func clearedAllLevels(of node: WorldNode) -> Bool {
        node.levels.allSatisfy { clearedLevels.contains($0.id) }
    }

    func clearedAllNodes(in world: World) -> Bool {
        world.worldNodes.allSatisfy { clearedAllLevels(of: $0) }
    }

    func updateWorldClearedIfNeeded(_ world: World) {

        if clearedAllNodes(in: world) {

            clearedWorlds.insert(world.id)

            save()
        }
    }

    func isWorldUnlocked(_ world: World) -> Bool {

        guard let required = world.unlockAfterWorld else {
            return true
        }

        return clearedWorlds.contains(required)
    }
}
