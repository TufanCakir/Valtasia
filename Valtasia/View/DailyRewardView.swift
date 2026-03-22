//
//  DailyRewardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct DailyRewardView: View {

    @EnvironmentObject var appModel: AppModel

    @ObservedObject var manager = DailyRewardManager.shared

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        VStack {

            ScrollView {

                VStack(spacing: 16) {

                    ForEach(manager.rewards) { reward in
                        rewardCard(for: reward)
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension DailyRewardView {

    private func rewardCard(for reward: DailyReward) -> some View {

        let day = reward.day
        let isCurrent = day == manager.currentDay
        let isClaimable = isCurrent && manager.canClaimToday
        let isClaimed = isCurrent && !manager.canClaimToday

        return HStack(spacing: 14) {

            // MARK: DAY
            ZStack {
                Circle()
                    .fill(
                        isCurrent
                            ? theme.borderGradient.last ?? .white
                            : Color.black.opacity(0.25)
                    )
                    .frame(width: 44, height: 44)

                Text("\(day)")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }

            // MARK: REWARD
            VStack(alignment: .leading, spacing: 6) {

                Text("Day \(day)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)

                HStack(spacing: 10) {

                    if let coins = reward.coins, coins > 0 {
                        rewardStat(icon: "icon_coin", value: coins)
                    }

                    if let gems = reward.gems, gems > 0 {
                        rewardStat(icon: "icon_gem", value: gems)
                    }

                    if let cCoins = reward.corruptedCoins, cCoins > 0 {
                        rewardStat(icon: "c_coin", value: cCoins)
                    }

                    if let cGems = reward.corruptedGems, cGems > 0 {
                        rewardStat(icon: "c_gem", value: cGems)
                    }

                    if let exp = reward.exp, exp > 0 {
                        rewardStat(icon: "icon_exp", value: exp)
                    }
                }
            }

            Spacer()

            // MARK: ACTION
            if isClaimable {

                Button {
                    manager.claim()
                } label: {
                    Text("CLAIM")
                        .font(.caption.bold())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(
                                    LinearGradient(
                                        colors: theme.borderGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                        .foregroundStyle(.white)
                }

            } else if isClaimed {

                Text("✓")
                    .font(.headline.bold())
                    .foregroundStyle(.green)

            } else {

                Image(systemName: "lock.fill")
                    .foregroundStyle(.white.opacity(0.4))
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.25))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    isCurrent
                        ? LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [Color.white.opacity(0.1)],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                    lineWidth: isCurrent ? 2 : 1
                )
        )
        .opacity(day > manager.currentDay ? 0.5 : 1)
    }

    private func rewardStat(icon: String, value: Int) -> some View {
        HStack(spacing: 4) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 16, height: 16)

            Text("\(value)")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}
