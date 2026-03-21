//
//  TeamView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct TeamView: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @ObservedObject var teamManager: TeamManager
    
    @State private var selectedCharacter: OwnedCharacter?
    @State private var showTeamWarning = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 130))
    ]
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }
    
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
                colors: theme.headerGradient,
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
                "Du musst mindestens einen Character besitzen und mindestens einen im Team behalten."
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
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
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
                    .fill(
                        LinearGradient(
                            colors: theme.headerGradient,
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )

                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        character.rarity.color,
                        lineWidth: owned.isCorrupted ? 3 : 2
                    )

                Image(character.sprite)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            .frame(height: 100)
            .shadow(
                color: owned.isCorrupted
                    ? .red.opacity(0.7)
                    : character.rarity.color.opacity(0.35),
                radius: owned.isCorrupted ? 20 : 10
            )

            Text(character.name)
                .font(.caption.bold())
                .foregroundStyle(.white)

            Text("Lv \(owned.level)")
                .font(.caption2)
                .foregroundStyle(.white.opacity(0.7))

            HStack(spacing: 4) {
                ForEach(0..<owned.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundStyle(owned.starGradient)
                        .shadow(color: owned.starColor.opacity(0.7), radius: 5)
                }
            }
            .padding(.top, 2)

            ProgressView(
                value: Double(owned.exp),
                total: Double(owned.requiredEXP)
            )
            .tint(character.rarity.color)

            HStack {

                Button(inTeam ? "Remove" : "Add") {

                    if inTeam {
                        teamManager.removeFromTeam(owned)
                    } else {
                        teamManager.addToTeam(owned)
                    }
                }
                .font(.caption.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(Capsule())
                .foregroundStyle(.white)
            }
        }
        .padding()
        .background(

            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .overlay(

                    RoundedRectangle(cornerRadius: 18)
                        .stroke(     LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .top,
                            endPoint: .bottom
                        ))
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
                                colors: theme.borderGradient,
                                startPoint: .top,
                                endPoint: .bottom
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
                            .onTapGesture {
                                if teamManager.activeTeam.count <= 1 {
                                    showTeamWarning = true
                                } else {
                                    teamManager.removeFromTeam(owned)
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
