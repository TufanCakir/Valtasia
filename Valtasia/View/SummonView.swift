//
//  SummonView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Combine
import SwiftUI

struct SummonView: View {

    @EnvironmentObject var appModel: AppModel
    @Environment(\.dismiss) private var dismiss

    @ObservedObject var teamManager: TeamManager
    @ObservedObject var summonManager = SummonManager.shared
    @StateObject private var crystalManager = GemManager.shared  // ✅ live updates
    @State private var selectedBanner: SummonBanner?
    @State private var selectedCharacter: Character?
    @State private var showNotEnoughGems = false
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
    @State private var refreshID = UUID()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        VStack {

            SummonCategoryTabs(
                categories: summonManager.categories,
                selected: $selectedCategory
            )

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL AREA

            ScrollView {

                VStack(spacing: 20) {

                    ForEach(
                        summonManager.banners(for: selectedCategory)
                    ) { banner in
                        summonBannerCard(banner)
                    }
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: theme.headerGradient,

                startPoint: .top,
                endPoint: .bottom
            )
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(isPresented: $showResults) {
            SummonResultView(characters: summonResults)
        }
        .alert("Nicht genug Gems", isPresented: $showNotEnoughGems) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Du brauchst mehr Gems für diesen Summon.")
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

                let costText = isTutorial ? "FREE" : "\(cost) Gems"

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

    func tagView(_ text: String) -> some View {
        Text(text)
            .font(.caption.bold())
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }

    func summonBannerCard(_ banner: SummonBanner) -> some View {

        ZStack {

            HStack(alignment: .center) {

                // ⭐ LINKS: Charakter + Banner Infos
                VStack(alignment: .leading, spacing: 8) {

                    Image(banner.bannerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 140)

                    if banner.category == "limited" {
                        Text(
                            "Ends in \(summonManager.timeRemaining(for: banner.id))"
                        )
                        .font(.caption.bold())
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            LinearGradient(
                                colors: theme.headerGradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .onReceive(timer) { _ in
                            refreshID = UUID()
                        }
                        .id(refreshID)
                    }

                    // ⭐ STEP (nur wenn vorhanden)
                    if let stepUp = banner.stepUp, stepUp.enabled,
                        let stepData = summonManager.currentStepData(
                            for: banner
                        )
                    {

                        tagView("STEP \(stepData.step) / \(stepUp.steps.count)")
                    }

                    // ⭐ PITY
                    if let pity = banner.pity, pity.enabled {
                        let pulls = PityManager.shared.pulls(for: banner.id)
                        tagView("PITY \(pulls) / \(pity.requiredPulls)")
                    }

                    // ⭐ SUMMONS
                    if banner.maxSummons > 0 {
                        let pulls = summonManager.totalPulls(for: banner.id)
                        let max = banner.maxSummons
                        tagView("SUMMONS \(pulls) / \(max)")
                    }
                }

                // ⭐ MITTE: Titel + Buttons
                VStack(spacing: 12) {

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
        .disabled(!summonManager.canSummon(banner))
        .opacity(summonManager.canSummon(banner) ? 1 : 0.4)
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }

    func infoButton(_ banner: SummonBanner) -> some View {

        Button {
            selectedBanner = banner
        } label: {

            Image(systemName: "info.circle.fill")
                .font(.title3)
                .foregroundStyle(.white)
                .padding(8)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.35))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: theme.borderGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
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
                        Image(banner.currency == "c_gem" ? "c_gem" : "icon_gem")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    Text(
                        !summonManager.canSummon(banner)
                            ? "COMPLETED"
                            : (isTutorial
                                ? (tutorialSummonUsed ? "COMPLETED" : "FREE")
                                : "\(cost)")
                    )

                    .bold()
                }
                .font(.subheadline)
                .foregroundStyle(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
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

        guard summonManager.canSummon(banner) else {
            print("❌ Max summons reached")
            return
        }

        let cost = option.cost

        // ⭐ Nur zahlen wenn NICHT Tutorial
        if !isTutorial {
            switch banner.currency {

            case "gem":
                guard GemManager.shared.spend(cost) else {
                    showNotEnoughGems = true
                    return
                }

            case "event_token":
                guard EventInventory.shared.tokens >= cost else {
                    showNotEnoughGems = true
                    return
                }
                EventInventory.shared.tokens -= cost

            case "c_gem":
                guard CorruptedGemManager.shared.spend(cost) else {
                    showNotEnoughGems = true
                    return
                }

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

        summonManager.addPull(for: banner.id)

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
