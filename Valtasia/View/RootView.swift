//
//  RootView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct RootView: View {

    enum Tab { case home, team, summon, shop, exchange }

    @EnvironmentObject var appModel: AppModel

    var body: some View {

        GameLayout {

            NavigationStack {
                currentView
            }
        }
    }
}

extension RootView {

    @ViewBuilder
    var currentView: some View {

        switch appModel.selectedTab {

        case .home:
            HomeView()

        case .team:
            TeamView(teamManager: appModel.teamManager)

        case .summon:
            SummonView(teamManager: appModel.teamManager)

        case .shop:
            ShopView()

        case .exchange:
            ExchangeView()
        }
    }
}
