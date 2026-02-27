//
//  ValtasiaApp.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

@main
struct ValtasiaApp: App {

    @StateObject var appModel = AppModel()

    var body: some Scene {

        WindowGroup {

            RootView()
                .environmentObject(appModel)
        }
    }
}
