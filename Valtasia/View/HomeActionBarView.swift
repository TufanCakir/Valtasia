//
//  HomeActionBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.04.26.
//

import SwiftUI

struct HomeActionBarView: View {
    @EnvironmentObject var appModel: AppModel

    let theme: UITheme

    var body: some View {
        HStack(spacing: 16) {
            Button {
                appModel.appState = .story
            } label: {
                iconCapsule(icon: "book")
            }

            NavigationLink {
                GiftView()
            } label: {
                iconCapsule(icon: "gift.fill")
            }

            NavigationLink {
                EventView()
            } label: {
                iconCapsule(icon: "gamecontroller.fill")
            }

            NavigationLink {
                DailyRewardView()
            } label: {
                iconCapsule(icon: "calendar")
            }

            NavigationLink {
                SettingsView()
            } label: {
                iconCapsule(icon: "gearshape.fill")
            }
        }
        .padding()
    }
}

extension HomeActionBarView {

    fileprivate func iconCapsule(icon: String) -> some View {
        ZStack {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
        }
        .frame(width: 50, height: 50)
    }
}
