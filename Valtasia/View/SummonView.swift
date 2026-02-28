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

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER
            header
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 12)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL AREA

            ScrollView {

                VStack(spacing: 32) {

                    ForEach(summonManager.banners) { banner in
                        summonBannerCard(banner)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 140)  // Platz für Footer
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
        .navigationDestination(item: $selectedCharacter) { character in
            SummonResultView(character: character)
        }
        .alert("Nicht genug Kristalle", isPresented: $showNotEnoughCrystals) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Du brauchst mehr Kristalle für diesen Summon.")
        }
        .sheet(item: $selectedBanner) { banner in
            SummonPoolView(
                banner: banner,
                characters: summonManager.characters
            )
        }
    }
}

extension SummonView {

    @ViewBuilder var header: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text("Summon Gate")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("Beschwöre legendäre Kämpfer")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            HStack(spacing: 10) {

                Image(systemName: "diamond.fill")
                    .foregroundStyle(.cyan)

                Text("\(crystalManager.crystals)")
                    .bold()
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

extension SummonView {

    func summonBannerCard(_ banner: SummonBanner) -> some View {

      

        return ZStack(alignment: .bottomLeading) {

            Image(banner.bannerImage)
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.95)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(alignment: .leading, spacing: 16) {

                Text(banner.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                VStack(alignment: .leading, spacing: 16) {

                    HStack(spacing: 16) {

                        Label("\(banner.currencyCost)", systemImage: "diamond.fill")
                            .foregroundStyle(.cyan)

                        Text("Pool: \(banner.pool.count)")
                            .font(.caption.bold())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.white.opacity(0.15))
                            .clipShape(Capsule())
                    }

                    summonButtons(for: banner)
                }
            }
            .padding(20)

            // Info Button
            VStack {
                HStack {
                    Spacer()
                    Button {
                        selectedBanner = banner
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding(10)
                            .background(.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                Spacer()
            }
            .padding()
        }
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
}

extension SummonView {
    
    func summonButtons(for banner: SummonBanner) -> some View {
        
        HStack(spacing: 12) {
            
            // SINGLE
            Button {
                performSummon(for: banner, amount: 1)
            } label: {
                Text("Summon x1")
                    .font(.caption.bold())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            
            // MULTI (wenn vorhanden)
            if let multiAmount = banner.multiAmount {
                
                Button {
                    performSummon(for: banner, amount: multiAmount)
                } label: {
                    Text("Summon x\(multiAmount)")
                        .font(.caption.bold())
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
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
    }
    
    private func performSummon(for banner: SummonBanner, amount: Int) {
        
        let cost: Int
        
        if amount == 1 {
            cost = banner.currencyCost
        } else {
            cost = banner.multiCost ?? banner.currencyCost * amount
        }
        
        guard CrystalManager.shared.spend(cost) else {
            showNotEnoughCrystals = true
            return
        }
        
        for _ in 0..<amount {
            
            if let character = summonManager.summon(from: banner.id) {
                
                let owned = OwnedCharacter(base: character)
                teamManager.ownedCharacters.append(owned)
                
                if teamManager.activeTeam.isEmpty {
                    teamManager.addToTeam(owned)
                }
                
                selectedCharacter = character
            }
        }
    }
}
