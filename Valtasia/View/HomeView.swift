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
    
    var body: some View {
        ZStack {
            VStack {
                GameHeaderView()
                    .padding()
                
                worldMapSection
                eventButton
                worldBar
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
        }
        .onChange(of: appModel.worlds.count) {
            validateSelectedIndex()
        }
        .onAppear {
            validateSelectedIndex()
            
            if appModel.tutorialState == .fight {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    appModel.startLevel("tutorial_level")
                }
            }
        }
        .fullScreenCover(
            isPresented: Binding(
                get: { appModel.tutorialState == .summon },
                set: { _ in }
            )
        ) {
            SummonView(
                teamManager: appModel.teamManager,
                isTutorial: true
            )
        }
    }
}

extension HomeView {

    fileprivate var eventButton: some View {

        HStack(spacing: 30) {

            NavigationLink {
                GiftView()
            } label: {
                iconCapsule(
                    icon: "gift.fill",
                    colors: [.yellow, .orange]
                )
            }

            NavigationLink {
                EventView()
            } label: {
                iconCapsule(
                    icon: "sparkles",
                    colors: [.cyan, .purple]
                )
            }

            NavigationLink {
                DailyRewardView()
            } label: {
                iconCapsule(
                    icon: "calendar",
                    colors: [.green, .cyan]
                )
            }

            NavigationLink {
                SettingsView()
            } label: {
                iconCapsule(
                    icon: "gearshape.fill",
                    colors: [.purple, .blue]
                )
            }
            NavigationLink {

                FeedbackView()

            } label: {

                iconCapsule(
                    icon: "bubble.left.and.bubble.right.fill",
                    colors: [.cyan, .purple]
                )
            }
        }
        .padding(.horizontal)
    }
}

extension HomeView {

    func iconCapsule(
        icon: String,
        colors: [Color]
    ) -> some View {

        ZStack {

            Capsule()
                .fill(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.white)
        }
        .frame(width: 50, height: 50)
        .shadow(color: colors.first?.opacity(0.4) ?? .clear, radius: 8)
    }
}

extension HomeView {

    fileprivate var worldMapSection: some View {
        Group {
            if let world = appModel.worlds[safe: selectedWorldIndex] {
                HomeWorldMapView(world: world) { levelId in

                    guard !appModel.teamManager.activeTeam.isEmpty else {
                        print("⚠️ Team ist leer")
                        return
                    }

                    withAnimation(.easeInOut(duration: 0.35)) {

                        zoomToBattle = true
                        fadeToBattle = true
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) {
                        appModel.startLevel(levelId)
                    }
                }
            }
        }
    }
}

extension HomeView {

    fileprivate var worldBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(
                    Array(appModel.worlds.enumerated()),
                    id: \.element.id
                ) { index, world in
                    worldButton(for: world, index: index)
                }
            }
            .padding()
        }
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .background(
                    worldBarBackground.clipShape(
                        RoundedRectangle(cornerRadius: 28)
                    )
                )
        )
        .padding()
    }

    private var worldBarBackground: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color.black.opacity(0.95),
                    Color.blue.opacity(0.35),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            RoundedRectangle(cornerRadius: 28)
                .stroke(
                    LinearGradient(
                        colors: [
                            .cyan.opacity(0.7),
                            .purple.opacity(0.6),
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
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
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
                                    ? [.cyan, .purple]
                                    : [.blue.opacity(0.6), .black],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 30, height: 30)
                    .overlay(
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .cyan.opacity(0.8),
                                        .purple.opacity(0.7),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
                    .shadow(
                        color: isSelected
                            ? .cyan.opacity(0.7)
                            : .black.opacity(0.4),
                        radius: isSelected ? 14 : 8
                    )
                    .scaleEffect(isSelected ? 1.15 : 1)

                Text("\(index + 1)")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)

                if isLocked {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.white)
                        .padding()
                        .background(.black.opacity(0.6))
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
        if selectedWorldIndex >= appModel.worlds.count {
            selectedWorldIndex = max(0, appModel.worlds.count - 1)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppModel())
}
