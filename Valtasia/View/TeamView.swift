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
        GridItem(.adaptive(minimum: 120))
    ]

    var body: some View {

        VStack(spacing: 0) {

            // MARK: TOP AREA
            VStack(spacing: 28) {

                header

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
            }
            .padding(.horizontal,16)
            .padding(.top,18)
            .padding(.bottom,10)

            // MARK: SCROLL AREA

            ScrollView {

                charactersSection
                    .padding(.horizontal,16)
                    .padding(.top,20)
                    .padding(.bottom,120) // Platz für Footer
            }
            .scrollIndicators(.hidden)
        }

        .background(
            LinearGradient(
                colors:[
                    .black,
                    .blue.opacity(0.25)
                ],
                startPoint:.top,
                endPoint:.bottom
            )
            .ignoresSafeArea()
        )

        .sheet(item:$selectedCharacter){

            CharacterDetailView(owned:$0)
        }

        .alert(
            "Team benötigt mindestens 1 Character",
            isPresented:$showTeamWarning
        ){

            Button("OK",role:.cancel){}

        } message:{

            Text(
                "Du musst mindestens einen Character im Team behalten, um spielen zu können."
            )
        }
    }

    var header: some View {

        HStack {

            VStack(alignment: .leading) {

                Text("Team Setup")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                    .padding(.bottom,6)

                Text("Wähle deine Kämpfer")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.bottom,6)
            }

            Spacer()

            VStack(alignment: .trailing) {

                Label(
                    "\(CoinManager.shared.coins)",
                    systemImage: "circle.fill"
                )

                Label(
                    "\(CrystalManager.shared.crystals)",
                    systemImage: "diamond.fill"
                )
                .foregroundStyle(.cyan)
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(
                RoundedRectangle(cornerRadius: 14)
            )
        }
    }

    var charactersSection: some View {

        VStack(alignment:.leading,spacing:18){

            Text("Characters")
                .font(.title.bold())
                .foregroundStyle(.white)

            LazyVGrid(columns:columns,spacing:20){

                ForEach(teamManager.ownedCharacters){

                    characterCard($0)
                }
            }

        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(
            RoundedRectangle(cornerRadius:22)
        )
        .overlay(
            RoundedRectangle(cornerRadius:22)
                .stroke(.white.opacity(0.12))
        )
    }

    var teamSection: some View {

        VStack(alignment: .leading, spacing: 14) {

            Text("Active Team")
                .font(.title2.bold())
                .foregroundStyle(.white)

            teamSlots
        }
    }

    func characterCard(_ owned: OwnedCharacter) -> some View {

        let character = owned.base
        let inTeam = teamManager.isInTeam(owned)

        return VStack(spacing: 10) {

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
                    .padding(10)
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
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
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

        HStack(spacing: 14) {

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
                            .padding(12)

                        VStack {

                            HStack {

                                Spacer()

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

                            Spacer()
                        }
                        .padding(6)

                    } else {

                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundStyle(.gray.opacity(0.7))
                    }
                }
                .frame(width: 95, height: 95)
                .shadow(
                    color: .cyan.opacity(0.25),
                    radius: 8
                )
            }
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    TeamView(teamManager: TeamManager())
}
