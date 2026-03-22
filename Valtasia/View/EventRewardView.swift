//
//  EventRewardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventRewardView: View {

    @EnvironmentObject var appModel: AppModel

    @Environment(\.dismiss) private var dismiss
    var event: GameEvent

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            // MARK: Background

            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                header

                rewardCard

                claimButton
            }
            .padding(.horizontal, 28)
        }
    }
}

extension EventRewardView {

    var header: some View {

        VStack(spacing: 12) {

            Image(systemName: "crown.fill")
                .font(.system(size: 60))
                .foregroundStyle(.yellow)

            Text("CLEARED")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)

            Text(event.title)
                .font(.headline)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

extension EventRewardView {

    var rewardCard: some View {

        VStack(spacing: 18) {

            Text("Rewards")
                .font(.headline)
                .foregroundStyle(.white)

            rewardList
        }
        .padding(24)
        .frame(maxWidth: .infinity)

        .background(.ultraThinMaterial)

        .clipShape(RoundedRectangle(cornerRadius: 24))

        .overlay(

            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

extension EventRewardView {

    private var rewardList: some View {

        VStack(spacing: 12) {

            if let coins = event.rewards?.coins {
                rewardIconRow("icon_coin", "+\(coins)")
            }

            if let gems = event.rewards?.gems {
                rewardIconRow("icon_gem", "+\(gems)")
            }

            if let exp = event.rewards?.exp {
                rewardIconRow("icon_exp", "+\(exp)")
            }

            if let token = event.rewards?.eventToken {
                rewardIconRow("icon_token", "+\(token)")
            }
        }
    }
}

func rewardIconRow(_ icon: String, _ value: String) -> some View {

    HStack(spacing: 14) {

        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 22, height: 22)

        Text(value)
            .font(.headline)
            .foregroundStyle(.white)

        Spacer()
    }
}

extension EventRewardView {

    var claimButton: some View {

        Button {

            claimReward()

        } label: {

            Text("Claim Reward")
                .font(.headline.bold())
                .frame(maxWidth: .infinity)
                .padding()

                .background(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }
}

extension EventRewardView {

    private func claimReward() {
        guard let reward = event.rewards else {
            dismiss()
            return
        }

        if let coins = reward.coins {
            CoinManager.shared.add(coins)
        }

        if let gems = reward.gems {
            GemManager.shared.add(gems)
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
