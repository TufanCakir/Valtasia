//
//  TeamView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct TeamView: View {

    @ObservedObject var teamManager: TeamManager

    private let columns = [
        GridItem(.adaptive(minimum: 90))
    ]

    var body: some View {

        VStack(spacing: 20) {

            Text("Characters")
                .font(.title)

            ScrollView {

                LazyVGrid(columns: columns, spacing: 16) {

                    ForEach(teamManager.ownedCharacters) { owned in

                        let character = owned.base
                        let inTeam =
                            teamManager.isInTeam(owned)

                        VStack {

                            Image(character.sprite)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 70)

                            Text(character.name)
                                .font(.caption)

                            Button(

                                inTeam
                                    ? "Remove"
                                    : "Add"

                            ) {

                                if inTeam {

                                    teamManager.removeFromTeam(owned)

                                } else {

                                    teamManager.addToTeam(owned)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
            }

            Divider()

            Text("Team")

            HStack(spacing: 20) {

                ForEach(
                    0..<teamManager.maxTeamSize,
                    id: \.self
                ) { index in

                    ZStack {

                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.white.opacity(0.3), lineWidth: 2)
                            .frame(width: 80, height: 80)

                        if teamManager.activeTeam.indices.contains(index) {

                            let owned =
                                teamManager.activeTeam[index]

                            VStack {

                                Image(owned.base.sprite)
                                    .resizable()
                                    .scaledToFit()

                                Button {

                                    teamManager
                                        .removeFromTeam(owned)

                                } label: {

                                    Image(systemName: "xmark.circle.fill")
                                }
                            }
                            .padding(6)
                        } else {

                            Image(systemName: "plus")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding()
    }
}
