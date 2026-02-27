//
//  SummonView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonView: View {

    @ObservedObject var teamManager: TeamManager
    @StateObject private var summonManager = SummonManager()

    @State private var selectedCharacter: Character?

    var body: some View {

        ScrollView {

            VStack(spacing: 24) {

                ForEach(summonManager.banners) { banner in

                    summonBannerButton(for: banner)
                }
            }
            .padding()
        }
        .navigationTitle("Summon")
        .navigationDestination(item: $selectedCharacter) { character in
            SummonResultView(character: character)
        }
    }

    // MARK: Banner Button

    private func summonBannerButton(
        for banner: SummonBanner
    ) -> some View {

        Button {

            performSummon(for: banner)

        } label: {

            ZStack(alignment: .bottom) {

                Image(banner.bannerImage)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 170)
                    .clipped()
                    .overlay(
                        LinearGradient(
                            colors: [.clear, .black.opacity(0.6)],
                            startPoint: .center,
                            endPoint: .bottom
                        )
                    )

                Text(banner.title)
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 12)
            }
            .cornerRadius(16)
            .shadow(radius: 8)
        }
    }

    // MARK: Summon Logic

    private func performSummon(
        for banner: SummonBanner
    ) {

        guard
            let character =
                summonManager.summon(from: banner.id)
        else { return }

        let owned =
            OwnedCharacter(base: character)

        teamManager.ownedCharacters.append(owned)

        selectedCharacter = character
    }
}
