//
//  EventRewardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventRewardView: View {

    @Environment(\.dismiss) private var dismiss

    var event: GameEvent

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.black, .purple.opacity(0.5)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                Text("RAID CLEARED")
                    .font(.largeTitle.bold())

                rewardList

                Button {
                    claimReward()
                } label: {
                    Text("Claim Reward")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.cyan)
                        .clipShape(Capsule())
                }
            }
            .padding()
        }
    }

    private var rewardList: some View {
        VStack(spacing: 8) {
            if let coins = event.rewards?.coins {
                Text("+\(coins) Coins")
            }

            if let crystals = event.rewards?.crystals {
                Text("+\(crystals) Crystals")
            }

            if let exp = event.rewards?.exp {
                Text("+\(exp) EXP")
            }

            if let token = event.rewards?.eventToken {
                Text("+\(token) Event Tokens")
            }
        }
    }

    private func claimReward() {
        guard let reward = event.rewards else {
            dismiss()
            return
        }

        if let coins = reward.coins {
            CoinManager.shared.add(coins)
        }

        if let crystals = reward.crystals {
            CrystalManager.shared.add(crystals)
        }

        if let exp = reward.exp {
            PlayerProgressManager.shared.addEXP(exp)
        }

        if let token = reward.eventToken {
            EventInventory.shared.addTokens(token)
        }

        EventRuntime.shared.clear()
        dismiss()
    }
}

