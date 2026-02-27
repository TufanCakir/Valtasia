//
//  RootView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct RootView: View {

    @EnvironmentObject var appModel: AppModel

    var body: some View {

        TabView {
            HomeView()
                .tabItem { Label("Home", systemImage: "house") }
            

                NavigationStack {
                    SummonView(teamManager: appModel.teamManager)
                }
                .tabItem {
                    Label("Summon", systemImage: "sparkles")
                }
            
            TeamView(teamManager: appModel.teamManager)
                .tabItem { Label("Team", systemImage: "person.3") }

            ShopView()
                .tabItem { Label("Shop", systemImage: "cart") }
        }
        .environmentObject(appModel)
    }
}
