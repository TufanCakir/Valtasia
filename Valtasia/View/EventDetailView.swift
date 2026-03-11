//
//  EventDetailView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventDetailView: View {

    @State private var showEventWorld = false
    let event: GameEvent

    var body: some View {

        ZStack {

            // MARK: Background

            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 24) {

                    banner

                    descriptionSection

                    rewardSection

                    actionButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)

        .navigationDestination(isPresented: $showEventWorld) {

            EventBossRaidView()
        }
    }
}

extension EventDetailView {

    var banner: some View {

        ZStack(alignment: .bottomLeading) {

            Image(event.icon ?? "water_bg")
                .resizable()
                .scaledToFill()
                .frame(height: 220)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.95)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 6) {

                Text(event.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text(event.type.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.cyan)

            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(

            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.7), .purple.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(color: .cyan.opacity(0.35), radius: 14)
    }
}

extension EventDetailView {

    var descriptionSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Description")
                .font(.headline)
                .foregroundStyle(.white)

            Text(event.description ?? "No description")
                .foregroundStyle(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(

            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.5), .purple.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

extension EventDetailView {

    var rewardSection: some View {

        VStack(alignment: .leading, spacing: 12) {

            Text("Rewards")
                .font(.headline)
                .foregroundStyle(.white)

            if let rewards = event.rewards {

                if let coins = rewards.coins {
                    rewardInfoRow("Coins", "+ \(coins)")
                }

                if let gems = rewards.gems {
                    rewardInfoRow("Gems", "+\(gems)")
                }

                if let exp = rewards.exp {
                    rewardInfoRow("EXP", "+\(exp)")
                }

                if let token = rewards.eventToken {
                    rewardInfoRow("Event Tokens", "+\(token)")
                }
            }

            if let boss = event.bossEnemy {
                rewardInfoRow("Boss", boss)
            }

            if let hero = event.hero {
                rewardInfoRow("Rate Up", hero)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(

            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: [.cyan.opacity(0.5), .purple.opacity(0.5)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

func rewardInfoRow(_ title: String, _ value: String) -> some View {

    HStack {

        Text(title)
            .foregroundStyle(.white.opacity(0.7))

        Spacer()

        Text(value)
            .font(.caption.bold())
            .foregroundStyle(.cyan)
    }
}

extension EventDetailView {

    var actionButton: some View {

        Button {

            startEvent()

        } label: {

            Text(buttonTitle())
                .font(.headline.bold())
                .frame(maxWidth: .infinity)
                .padding()

                .background(

                    LinearGradient(
                        colors: [.cyan, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }
}

extension EventDetailView {

    func startEvent() {

        print("Start Event:", event.id)

        switch event.type {

        case "boss":

            EventRuntime.shared.activate(event)

            showEventWorld = true

        case "crack_boost":

            activateBoost()

        default:

            break

        }
    }
}

func activateBoost() {

    print("Boost Active")

}

extension EventDetailView {

    func iconForEvent() -> String {

        switch event.type {

        case "boss":

            return "flame.fill"

        case "summon":

            return "sparkles"

        case "crack_boost":

            return "bolt.fill"

        default:

            return "star"
        }
    }
}
extension EventDetailView {

    func buttonTitle() -> String {
        switch event.type {
        case "boss":
            return "Start Boss Fight"
        case "summon":
            return "Open Summon"
        case "crack_boost":
            return "Activate Boost"
        default:
            return "Start"
        }
    }
}
