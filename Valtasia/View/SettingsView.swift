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

                VStack(spacing: 20) {

                    accountSection
                    
                    musicSection

                    infoSection

                    dangerZone
                }
                .padding(.horizontal)
                .padding(.top, 10)
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

    var musicSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Audio")
                .font(.title2.bold())
                .foregroundStyle(.white)

            VStack(spacing: 18) {

                // MARK: MUTE TOGGLE
                HStack {

                    Image(systemName: "music.note")
                        .foregroundStyle(.cyan)
                        .frame(width: 26)

                    Text("Music")
                        .foregroundStyle(.white)

                    Spacer()

                    Toggle(
                        "",
                        isOn: Binding(
                            get: { !MusicManager.shared.isMuted },
                            set: { _ in MusicManager.shared.toggleMute() }
                        )
                    )
                    .tint(.cyan)
                }

                Divider().background(.white.opacity(0.15))

                // MARK: VOLUME SLIDER
                HStack {

                    Image(systemName: "speaker.wave.2.fill")
                        .foregroundStyle(.cyan)
                        .frame(width: 26)

                    Text("Volume")
                        .foregroundStyle(.white)

                    Slider(
                        value: Binding(
                            get: { Double(MusicManager.shared.volume) },
                            set: { MusicManager.shared.setVolume(Float($0)) }
                        ),
                        in: 0...1
                    )
                    .tint(.cyan)
                }
            }
        }
        .padding()
        .background(cardBackground)
    }
}

extension SettingsView {

    var infoSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Information")
                .font(.title2.bold())
                .foregroundStyle(.white)

            VStack(spacing: 14) {

                settingsRow(
                    icon: "iphone",
                    title: "iOS Version",
                    value: UIDevice.current.systemVersion
                )

                Divider().background(.white.opacity(0.15))

                settingsRow(
                    icon: "app.badge",
                    title: "App Version",
                    value: appVersion
                )

                Divider().background(.white.opacity(0.15))

                settingsRow(
                    icon: "hammer",
                    title: "Build",
                    value: buildNumber
                )

                Divider().background(.white.opacity(0.15))

                settingsRow(
                    icon: "circle.fill",
                    title: "Status",
                    value: "Online"
                )
            }

            Divider().background(.white.opacity(0.15))

            LinkRow(
                icon: "doc.text",
                title: "Apple Terms of Service",
                url:
                    "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
            )
        }
        .padding()
        .background(cardBackground)
    }
}

struct LinkRow: View {

    let icon: String
    let title: String
    let url: String

    var body: some View {

        if let link = URL(string: url) {

            Link(destination: link) {

                HStack {

                    Image(systemName: icon)
                        .foregroundStyle(.cyan)
                        .frame(width: 24)

                    Text(title)
                        .foregroundStyle(.white)

                    Spacer()

                    Image(systemName: "arrow.up.right.square")
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
        }
    }
}

extension SettingsView {

    var appVersion: String {

        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? "1.0"
    }

    var buildNumber: String {

        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
}

extension SettingsView {

    var accountSection: some View {

        VStack(alignment: .leading, spacing: 16) {

            Text("Account")
                .font(.title2.bold())
                .foregroundStyle(.white)

            VStack(spacing: 14) {

                settingsRowAsset(
                    icon: "icon_exp",
                    title: "Player Level",
                    value: "\(PlayerProgressManager.shared.level)"
                )

                Divider().background(.white.opacity(0.15))

                settingsRowAsset(
                    icon: "icon_crystal",
                    title: "Crystals",
                    value: "\(CrystalManager.shared.crystals)"
                )

                Divider().background(.white.opacity(0.15))

                settingsRowAsset(
                    icon: "icon_coin",
                    title: "Coins",
                    value: "\(CoinManager.shared.coins)"
                )
            }
        }
        .padding()
        .background(cardBackground)
    }
}

extension SettingsView {

    var dangerZone: some View {

        VStack(alignment: .leading, spacing: 16) {

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

                    Spacer()
                }
                .padding()
                .background(
                    LinearGradient(
                        colors: [.red, .orange],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .foregroundStyle(.white)
        }
        .padding()
        .background(cardBackground)
    }
}

func settingsRowAsset(
    icon: String,
    title: String,
    value: String
) -> some View {

    HStack(spacing: 12) {

        Image(icon)
            .resizable()
            .scaledToFit()
            .frame(width: 22, height: 22)

        Text(title)
            .foregroundStyle(.white)

        Spacer()

        Text(value)
            .foregroundStyle(.white.opacity(0.7))
    }
    .padding()
}

extension SettingsView {

    func settingsRow(
        icon: String,
        title: String,
        value: String
    ) -> some View {

        HStack(spacing: 12) {

            Image(systemName: icon)
                .foregroundStyle(.cyan)
                .frame(width: 26)

            Text(title)
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .foregroundStyle(.white.opacity(0.7))
        }
        .padding()
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
        appModel.fullReset()
    }
}
