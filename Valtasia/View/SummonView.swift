//
//  SummonView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonView: View {

    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

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
    var isTutorial: Bool = false
    @State private var showResults = false
    @State private var selectedCategory: String = "standard"
    @State private var tutorialSummonUsed = UserDefaults.standard.bool(
        forKey: "tutorial_summon_done"
    )

    var body: some View {

        VStack {

            // MARK: HEADER
            GameHeaderView()
                .padding()

            SummonCategoryTabs(
                categories: summonManager.categories,
                selected: $selectedCategory
            )
            .padding(.top, 8)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL AREA

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(
                        summonManager.banners(for: selectedCategory)
                            .filter { banner in
                                if isTutorial {
                                    return banner.id == "tutorial_banner"
                                        && !UserDefaults.standard.bool(
                                            forKey: "tutorial_summon_done"
                                        )
                                } else {
                                    return banner.id != "tutorial_banner"
                                }
                            }
                    ) { banner in
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
        .fullScreenCover(isPresented: $showResults) {
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

                let costText = isTutorial ? "FREE" : "\(cost) Crystals"

                Text(
                    isTutorial
                        ? (tutorialSummonUsed ? "COMPLETED" : "FREE")
                        : "\(cost)"
                )

                Text(
                    "Do you want to summon \(pendingAmount) character(s) for \(costText)?"
                )
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

            HStack(alignment: .center) {

                // ⭐ LINKS: Charakter + Banner Infos
                VStack(alignment: .leading, spacing: 10) {

                    Image(banner.bannerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)

                    // STEP
                    if let stepUp = banner.stepUp, stepUp.enabled,
                        let stepData = summonManager.currentStepData(
                            for: banner
                        )
                    {

                        Text("STEP \(stepData.step) / \(stepUp.steps.count)")
                            .font(.caption.bold())
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.black)
                            .clipShape(Capsule())
                    }

                    // PITY
                    if let pity = banner.pity, pity.enabled {
                        let pulls = PityManager.shared.pulls(for: banner.id)

                        Text("PITY \(pulls) / \(pity.requiredPulls)")
                            .font(.caption2.bold())
                            .foregroundStyle(.orange)
                    }
                }

                Spacer()

                // ⭐ MITTE: Titel + Buttons
                VStack(spacing: 14) {

                    Text(banner.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    summonButtons(for: banner)
                }

                Spacer()

                // ⭐ RECHTS: Info Button
                infoButton(banner)
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

        let stepData = summonManager.currentStepData(for: banner)
        let options = stepData?.costs ?? banner.summons

        return HStack(spacing: 16) {
            ForEach(options) { option in
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

        Button(
            action: {
                guard !isTutorial || !tutorialSummonUsed else { return }
                pendingBanner = banner
                pendingAmount = amount
                showSummonConfirm = true
            },
            label: {
                HStack(spacing: 6) {
                    if !isTutorial {
                        Image("icon_crystal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                            .shadow(color: .cyan.opacity(0.7), radius: 4)
                    }
                    Text(
                        isTutorial
                            ? (tutorialSummonUsed ? "COMPLETED" : "FREE")
                            : "\(cost)"
                    )

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
        )
        .disabled(isTutorial && tutorialSummonUsed)
        .opacity(isTutorial && tutorialSummonUsed ? 0.5 : 1)
    }
}

extension SummonView {

    private func performSummon(
        for banner: SummonBanner,
        amount: Int
    ) {

        let stepData = summonManager.currentStepData(for: banner)
        let options = stepData?.costs ?? banner.summons

        guard let option = options.first(where: { $0.amount == amount }) else {
            return
        }

        let cost = option.cost

        // ⭐ Nur zahlen wenn NICHT Tutorial
        if !isTutorial {
            switch banner.currency {

            case "crystal":
                guard CrystalManager.shared.spend(cost) else {
                    showNotEnoughCrystals = true
                    return
                }

            case "event_token":
                guard EventInventory.shared.tokens >= cost else {
                    showNotEnoughCrystals = true
                    return
                }
                EventInventory.shared.tokens -= cost

            default:
                break
            }
        }

        summonResults.removeAll()

        // ⭐ Charaktere erzeugen
        for _ in 0..<amount {

            if let character = summonManager.smartSummon(from: banner) {

                let owned = OwnedCharacter(base: character)
                teamManager.addOwnedCharacter(owned)
                summonResults.append(character)
            }
        }

        // ⭐ Ergebnis anzeigen (IMMER)
        showResults = true

        // ⭐ Tutorial-Extras
        if isTutorial {
            UserDefaults.standard.set(true, forKey: "tutorial_summon_done")
            appModel.tutorialState = .done

            // 🔥 Tutorial View schließen
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                dismiss()
            }
        }
    }
}
