//
//  TeamView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct TeamView: View {

    @ObservedObject var teamManager: TeamManager

    @State private var selectedCharacter: OwnedCharacter?
    @State private var showTeamWarning = false

    private let columns = [
        GridItem(.adaptive(minimum: 130))
    ]

    var body: some View {
        VStack {

            teamSection
                .padding()
                .background(.ultraThinMaterial)
                .clipShape(
                    RoundedRectangle(cornerRadius: 22)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.white.opacity(0.15))
                )

            // MARK: SCROLL AREA

            ScrollView {

                charactersSection

            }
            .padding()
            .scrollIndicators(.hidden)
        }

        .background(
            LinearGradient(
                colors: [
                    .black,
                    .blue.opacity(0.25),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )

        .sheet(item: $selectedCharacter) {

            CharacterDetailView(owned: $0)
        }

        .alert(
            "Team benötigt mindestens 1 Character",
            isPresented: $showTeamWarning
        ) {

            Button("OK", role: .cancel) {}

        } message: {

            Text(
                "Du musst mindestens einen Character im Team behalten, um spielen zu können."
            )
        }
    }

    var charactersSection: some View {

        VStack {

            LazyVGrid(columns: columns, spacing: 30) {

                ForEach(teamManager.ownedCharacters) {

                    characterCard($0)
                }
            }

        }
        .clipShape(
            RoundedRectangle(cornerRadius: 22)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(.white.opacity(0.12))
        )
    }

    var teamSection: some View {

        VStack(alignment: .leading, spacing: 0) {

            teamSlots
        }
    }

    func characterCard(_ owned: OwnedCharacter) -> some View {

        let character = owned.base
        let inTeam = teamManager.isInTeam(owned)

        return VStack {

            ZStack {

                RoundedRectangle(cornerRadius: 16)
                    .fill(.black.opacity(0.35))

                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                character.rarity.color,
                                .purple,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )

                Image(character.sprite)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .frame(height: 100)

            Text(character.name)
                .font(.caption.bold())
                .foregroundStyle(.white)

            Text("Lv \(owned.level)")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))

            ProgressView(
                value: Double(owned.exp),
                total: Double(owned.requiredEXP)
            )
            .tint(character.rarity.color)

            Button(inTeam ? "Remove" : "Add") {

                if inTeam {

                    teamManager.removeFromTeam(owned)

                } else {

                    teamManager.addToTeam(owned)
                }
            }
            .font(.caption.bold())
            .padding()
            .background(

                LinearGradient(
                    colors: [
                        .purple,
                        .blue,
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .foregroundStyle(.white)

        }
        .padding()
        .background(

            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .overlay(

                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.15))
                )
        )
        .shadow(
            color: character.rarity.color.opacity(0.35),
            radius: 10
        )
        .onLongPressGesture {

            selectedCharacter = owned
        }
    }

    var teamSlots: some View {

        HStack {

            ForEach(0..<teamManager.maxTeamSize, id: \.self) { index in

                ZStack {

                    RoundedRectangle(cornerRadius: 18)

                        .fill(.black.opacity(0.35))

                    RoundedRectangle(cornerRadius: 18)
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

                    if teamManager.activeTeam.indices.contains(index) {

                        let owned =
                            teamManager.activeTeam[index]

                        Image(owned.base.sprite)
                            .resizable()
                            .scaledToFit()
                            .padding()

                        VStack {

                            HStack {

                                Button {

                                    if teamManager.activeTeam.count <= 1 {

                                        showTeamWarning = true

                                    } else {

                                        teamManager.removeFromTeam(owned)
                                    }

                                } label: {

                                    Image(systemName: "xmark.circle.fill")
                                        .font(.title3)
                                        .foregroundStyle(.red)
                                        .shadow(radius: 4)
                                }
                            }
                        }

                    } else {

                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                .frame(width: 80, height: 80)
                .shadow(
                    color: .cyan.opacity(0.25),
                    radius: 8
                )
            }
        }
    }
}

#Preview {
    TeamView(teamManager: TeamManager())
}
