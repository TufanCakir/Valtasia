//
//  HomeWorldSelectorBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.04.26.
//

import SwiftUI

struct HomeWorldSelectorBarView: View {
    @EnvironmentObject var appModel: AppModel

    let homeMode: HomeMode
    @Binding var selectedWorldIndex: Int

    private let worldNodeSize: CGFloat = 30

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                switch homeMode {
                case .island:
                    ForEach(Array(visibleWorlds.enumerated()), id: \.element.id)
                    { index, world in
                        worldButton(for: world, index: index)
                    }
                case .corrupted:
                    ForEach(
                        Array(appModel.corruptedWorlds.enumerated()),
                        id: \.element.id
                    ) { index, world in
                        corruptedWorldButton(for: world, index: index)
                    }
                }
            }
            .padding()
        }
        .background(backgroundShape)
        .padding()
    }
}

extension HomeWorldSelectorBarView {

    fileprivate var visibleWorlds: [World] {
        appModel.tutorialState == .done
            ? appModel.worlds.filter { $0.id != "world_tutorial" }
            : appModel.worlds
    }

    fileprivate var backgroundShape: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                LinearGradient(
                    colors: backgroundColors,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: backgroundColors,
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: homeMode == .island ? 3 : 0
                    )
            )
    }

    fileprivate var backgroundColors: [Color] {
        switch homeMode {
        case .island:
            [.black, .indigo]
        case .corrupted:
            [.black, .green]
        }
    }

    fileprivate func worldButton(for world: World, index: Int) -> some View {
        let isSelected = index == selectedWorldIndex
        let isLocked = !appModel.progress.isWorldUnlocked(world)

        return Button {
            guard !isLocked else { return }

            withAnimation(.spring()) {
                selectedWorldIndex = index
            }
        } label: {
            selectorNode(
                index: index,
                isSelected: isSelected,
                isLocked: isLocked,
                fillColors: isLocked
                    ? [.gray.opacity(0.5), .black] : [.black, .indigo],
                strokeColors: [.indigo, .indigo],
                showsStroke: true
            )
        }
        .buttonStyle(.plain)
    }

    fileprivate func corruptedWorldButton(for world: CorruptedWorld, index: Int)
        -> some View
    {
        let isSelected = index == selectedWorldIndex
        let isLocked = !appModel.progress.isCorruptedWorldUnlocked(world)

        return Button {
            guard !isLocked else { return }

            withAnimation(.spring()) {
                selectedWorldIndex = index
            }
        } label: {
            selectorNode(
                index: index,
                isSelected: isSelected,
                isLocked: isLocked,
                fillColors: isLocked
                    ? [.gray.opacity(0.5), .black] : [.black, .green],
                strokeColors: [.clear, .clear],
                showsStroke: false
            )
        }
        .buttonStyle(.plain)
    }

    fileprivate func selectorNode(
        index: Int,
        isSelected: Bool,
        isLocked: Bool,
        fillColors: [Color],
        strokeColors: [Color],
        showsStroke: Bool
    ) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: fillColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: worldNodeSize, height: worldNodeSize)
                .overlay {
                    if showsStroke {
                        Circle()
                            .stroke(
                                LinearGradient(
                                    colors: strokeColors,
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 3
                            )
                    }
                }
                .scaleEffect(isSelected ? 1.15 : 1)

            Text("\(index + 1)")
                .foregroundStyle(.white)
                .font(.caption.bold())

            if isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.white)
            }
        }
    }
}
