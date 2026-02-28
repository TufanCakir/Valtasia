//
//  ValtasiaApp.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

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
    }

    var body: some Scene {

        WindowGroup {

            Group {

                if network.isConnected {

                    RootView()

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

            case .inactive:
                print("App inactive")

            case .background:
                saveGameState()

            @unknown default:
                break
            }
        }
    }
}

extension ValtasiaApp {

    fileprivate func configureApp() {

        // Future:
        // - Analytics setup
        // - StoreKit listener
        // - Audio engine boot
        // - Remote config

        print("Valtasia Booting...")
    }

    fileprivate func saveGameState() {

        // Optional global save trigger
        print("Saving game state...")
    }
}
