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

    var body: some View {

        GeometryReader { proxy in

            ZStack {

                // MARK: GAME SCENE
                SpriteView(scene: createScene(size: proxy.size))
                    .ignoresSafeArea()

                // MARK: SOFT TOP / BOTTOM GRADIENT
                LinearGradient(
                    colors: [
                        .black.opacity(0.4),
                        .clear,
                        .black.opacity(0.6),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                // MARK: EXIT BUTTON (optional but recommended)
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.headline.bold())
                                .padding(10)
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)

                    Spacer()
                }
                .allowsHitTesting(true)
                .background(Color.clear)

                // MARK: VICTORY OVERLAY

                if showVictory {

                    ZStack {

                        // Dim Layer
                        Color.black.opacity(0.75)
                            .ignoresSafeArea()
                            .transition(.opacity)

                        VictoryView {
                            appModel.completeLevel()
                            dismiss()
                        }
                        .transition(
                            .scale(scale: 0.9)
                                .combined(with: .opacity)
                        )
                    }
                    .animation(.easeInOut(duration: 0.35), value: showVictory)
                }
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.4)) {}
        }
        .navigationBarHidden(true)

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
                withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                    showVictory = true
                }
            }
        }

        return scene
    }
}
