//
//  GameContainerView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI
import SpriteKit

struct GameContainerView: View {
    
    @EnvironmentObject var appModel: AppModel
    let teamManager: TeamManager
    let levelId: String
    
    @Environment(\.dismiss) private var dismiss
    @State private var showVictory = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                SpriteView(scene: createScene(size: proxy.size))
                    .ignoresSafeArea()
                
                if showVictory {
                    VictoryView {
                        appModel.completeLevel()
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func createScene(size: CGSize) -> SKScene {

        let scene = GameScene()
        scene.size = size
        scene.scaleMode = .resizeFill

        scene.teamManager = teamManager
        scene.levelId = levelId
        scene.appModel = appModel

        // ⭐ WORLD FINDEN
        if let world = appModel.world(containing: levelId) {
            scene.world = world
        }

        scene.onVictory = {
            DispatchQueue.main.async {
                showVictory = true
            }
        }

        return scene
    }
}
