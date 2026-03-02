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

                VStack(spacing: 20) {

                    Text("🎁 Daily Login")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                        .padding(.top)

                    ForEach(0..<manager.rewards.count, id: \.self) { index in

                        rewardCard(for: index)
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

    private func rewardCard(for index: Int) -> some View {

        let reward = manager.rewards[index]
        let day = index + 1

        let isCurrent = day == manager.currentDay
        let isClaimable = isCurrent && manager.canClaimToday
        let isClaimed = isCurrent && !manager.canClaimToday

        let gradientColors: [Color] =
            day == 7
            ? [.yellow, .orange]  // ⭐ Big Reward Look
            : [.cyan, .purple]

        return ZStack {

            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.blue.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 16) {

                // MARK: Day Badge
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

                // MARK: Reward Info
                VStack(alignment: .leading, spacing: 4) {

                    Text("Day \(day)")
                        .font(.headline)
                        .foregroundStyle(.white)

                    HStack(spacing: 12) {

                        rewardStat(
                            icon: "bitcoinsign.circle.fill",
                            value: reward.coins,
                            color: .yellow
                        )

                        rewardStat(
                            icon: "diamond.fill",
                            value: reward.crystals,
                            color: .cyan
                        )

                        rewardStat(
                            icon: "sparkles",
                            value: reward.exp,
                            color: .blue
                        )
                    }
                }

                Spacer()

                // MARK: State Button
                if isClaimable {

                    Button {
                        manager.claim()
                    } label: {
                        Text("CLAIM")
                            .font(.caption.bold())
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
                            .shadow(
                                color: gradientColors.first!.opacity(0.5),
                                radius: 8
                            )
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
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    isCurrent
                        ? LinearGradient(
                            colors: gradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [
                                .white.opacity(0.1), .white.opacity(0.05),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: isCurrent ? 2 : 1
                )
        )
        .shadow(
            color: isCurrent
                ? gradientColors.first!.opacity(0.35)
                : .clear,
            radius: 14
        )
        .opacity(day > manager.currentDay ? 0.6 : 1)
    }
}

private func rewardStat(
    icon: String,
    value: Int,
    color: Color
) -> some View {

    HStack(spacing: 4) {

        Image(systemName: icon)
            .font(.caption.bold())
            .foregroundStyle(color)

        Text("\(value)")
            .font(.subheadline.bold())
            .foregroundStyle(.white.opacity(0.8))
    }
}
