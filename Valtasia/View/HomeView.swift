//
//  HomeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var eventManager: EventManager

    @State private var fadeToBattle = false
    @State private var selectedWorldIndex = 0
    @State private var zoomToBattle = false
    @State private var showTutorialSummon = false

    private var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    private var visibleWorlds: [World] {
        appModel.tutorialState == .done
            ? appModel.worlds.filter { $0.id != "world_tutorial" }
            : appModel.worlds
    }

    private var currentBottomInset: CGFloat {
        UIDevice.current.userInterfaceIdiom == .pad ? 200 : 0
    }

    private var currentBackgroundName: String? {
        switch appModel.homeMode {
        case .island:
            visibleWorlds[safe: selectedWorldIndex]?.background
        case .corrupted:
            appModel.corruptedWorlds[safe: selectedWorldIndex]?.background
        }
    }

    private var isShowingBattle: Binding<Bool> {
        Binding(
            get: { appModel.selectedLevelId != nil },
            set: { newValue in
                guard !newValue else { return }
                appModel.selectedLevelId = nil
                fadeToBattle = false
                zoomToBattle = false
            }
        )
    }

    var body: some View {
        ZStack {
            backgroundView

            VStack {
                worldMapSection
                ModeSwitchView(theme: theme)
                HomeActionBarView(theme: theme)
                selectorBar
                    .padding(.bottom, currentBottomInset)
            }
            .padding()
            .scaleEffect(zoomToBattle ? 1.12 : 1)
            .blur(radius: zoomToBattle ? 8 : 0)
            .animation(.easeInOut(duration: 0.4), value: zoomToBattle)

            Color.black
                .opacity(fadeToBattle ? 0.85 : 0)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.35), value: fadeToBattle)
        }
        .fullScreenCover(isPresented: isShowingBattle) {
            if let levelId = appModel.selectedLevelId {
                GameContainerView(
                    teamManager: appModel.teamManager,
                    levelId: levelId
                )
                .environmentObject(appModel)
            }
        }
        .fullScreenCover(isPresented: $showTutorialSummon) {
            SummonView(
                teamManager: appModel.teamManager,
                isTutorial: true
            )
        }
        .onAppear(perform: handleAppear)
        .onChange(of: appModel.tutorialState) { _, newState in
            guard newState == .summon else { return }
            presentTutorialSummon(after: 0.4)
        }
        .onChange(of: visibleWorlds.count) { _, _ in
            handleVisibleWorldsChange()
        }
        .onChange(of: appModel.worlds.count) { _, _ in
            validateSelectedIndex()
        }
        .onChange(of: appModel.homeMode) { _, _ in
            validateSelectedIndex()
        }
        .onChange(of: appModel.selectedWorld?.id) { _, _ in
            syncSelectedWorld()
        }
    }
}

extension HomeView {

    fileprivate var backgroundView: some View {
        Group {
            if let backgroundName = currentBackgroundName {
                Image(backgroundName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        }
    }

    fileprivate var worldMapSection: some View {
        Group {
            switch appModel.homeMode {
            case .island:
                if let world = visibleWorlds[safe: selectedWorldIndex] {
                    HomeWorldMapView(
                        world: world,
                        onSelectLevel: startLevelFlow
                    )
                }
            case .corrupted:
                if let world = appModel.corruptedWorlds[
                    safe: selectedWorldIndex
                ] {
                    CorruptedWorldMapView(
                        world: world,
                        onSelectLevel: startLevelFlow
                    )
                } else {
                    Text("No corrupted data")
                        .foregroundStyle(.white)
                }
            }
        }
    }

    fileprivate var selectorBar: some View {
        HomeWorldSelectorBarView(
            homeMode: appModel.homeMode,
            selectedWorldIndex: $selectedWorldIndex
        )
        .environmentObject(appModel)
    }

    fileprivate func startLevelFlow(_ levelId: String) {
        guard !appModel.teamManager.activeTeam.isEmpty else { return }

        withAnimation(.easeInOut(duration: 0.35)) {
            zoomToBattle = true
            fadeToBattle = true
        }

        appModel.navigateWithLoading {
            appModel.startLevel(levelId)
        }
    }

    fileprivate func handleAppear() {
        validateSelectedIndex()
        syncSelectedWorld()

        if appModel.tutorialState == .summon {
            presentTutorialSummon(after: 0.6)
        }
    }

    fileprivate func handleVisibleWorldsChange() {
        validateSelectedIndex()

        guard appModel.tutorialState == .done,
            let index = visibleWorlds.firstIndex(where: { $0.id == "world_1" })
        else {
            return
        }

        selectedWorldIndex = index
    }

    fileprivate func presentTutorialSummon(after delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            showTutorialSummon = true
        }
    }

    fileprivate func syncSelectedWorld() {
        guard appModel.homeMode == .island,
            let selected = appModel.selectedWorld,
            let index = visibleWorlds.firstIndex(where: { $0.id == selected.id }
            )
        else {
            return
        }

        withAnimation(.spring()) {
            selectedWorldIndex = index
        }
    }

    fileprivate func validateSelectedIndex() {
        let worldsCount: Int

        switch appModel.homeMode {
        case .island:
            worldsCount = visibleWorlds.count
        case .corrupted:
            worldsCount = appModel.corruptedWorlds.count
        }

        guard worldsCount > 0 else {
            selectedWorldIndex = 0
            return
        }

        if selectedWorldIndex >= worldsCount {
            selectedWorldIndex = worldsCount - 1
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
}
