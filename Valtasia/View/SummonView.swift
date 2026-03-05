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
    @StateObject private var crystalManager = CrystalManager.shared  // ✅ live updates
    @State private var selectedBanner: SummonBanner?
    @State private var selectedCharacter: Character?
    @State private var showNotEnoughCrystals = false
    @State private var pendingBanner: SummonBanner?
    @State private var pendingAmount: Int = 1
    @State private var showSummonConfirm = false
    @State private var summonResults: [Character] = []

    var body: some View {

        VStack {

            // MARK: HEADER
            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL AREA

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(summonManager.banners) { banner in
                        summonBannerCard(banner)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: .constant(!summonResults.isEmpty)) {
            SummonResultView(characters: summonResults)
        }
        .alert("Nicht genug Kristalle", isPresented: $showNotEnoughCrystals) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Du brauchst mehr Kristalle für diesen Summon.")
        }
        .sheet(item: $selectedBanner) { banner in

            SummonPoolView(
                banner: banner,
                rates: summonManager.rates(for: banner.id)
            )
        }
        .alert("Summon bestätigen", isPresented: $showSummonConfirm) {

            Button("Abbrechen", role: .cancel) {}

            Button("Bestätigen") {
                if let banner = pendingBanner {
                    performSummon(for: banner, amount: pendingAmount)
                }
            }

        } message: {

            if let banner = pendingBanner {

                let cost =
                    banner.summons
                    .first(where: { $0.amount == pendingAmount })?
                    .cost ?? 0

                Text("Do you want to summon \(pendingAmount) character(s) for \(cost) Crystals?")
            }
        }
    }
}

extension SummonView {
    
    func summonBannerCard(_ banner: SummonBanner) -> some View {

        ZStack {

          

            LinearGradient(
                colors: [.clear, .black.opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )

            HStack {

                // CHARACTER SIDE
                Image(banner.bannerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 180)

                Spacer()

                // CENTER CONTENT
                VStack(spacing: 12) {

                    Text(banner.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    summonButtons(for: banner)
                }
                .frame(maxWidth: .infinity)

                Spacer()

                infoButton(banner)
            }
            .padding(18)
        }
        .frame(height: 220)
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
    
    func infoButton(_ banner: SummonBanner) -> some View {
        
        Button {
            selectedBanner = banner
        } label: {
            
            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(8)
                .background(.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
    
    func summonButtons(for banner: SummonBanner) -> some View {

        HStack(spacing: 16) {

            ForEach(banner.summons) { option in

                summonButton(
                    cost: option.cost,
                    amount: option.amount,
                    banner: banner
                )
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func summonButton(
        cost: Int,
        amount: Int,
        banner: SummonBanner
    ) -> some View {
        
        Button {
            
            pendingBanner = banner
            pendingAmount = amount
            showSummonConfirm = true
            
        } label: {
            
            HStack(spacing: 6) {
                
                Image("icon_crystal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .shadow(color: .cyan.opacity(0.7), radius: 4)
                
                Text("\(cost)")
                    .bold()
            }
            .font(.subheadline)
            .foregroundStyle(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                
                LinearGradient(
                    colors: [.cyan, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .cyan.opacity(0.35), radius: 6)
        }
    }
}

extension SummonView {

    private func performSummon(
        for banner: SummonBanner,
        amount: Int
    ) {

        guard
            let option =
                banner.summons.first(where: { $0.amount == amount })
        else { return }

        let cost = option.cost

        guard CrystalManager.shared.spend(cost)
        else {
            showNotEnoughCrystals = true
            return
        }

        summonResults.removeAll()

        for _ in 0..<amount {

            if let character =
                summonManager.summon(from: banner.id)
            {

                let owned =
                    OwnedCharacter(base: character)

                teamManager
                    .ownedCharacters
                    .append(owned)

                summonResults.append(character)

                if teamManager.activeTeam.isEmpty {
                    teamManager.addToTeam(owned)
                }
            }
        }
    }
}

