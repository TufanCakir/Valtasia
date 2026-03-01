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

                // MARK: GAME SCENE

                if let scene {

                    SpriteView(scene: scene)
                        .ignoresSafeArea()

                }

                // MARK: TOP + BOTTOM SOFT SHADOW

                LinearGradient(
                    colors: [
                        .black.opacity(0.4),
                        .clear,
                        .black.opacity(0.65)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

         

                // MARK: VICTORY

                if showVictory {

                    ZStack {

                        Color.black.opacity(0.75)
                            .ignoresSafeArea()

                        VictoryView {

                            appModel.completeLevel()

                            dismiss()

                        }
                        .transition(
                            .scale(scale: 0.9)
                            .combined(with: .opacity)
                        )
                    }
                    .animation(
                        .easeInOut(duration: 0.35),
                        value: showVictory
                    )
                }
            }
            .onAppear {

                // ⭐ Scene nur einmal bauen
                if scene == nil {

                    scene = createScene(size: proxy.size)

                }
            }
        }

        // ⭐⭐⭐ BACK BUTTON AUS
        .navigationBarBackButtonHidden(true)

        // ⭐⭐⭐ NAV BAR KOMPLETT AUS
        .toolbar(.hidden, for: .navigationBar)

        // ⭐ Swipe Back verhindern
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

        if let world = appModel.world(containing: levelId) {

            scene.world = world

        }

        scene.onVictory = {

            DispatchQueue.main.async {

                withAnimation(
                    .spring(
                        response: 0.4,
                        dampingFraction: 0.8
                    )
                ) {

                    showVictory = true
                }
            }
        }

        return scene
    }
}
