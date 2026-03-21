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
            
            GameHeaderView()

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

        return ZStack {

            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 16) {

                // Day Badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: theme.headerGradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 50, height: 50)

                    Text("\(day)")
                        .font(.title3.bold())
                        .foregroundStyle(.white)
                }

                // Reward Info
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text("Day \(day)")
                        .font(.headline)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 12) {
                        
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

                // State Button
                if isClaimable {

                    Button {
                        manager.claim()
                    } label: {
                        Text("CLAIM")
                            .font(.caption.bold())
                            .foregroundStyle(.white)
                            .padding(.horizontal, 18)
                            .padding(.vertical, 10)
                            .background(
                                    LinearGradient(
                                        colors: theme.headerGradient,
                                        startPoint: .top,
                                        endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                    }

                } else if isClaimed {

                    Text("CLAIMED")
                        .font(.caption.bold())
                        .foregroundStyle(.green)

                } else {

                    Text("LOCKED")
                        .font(.caption.bold())
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .opacity(day > manager.currentDay ? 0.6 : 1)
    }

    private func rewardStat(icon: String, value: Int) -> some View {
        HStack(spacing: 6) {
            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)

            Text("\(value)")
                .font(.subheadline.bold())
                .foregroundStyle(.white.opacity(0.85))
        }
    }
}
