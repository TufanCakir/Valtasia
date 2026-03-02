//
//  SettingsView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var appModel: AppModel

    @State private var showConfirm = false

    var body: some View {

        VStack {

            // MARK: HEADER
            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            ScrollView {

                VStack(spacing: 24) {

                    accountSection

                    dangerZone
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .background(

            LinearGradient(
                colors: [
                    Color.black,
                    Color.purple.opacity(0.25),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)

        // MARK: CONFIRM ALERT

        .alert(
            "Delete Account?",
            isPresented: $showConfirm
        ) {

            Button("Cancel", role: .cancel) {}

            Button(
                "Delete Everything",
                role: .destructive
            ) {

                resetGame()
            }

        } message: {

            Text(
                "All characters, coins and progress will be deleted permanently."
            )
        }
    }
}

extension SettingsView {

    var accountSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("Account")
                .font(.title2.bold())
                .foregroundStyle(.white)

            settingsRow(
                icon: "person.crop.circle",
                title: "Player Level",
                value: "\(PlayerProgressManager.shared.level)"
            )

            settingsRow(
                icon: "diamond.fill",
                title: "Crystals",
                value: "\(CrystalManager.shared.crystals)"
            )

            settingsRow(
                icon: "centsign.circle",
                title: "Coins",
                value: "\(CoinManager.shared.coins)"
            )
        }
        .padding()
        .background(cardBackground)
    }
}

extension SettingsView {

    var dangerZone: some View {

        VStack(alignment: .leading, spacing: 18) {

            Text("Danger Zone")
                .font(.title2.bold())
                .foregroundStyle(.red)

            Text(
                "Resetting deletes all characters, levels, rewards and purchases."
            )
            .foregroundStyle(.white.opacity(0.7))

            Button {

                showConfirm = true

            } label: {

                HStack {

                    Image(systemName: "trash.fill")

                    Text("Reset Account")
                        .bold()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(

                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .foregroundStyle(.white)
            }
        }
        .padding()
        .background(cardBackground)
    }
}

extension SettingsView {

    func settingsRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack {

            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 24)

            Text(title)
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .foregroundStyle(.white.opacity(0.7))
        }
    }
}

extension SettingsView {

    var cardBackground: some View {

        RoundedRectangle(
            cornerRadius: 24
        )
        .fill(Color.black.opacity(0.45))
        .overlay(

            RoundedRectangle(
                cornerRadius: 24
            )
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
        .shadow(
            color: .cyan.opacity(0.35),
            radius: 14
        )
    }

    private func resetGame() {

        AccountResetManager.resetAll()

        appModel.worlds = []
        appModel.selectedWorld = nil
        appModel.selectedNode = nil
        appModel.selectedLevelId = nil

        exit(0)
    }
}
