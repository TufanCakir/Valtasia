//
//  DailyRewardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct DailyRewardView: View {

    @ObservedObject var manager = DailyRewardManager.shared

    var body: some View {

        VStack {

            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

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
                colors: [Color.black, Color.blue.opacity(0.25)],
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

        let gradientColors: [Color] =
            day == 7
            ? [.yellow, .orange]
            : [.cyan, .purple]

        return ZStack {

            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.blue.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 16) {

                // Day Badge
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: gradientColors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
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

                        rewardStat(icon: "icon_coin", value: reward.coins)
                        rewardStat(icon: "icon_gem", value: reward.gems)
                        rewardStat(icon: "icon_exp", value: reward.exp)
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
                                    colors: gradientColors,
                                    startPoint: .leading,
                                    endPoint: .trailing
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
