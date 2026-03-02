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
                    pendingAmount == 1
                    ? banner.currencyCost
                    : (banner.multiCost ?? banner.currencyCost * pendingAmount)

                HStack(spacing: 6) {
                    Text(
                        "Möchtest du \(pendingAmount) Charakter(e) für \(cost) "
                    )
                    Image(systemName: "diamond.fill")
                        .foregroundStyle(.cyan)
                    Text(" beschwören?")
                }
            }
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

            HStack(spacing: 12) {

                Text(banner.title)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                summonButtons(for: banner)
            }
            .padding()

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

            summonButton(
                cost: banner.currencyCost,
                amount: 1,
                colors: [.purple, .blue],
                banner: banner
            )

            if let multiAmount = banner.multiAmount {

                let multiCost =
                    banner.multiCost ?? banner.currencyCost * multiAmount

                summonButton(
                    cost: multiCost,
                    amount: multiAmount,
                    colors: [.cyan, .purple],
                    banner: banner
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func summonButton(
        cost: Int,
        amount: Int,
        colors: [Color],
        banner: SummonBanner
    ) -> some View {

        Button {
            pendingBanner = banner
            pendingAmount = amount
            showSummonConfirm = true
        } label: {

            HStack {

                Image(systemName: "diamond.fill")
                    .font(.caption)

                Text("x\(amount)")
                    .font(.caption.bold())
            }
            .foregroundStyle(.cyan)
            .padding()
            .background(
                LinearGradient(
                    colors: colors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
        }
    }
}

extension SummonView {

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
