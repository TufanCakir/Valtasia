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
    
    private let worldNodeSize: CGFloat = 30

    private var visibleWorlds: [World] {
        appModel.tutorialState == .done
            ? appModel.worlds.filter { $0.id != "world_tutorial" }
            : appModel.worlds
    }

    func startLevelFlow(_ levelId: String) {
        guard !appModel.teamManager.activeTeam.isEmpty else { return }

        withAnimation(.easeInOut(duration: 0.35)) {
            zoomToBattle = true
            fadeToBattle = true
        }

        appModel.navigateWithLoading {
            appModel.startLevel(levelId)
        }
    }

    private var modeSwitch: some View {
        HStack {
            modeButton("Island", .island)
            modeButton("Corrupted", .corrupted)
        }
        .padding()
        .background(
            LinearGradient(
                colors: theme.borderGradient,
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }

    func modeButton(_ title: String, _ mode: HomeMode) -> some View {
        let active = appModel.homeMode == mode

        return Button {
            withAnimation(.spring()) {
                appModel.homeMode = mode
            }
        } label: {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(active ? .white : .white.opacity(0.6))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: active
                            ? theme.borderGradient
                            : [.clear, .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
        }
    }

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        
        ZStack {

            // ⭐ BACKGROUND FULLSCREEN
            if appModel.homeMode == .corrupted {
                if let selected = visibleWorlds[safe: selectedWorldIndex],
                   let world = appModel.corruptedWorlds.first(where: { $0.id == selected.id }) {

                    Image(world.background)
                        .resizable()
                        .scaledToFill()
                }
            } else {
                if let world = visibleWorlds[safe: selectedWorldIndex] {
                    Image(world.background)
                        .resizable()
                        .scaledToFill()
                }
            }

            // ⭐ CONTENT (SAFE AREA!)
            VStack {
                GameHeaderView()

                worldMapSection
                modeSwitch
                eventButton

                if appModel.homeMode == .island {
                    worldBar
                } else {
                    portalBar
                }
            }
            .scaleEffect(zoomToBattle ? 1.12 : 1)
            .blur(radius: zoomToBattle ? 8 : 0)
            .animation(.easeInOut(duration: 0.4), value: zoomToBattle)

            // ⭐ Fade Overlay (kept inside ZStack)
            Color.black
                .opacity(fadeToBattle ? 0.85 : 0)
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.35), value: fadeToBattle)
        }
        .fullScreenCover(
            isPresented: Binding(
                get: {
                    appModel.selectedLevelId != nil
                },
                set: { newValue in
                    if !newValue {
                        appModel.selectedLevelId = nil
                        fadeToBattle = false
                        zoomToBattle = false
                    }
                }
            )
        ) {
            if let levelId = appModel.selectedLevelId {
                GameContainerView(
                    teamManager: appModel.teamManager,
                    levelId: levelId
                )
                .environmentObject(appModel)
            }
        }
        .onAppear {
            validateSelectedIndex()
            syncSelectedWorld()

            if appModel.tutorialState == .summon {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    showTutorialSummon = true
                }
            }
        }
        .onChange(of: appModel.tutorialState) { _, newState in
            if newState == .summon {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    showTutorialSummon = true
                }
            }
        }
        .onChange(of: visibleWorlds.count) { _, _ in
            validateSelectedIndex()
            if appModel.tutorialState == .done {
                if let index = visibleWorlds.firstIndex(where: {
                    $0.id == "world_1"
                }) {
                    selectedWorldIndex = index
                }
            }
        }
        .onChange(of: appModel.worlds.count) { _, _ in
            validateSelectedIndex()
        }
        .onChange(of: appModel.selectedWorld?.id) { _, _ in
            syncSelectedWorld()   // 👈 NEU
        }
        .fullScreenCover(isPresented: $showTutorialSummon) {
            SummonView(
                teamManager: appModel.teamManager,
                isTutorial: true
            )
        }
    }
}

extension HomeView {

    func syncSelectedWorld() {
        guard let selected = appModel.selectedWorld else { return }

        let worlds = visibleWorlds

        if let index = worlds.firstIndex(where: { $0.id == selected.id }) {
            withAnimation(.spring()) {
                selectedWorldIndex = index
            }
        }
    }
}

extension HomeView {

    fileprivate var eventButton: some View {

        HStack(spacing: 16) {
            
            Button {
                appModel.appState = .story
            } label: {
                iconCapsule(
                    icon: "book",
                )
            }

            NavigationLink {
                GiftView()
            } label: {
                iconCapsule(
                    icon: "gift.fill",
                )
            }

            NavigationLink {
                EventView()
            } label: {
                iconCapsule(
                    icon: "gamecontroller.fill",
                )
            }

            NavigationLink {
                DailyRewardView()
            } label: {
                iconCapsule(
                    icon: "calendar",
                )
            }

            NavigationLink {
                SettingsView()
            } label: {
                iconCapsule(
                    icon: "gearshape.fill",
                )
            }
        }
    }
}

