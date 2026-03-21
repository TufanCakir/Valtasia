//
//  ProgressManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import Foundation

final class ProgressManager: ObservableObject {

    // MARK: - Keys

    private let clearedLevelsKey = "clearedLevels"
    private let clearedWorldsKey = "clearedWorlds"
    private let clearedCorruptedLevelsKey = "clearedCorruptedLevels"

    // MARK: - State

    @Published var clearedLevels: Set<String> = []
    @Published var clearedWorlds: Set<String> = []
    @Published var clearedCorruptedLevels: Set<String> = []

    // MARK: - Init

    init() {
        load()
    }

    // MARK: - Reset

    func reset() {
        clearedLevels = []
        clearedWorlds = []
        clearedCorruptedLevels = []
        save()
    }

    // MARK: - Save / Load

    private func save() {

        let defaults = UserDefaults.standard

        defaults.set(Array(clearedLevels), forKey: clearedLevelsKey)
        defaults.set(Array(clearedWorlds), forKey: clearedWorldsKey)
        defaults.set(
            Array(clearedCorruptedLevels),
            forKey: clearedCorruptedLevelsKey
        )
    }

    private func load() {

        let defaults = UserDefaults.standard

        if let levels = defaults.array(forKey: clearedLevelsKey) as? [String] {
            clearedLevels = Set(levels)
        }

        if let worlds = defaults.array(forKey: clearedWorldsKey) as? [String] {
            clearedWorlds = Set(worlds)
        }

        if let corrupted = defaults.array(forKey: clearedCorruptedLevelsKey)
            as? [String]
        {
            clearedCorruptedLevels = Set(corrupted)
        }
    }

    // MARK: - Normal Progress

    func markLevelCleared(_ levelId: String, in world: World) {

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

    func lastUnlockedWorld(from worlds: [World]) -> World? {
        worlds.last(where: { isWorldUnlocked($0) }) ?? worlds.first
    }

    // MARK: - Corrupted Progress

    func markCorruptedLevelCleared(_ levelId: String) {
        clearedCorruptedLevels.insert(levelId)
        save()
    }

    func clearedAllLevels(of node: CorruptedNode) -> Bool {
        node.levels.allSatisfy { clearedCorruptedLevels.contains($0.id) }
    }

    func isCorruptedWorldUnlocked(_ world: CorruptedWorld) -> Bool {

        guard let required = world.unlockAfterWorld else {
            return true
        }

        return clearedWorlds.contains(required)
    }

    // MARK: - Progress Helpers

    func progress(for node: CorruptedNode) -> Double {
        let cleared = node.levels.filter {
            clearedCorruptedLevels.contains($0.id)
        }.count

        return Double(cleared) / Double(node.levels.count)
    }
}
