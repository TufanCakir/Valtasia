//
//  RootView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct RootView: View {

    enum Tab {
        case home, team, summon, shop, exchange
    }

    @EnvironmentObject var appModel: AppModel
    @State private var selectedTab: Tab = .home

    var body: some View {

        currentView

        CustomFooter(selectedTab: $selectedTab)
    }
}

extension RootView {

    @ViewBuilder
    var currentView: some View {

        switch selectedTab {

        case .home:

            NavigationStack {
                HomeView()
            }

        case .team:

            NavigationStack {
                TeamView(
                    teamManager: appModel.teamManager
                )
            }

        case .summon:

            NavigationStack {
                SummonView(
                    teamManager: appModel.teamManager
                )
            }

        case .shop:

            NavigationStack {
                ShopView()
            }

        case .exchange:

            NavigationStack {
                ExchangeView()
            }
        }
    }
}
