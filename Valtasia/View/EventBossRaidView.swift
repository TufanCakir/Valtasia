//
//  EventBossRaidView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventBossRaidView: View {

    @EnvironmentObject var appModel: AppModel
    @State private var showReward = false

    var body: some View {

        ZStack {

            Color.black.ignoresSafeArea()

            if let levelId = EventRuntime.shared.activeEvent?.bossLevelId {

                GameContainerView(
                    teamManager: appModel.teamManager,
                    levelId: levelId
                )
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .eventBossCleared
            )
        ) { _ in
            showReward = true
        }
        .navigationDestination(isPresented: $showReward) {

            if let event = EventRuntime.shared.activeEvent {

                EventRewardView(event: event)

            }
        }
    }
}
