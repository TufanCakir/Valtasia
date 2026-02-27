//
//  RootView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct RootView: View {

    private enum Tab {
        case home
        case team
        case summon
        case shop
    }

    @EnvironmentObject var appModel: AppModel
    @State private var selectedTab: Tab = .home

    var body: some View {

        TabView(selection: $selectedTab) {

            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(Tab.home)

            NavigationStack {
                TeamView(teamManager: appModel.teamManager)
            }
            .tabItem {
                Label("Team", systemImage: "person.3")
            }
            .tag(Tab.team)

            NavigationStack {
                SummonView(teamManager: appModel.teamManager)
            }
            .tabItem {
                Label("Summon", systemImage: "sparkles")
            }
            .tag(Tab.summon)

            NavigationStack {
                ShopView()
            }
            .tabItem {
                Label("Shop", systemImage: "cart")
            }
            .tag(Tab.shop)
        }
    }
}
