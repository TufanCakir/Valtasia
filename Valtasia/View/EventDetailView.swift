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

            LinearGradient(
                colors: [
                    .black.opacity(0.9),
                    .purple.opacity(0.45),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 28) {

                    header

                    descriptionSection

                    rewardSection

                    actionButton

                }
                .padding(32)
                .background(

                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)
                        .overlay(

                            RoundedRectangle(cornerRadius: 24)
                                .stroke(

                                    LinearGradient(
                                        colors: [
                                            .cyan.opacity(0.7),
                                            .purple.opacity(0.6),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                )
                .shadow(color: .cyan.opacity(0.35), radius: 20)
                .padding(.horizontal, 32)

            }
        }
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)

        .navigationDestination(isPresented: $showEventWorld) {

            EventBossRaidView()

        }
    }
}

extension EventDetailView {

    var header: some View {

        VStack(spacing: 12) {

            Image(systemName: iconForEvent())
                .font(.system(size: 60))
                .foregroundStyle(.cyan)

            Text(event.title)
                .font(.title.bold())
                .foregroundStyle(.white)

            Text(event.type.uppercased())
                .font(.caption.bold())
                .foregroundStyle(.purple)

        }
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
        .background(.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 16))

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

                    rewardRow("Coins", "+\(coins)")
                }

                if let crystals = rewards.crystals {

                    rewardRow("Crystals", "+\(crystals)")
                }

                if let exp = rewards.exp {

                    rewardRow("EXP", "+\(exp)")
                }

                if let token = rewards.eventToken {

                    rewardRow("Event Tokens", "+\(token)")
                }

            }

            if let boss = event.bossEnemy {

                rewardRow("Boss", boss)

            }

            if let hero = event.hero {

                rewardRow("Rate Up", hero)

            }

            if let mod = event.modifiers {

                if let color = mod.crackColor {

                    rewardRow("Crack Boost", color)

                }

                if let multi = mod.spawnMultiplier {

                    rewardRow("Spawn", "x\(multi)")
                }
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 16))

    }
}

extension EventDetailView {

    func rewardRow(
        _ title: String,
        _ value: String
    ) -> some View {

        HStack {

            Text(title)
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            Text(value)
                .font(.caption.bold())
                .foregroundStyle(.cyan)

        }
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
