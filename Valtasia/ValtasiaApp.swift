//
//  ValtasiaApp.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import AVFAudio
import SwiftUI

@main
struct ValtasiaApp: App {

    @StateObject private var network = NetworkMonitor.shared

    @StateObject private var appModel = AppModel()
    @StateObject private var eventManager = EventManager.shared

    @Environment(\.scenePhase)
    private var scenePhase

    init() {
        configureApp()
        MusicManager.shared.play()
    }

    var body: some Scene {

        WindowGroup {
            Group {
                if network.isConnected {

                    ZStack {

                        switch appModel.appState {
                        case .start:
                            StartView()
                        case .game:
                            RootView()
                        }

                        if appModel.isTransitionLoading {
                            TransitionLoadingView()
                                .zIndex(999)
                        }
                    }
                    .animation(
                        .easeInOut(duration: 0.5),
                        value: appModel.appState
                    )

                } else {
                    OfflineView()
                }
            }
            .environmentObject(appModel)
            .environmentObject(CoinManager.shared)
            .environmentObject(CrystalManager.shared)
            .environmentObject(PlayerProgressManager.shared)
            .environmentObject(eventManager)
            .preferredColorScheme(.dark)
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {

            case .active:
                EventManager.shared.load()
                MusicManager.shared.resume()

            case .inactive:
                MusicManager.shared.pause()

            case .background:
                saveGameState()
                MusicManager.shared.pause()

            @unknown default:
                break
            }
        }
        .onChange(of: appModel.appState) { _, state in
            switch state {
            case .game:
                MusicManager.shared.play()
            case .start:
                MusicManager.shared.stop()
            }
        }
    }
}

extension ValtasiaApp {

    fileprivate func configureApp() {
        print("Valtasia Booting...")

        // 🎵 Audio Session
        try? AVAudioSession.sharedInstance().setCategory(
            .ambient,
            mode: .default
        )
        try? AVAudioSession.sharedInstance().setActive(true)

        // 🎵 Manager initialisieren
        _ = MusicManager.shared
    }

    fileprivate func saveGameState() {

        // Optional global save trigger
        print("Saving game state...")
    }
}
