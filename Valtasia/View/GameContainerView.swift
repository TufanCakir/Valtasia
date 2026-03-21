//
//  GameContainerView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit
import SwiftUI

struct GameContainerView: View {
    
    @EnvironmentObject var appModel: AppModel
    let teamManager: TeamManager
    let levelId: String
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var showVictory = false
    
    // ⭐ Scene nur EINMAL erstellen (EXTREM wichtig)
    @State private var scene: GameScene?
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                
                // ⭐ IMMER Scene anzeigen (auch Tutorial)
                if let scene {
                    SpriteView(scene: scene)
                        .ignoresSafeArea()
                }
                
                // ⭐ Tutorial Overlay
                if levelId == "tutorial_level" {
                    TutorialBattleView(
                        teamManager: teamManager
                    ) {
                        appModel.completeLevel()
                        dismiss()
                    }
                }
                
                // ⭐ Normal Victory Overlay
                if showVictory && levelId != "tutorial_level" {
                    ZStack {
                        Color.black.opacity(0.75).ignoresSafeArea()
                        
                        VictoryView {
                            appModel.completeLevel()
                            dismiss()
                        }
                    }
                }
            }
            .onAppear {
                if scene == nil {
                    scene = createScene(size: proxy.size)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .interactiveDismissDisabled(true)
    }
    
    // MARK: Scene Builder
    private func createScene(size: CGSize) -> GameScene {
        
        let scene = GameScene()
        
        scene.size = size
        scene.scaleMode = .resizeFill
        
        scene.teamManager = teamManager
        scene.levelId = levelId
        scene.appModel = appModel
        
        // ⭐ TUTORIAL
        scene.isTutorialMode = (levelId == "tutorial_level")
        
        // CORRUPTED FIRST (höhere Priorität)
        if let corruptedLevel = appModel.corruptedLevel(for: levelId) {
            scene.currentLevel = corruptedLevel
            scene.gameMode = .corrupted
        } else if let world = appModel.world(containing: levelId) {
            scene.world = world
            scene.gameMode = .normal
        }
        
        scene.onVictory = {
            DispatchQueue.main.async {
                showVictory = true
            }
        }
        
        return scene
    }
}
