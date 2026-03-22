//
//  EventDetailView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventDetailView: View {

    @EnvironmentObject var appModel: AppModel

    @State private var showEventWorld = false
    let event: GameEvent

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {

                VStack(spacing: 20) {

                    banner

                    descriptionSection

                    rewardSection

                    actionButton
                }
                .padding(.horizontal)
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
                .frame(height: 200)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 4) {

                Text(event.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                Text(event.type.uppercased())
                    .font(.caption.bold())
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}

extension EventDetailView {

    var descriptionSection: some View {

        VStack(alignment: .leading, spacing: 8) {

            Text("Description")
                .font(.headline)
                .foregroundStyle(.white)

            Text(event.description ?? "No description")
                .foregroundStyle(.white.opacity(0.8))
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

extension EventDetailView {

    var rewardSection: some View {

        VStack(alignment: .leading, spacing: 10) {

            Text("Rewards")
                .font(.headline)
                .foregroundStyle(.white)

            if let rewards = event.rewards {

                if let coins = rewards.coins {
                    rewardRow("Coins", "\(coins)")
                }

                if let gems = rewards.gems {
                    rewardRow("Gems", "\(gems)")
                }

                if let exp = rewards.exp {
                    rewardRow("EXP", "\(exp)")
                }

                if let token = rewards.eventToken {
                    rewardRow("Tokens", "\(token)")
                }
            }

            if let boss = event.bossEnemy {
                rewardRow("Boss", boss)
            }

            if let hero = event.hero {
                rewardRow("Rate Up", hero)
            }
        }
        .padding()
        .background(Color.black.opacity(0.25))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    func rewardRow(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.white.opacity(0.7))

            Spacer()

            Text(value)
                .font(.caption.bold())
                .foregroundStyle(.white)
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
                        colors: theme.borderGradient,
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

        switch event.type {

        case "boss":
            EventRuntime.shared.activate(event)
            showEventWorld = true

        case "summon":
            print("Open summon banner")

        default:
            break
        }
    }

    func buttonTitle() -> String {
        switch event.type {
        case "boss":
            return "Start Boss Fight"
        case "summon":
            return "Open Summon"
        default:
            return "Start"
        }
    }
}