extension HomeView {
    
    func iconCapsule(icon: String) -> some View {
        
        ZStack {
            Capsule()
                .fill(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
        }
        .frame(width: 50, height: 50)
        .shadow(
            color: (theme.borderGradient.last ?? .white).opacity(0.4),
            radius: 8
        )
    }
}

extension HomeView {

    fileprivate var worldMapSection: some View {
        Group {
            if let world = visibleWorlds[safe: selectedWorldIndex] {

                if appModel.homeMode == .island {

                    HomeWorldMapView(world: world) { levelId in
                        startLevelFlow(levelId)
                    }

                } else {

                    // ⭐ PORTAL JSON verwenden!
                    if let corruptedWorld = appModel.corruptedWorlds.first(where: {
                        $0.id == world.id
                    }) {
                        CorruptedWorldMapView(world: corruptedWorld) { levelId in
                            startLevelFlow(levelId)
                        }
                    } else {
                        Text("⚠️ No corrupted data")
                    }
                }
            }
        }
    }
}

extension HomeView {

    func portalWorldButton(for world: World, index: Int) -> some View {

        let isSelected = index == selectedWorldIndex
        let isLocked = !appModel.progress.isWorldUnlocked(world)

        return Button {
            guard !isLocked else { return }  // ❗ verhindert Klick

            withAnimation(.spring()) {
                selectedWorldIndex = index
            }

        } label: {

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors:
                                isLocked
                                ? [.gray.opacity(0.5), .black]
                                : isSelected
                                    ? [.black, .green]
                                    : [.black, .green],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: worldNodeSize, height: worldNodeSize)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .green,
                                        .green,
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .scaleEffect(isSelected ? 1.15 : 1)

                Text("\(index + 1)")
                    .foregroundStyle(.white)
                    .font(.caption.bold())

                // 🔒 LOCK ICON
                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.white)
                        .padding(6)
                        .background(.black.opacity(0.7))
                        .clipShape(Circle())
                        .opacity(isLocked ? 0.6 : 1)
                }
            }
        }
    }

    var portalBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(Array(visibleWorlds.enumerated()), id: \.element.id) {
                    index,
                    world in
                    portalWorldButton(for: world, index: index)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black,
                            Color.green,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.black,
                                    Color.green,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                )
        )
        .padding()
        .padding(.bottom)
    }
}

extension HomeView {

    fileprivate var worldBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(
                    Array(visibleWorlds.enumerated()),
                    id: \.element.id
                ) { index, world in
                    worldButton(for: world, index: index)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black,
                            Color.indigo,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.black,
                                    Color.indigo,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 3
                        )
                )
        )
        .padding()
        .padding(.bottom)
    }

    private var worldBarBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black,
                    Color.indigo,
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    LinearGradient(
                        colors: [
                            Color.black,
                            Color.indigo,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 1.5
                )
        }
    }
}

extension HomeView {

    fileprivate func worldButton(
        for world: World,
        index: Int
    ) -> some View {

        let isSelected = index == selectedWorldIndex
        let isLocked = !appModel.progress.isWorldUnlocked(world)

        return Button {
            guard !isLocked else { return }

            withAnimation(.spring()) {
                selectedWorldIndex = index
            }

        } label: {

            ZStack {

                Circle()
                    .fill(
                        LinearGradient(
                            colors:
                                isLocked
                                ? [.gray.opacity(0.5), .black]
                                : isSelected
                                    ? [.black, .indigo]
                                    : [.black, .indigo],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: worldNodeSize, height: worldNodeSize)

                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [.indigo, .indigo],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 3 : 3
                            )
                    )

                    .scaleEffect(isSelected ? 1.15 : 1)

                Text("\(index + 1)")
                    .foregroundStyle(.white)
                    .font(.caption.bold())

                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.white)
                        .clipShape(Circle())
                }
            }
        }
        .buttonStyle(.plain)
    }

    fileprivate var lockOverlay: some View {
        Image(systemName: "lock.fill")
            .font(.caption)
            .foregroundStyle(.white)
            .padding()
            .background(Circle().fill(.black.opacity(0.6)))
            .offset(y: 22)
    }
}

extension HomeView {

    fileprivate func validateSelectedIndex() {
        if selectedWorldIndex >= visibleWorlds.count {
            selectedWorldIndex = max(0, visibleWorlds.count - 1)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
}
