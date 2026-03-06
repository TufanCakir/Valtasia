//
//  AppModel.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import SwiftUI

final class AppModel: ObservableObject {

    // MARK: - Managers

    let teamManager = TeamManager()
    let progress = ProgressManager()
    let coinManager = CoinManager.shared
    let crystalManager = CrystalManager.shared

    // MARK: - Persistent Keys

    private let starterKey = "valtasia_starter_given"

    // MARK: - Published State

    @Published var appState: AppState = .start

    @Published var worlds: [World] = []
    @Published var selectedWorld: World?
    @Published var selectedNode: WorldNode?
    @Published var selectedLevelId: String?

    enum AppState {
        case start
        case game
    }

    // MARK: - Init

    init() {
        initializeGameIfNeeded()
    }

    // MARK: - Game Boot

    /// Called on first app launch or after full reset
    func initializeGameIfNeeded() {
        loadWorlds()
        loadStarterCharacterIfNeeded()
        ensureValidSelections()
    }

    /// Called when player presses "Start"
    func startGame() {
        ensureValidSelections()
        appState = .game
    }

    // MARK: - Reset

    func fullReset() {
        AccountResetManager.resetAll()

        worlds.removeAll()
        selectedWorld = nil
        selectedNode = nil
        selectedLevelId = nil

        initializeGameIfNeeded()
        appState = .start
    }

    // MARK: - World / Level Flow

    func startNode(_ node: WorldNode, in world: World) {
        selectedWorld = world
        selectedNode = node
    }

    func startLevel(_ levelId: String) {
        guard !teamManager.activeTeam.isEmpty else {
            print("⚠️ Team empty")
            return
        }
        selectedLevelId = levelId
    }

    func completeLevel() {
        guard let levelId = selectedLevelId else { return }
        guard let world = world(containing: levelId) else {
            print("❌ World not found for level:", levelId)
            selectedLevelId = nil
            return
        }

        progress.markLevelCleared(levelId, in: world)
        selectedLevelId = nil
    }

    // MARK: - Lookup

    func world(containing levelId: String) -> World? {
        worlds.first { world in
            world.worldNodes.contains { node in
                node.levels.contains { $0.id == levelId }
            }
        }
    }

    func level(for id: String) -> Level? {
        worlds
            .flatMap { $0.worldNodes }
            .flatMap { $0.levels }
            .first { $0.id == id }
    }

    // MARK: - Private Loaders

    private func loadWorlds() {
        do {
            worlds = try JSONLoader.load("worlds")
        } catch {
            print("❌ Worlds load failed:", error)
        }
    }

    private func loadStarterCharacterIfNeeded() {
        do {
            let baseCharacters: [Character] = try JSONLoader.load("characters")
            let defaults = UserDefaults.standard

            guard !defaults.bool(forKey: starterKey) else { return }

            if let starter = baseCharacters.first {
                let owned = OwnedCharacter(base: starter)
                teamManager.ownedCharacters.append(owned)
                teamManager.activeTeam = [owned]
                defaults.set(true, forKey: starterKey)
            }

        } catch {
            print("❌ Characters load failed:", error)
        }
    }

    private func ensureValidSelections() {
        if selectedWorld == nil {
            selectedWorld = worlds.first
        }
    }
}
