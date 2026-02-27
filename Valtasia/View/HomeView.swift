//
//  HomeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var appModel: AppModel
    @State private var selectedWorldIndex = 0

    var body: some View {

        NavigationStack {

            ZStack {

                worldMapSection

                VStack {

                    GameHeaderView()

                    Spacer()

                    worldBar
                }
            }
            .navigationDestination(
                item: $appModel.selectedLevelId
            ) { levelId in
                GameContainerView(
                    teamManager: appModel.teamManager,
                    levelId: levelId
                )
                .environmentObject(appModel)
                .toolbar(.hidden, for: .tabBar)
            }
        }
        .onAppear {
            validateSelectedIndex()
        }
        .onChange(of: appModel.worlds.count) {
            validateSelectedIndex()
        }
    }
}

extension HomeView {

    fileprivate var worldMapSection: some View {
        Group {
            if let world = appModel.worlds[safe: selectedWorldIndex] {

                HomeWorldMapView(world: world) { levelId in
                    appModel.startLevel(levelId)
                }

            } else {
                Color.black.ignoresSafeArea()
            }
        }
    }
}

extension HomeView {

    fileprivate var worldBar: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 20) {

                ForEach(
                    Array(appModel.worlds.enumerated()),
                    id: \.element.id
                ) { index, world in

                    worldButton(for: world, index: index)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(.ultraThinMaterial)
    }
}

extension HomeView {

    fileprivate func worldButton(for world: World, index: Int) -> some View {

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
                    .fill(isSelected ? .blue : .yellow)
                    .frame(width: 64, height: 64)
                    .scaleEffect(isSelected ? 1.1 : 1)
                    .animation(.spring(), value: isSelected)

                Text("\(index + 1)")
                    .font(.headline)
                    .foregroundStyle(.white)

                if isLocked {
                    lockOverlay
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(isLocked)
    }

    fileprivate var lockOverlay: some View {
        Image(systemName: "lock.fill")
            .font(.caption)
            .foregroundStyle(.white)
            .padding(6)
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

// MARK: Safe Array Access

extension Array {

    fileprivate subscript(safe index: Int) -> Element? {

        indices.contains(index)
            ? self[index]
            : nil
    }
}
