//
//  AppModel.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import SwiftUI

final class AppModel: ObservableObject {

    // MARK: - Persistent Keys
    private let tutorialFightKey = "tutorial_fight_done"
    private let tutorialSummonKey = "tutorial_summon_done"
    let tutorialLevelId = "tutorial_level"

    @Published var tutorialState: TutorialState = .none

    enum TutorialState {
        case none
        case fight
        case summon
        case done
    }

    // MARK: - Managers

    let teamManager = TeamManager()
    let progress = ProgressManager()
    let coinManager = CoinManager.shared
    let crystalManager = GemManager.shared

    // MARK: - Persistent Keys

    private let starterKey = "valtasia_starter_given"

    // MARK: - Published State

    @Published var appState: AppState = .start

    @Published var worlds: [World] = []
    @Published var selectedWorld: World?
    @Published var selectedNode: WorldNode?
    @Published var selectedLevelId: String?
    // MARK: - Loading Overlay
    @Published var isTransitionLoading: Bool = false
    @Published var currentLoadingImage: String = "loading1"

    func pickLoadingImage() {
        currentLoadingImage = loadingImages.randomElement() ?? "epic_bg"
    }

    /// Zufälliges Loading Bild
    let loadingImages = [
        "water_bg",
        "epic_bg",
        "sky_bg",
        "lava_bg",
        "nature_bg",
        "earth_bg",
        "space_bg",
        "void_bg",
        "bg_emo",
        "bg_cemetery",
        "bg_candy",
        "bg_desert",
        "bg_crazy",
        "bg_disco",
        "bg_shop",
        "bg_ship",
        "bg_dark",
        "bg_rainbow",
        "bg_exp",
        "bg_coin",
        "bg_tutorial",
    ]

    var randomLoadingImage: String {
        loadingImages.randomElement() ?? "loading1"
    }

    enum AppState {
        case start
        case game
    }

    // MARK: - Init
    init() {
        initializeGameIfNeeded()
        determineTutorialState()
    }

    private func determineTutorialState() {
        let d = UserDefaults.standard

        let fightDone = d.bool(forKey: tutorialFightKey)
        let summonDone = d.bool(forKey: tutorialSummonKey)

        if !fightDone {
            tutorialState = .fight
        } else if !summonDone {
            tutorialState = .summon
        } else {
            tutorialState = .done
        }
    }

    // MARK: - Game Boot

    /// Called on first app launch or after full reset
    func initializeGameIfNeeded() {
        loadWorlds()
        loadStarterCharacterIfNeeded()
        determineInitialWorld()
    }

    // MARK: - Navigation mit Loading

    func switchToGame() {
        pickLoadingImage()
        isTransitionLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.appState = .game

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isTransitionLoading = false
            }
        }
    }

    func navigateWithLoading(_ action: @escaping () -> Void) {
        pickLoadingImage()
        isTransitionLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            action()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.isTransitionLoading = false
            }
        }
    }

    /// Called when player presses "Start"
    func startGame() {
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

        // ⭐ Tutorial abgeschlossen
        if levelId == tutorialLevelId {
            UserDefaults.standard.set(true, forKey: tutorialFightKey)
            tutorialState = .summon

            // ⭐➡️ AUF WORLD 1 WECHSELN
            selectedWorld = worlds.first(where: { $0.id == "world_1" })

            selectedLevelId = nil
            return
        }

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
            let loaded: [World] = try JSONLoader.load("worlds")
            worlds = loaded
            print("🌍 Worlds loaded:", worlds.count)
        } catch {
            print("❌ Worlds load failed:", error)
        }
    }

    private func determineInitialWorld() {
        guard !worlds.isEmpty else { return }

        switch tutorialState {

        case .fight:
            selectedWorld = worlds.first(where: { $0.id == "world_tutorial" })

        case .summon, .done:
            selectedWorld = worlds.first(where: { $0.id == "world_1" })

        case .none:
            selectedWorld = progress.lastUnlockedWorld(from: worlds)
        }

        // Fallback
        if selectedWorld == nil {
            selectedWorld = worlds.first
        }

        print("🌍 Selected world:", selectedWorld?.id ?? "none")
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
}
