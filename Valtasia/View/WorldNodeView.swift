//
//  WorldNodeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct WorldNodeView: View {

    @EnvironmentObject var appModel: AppModel

    let node: WorldNode
    let geo: GeometryProxy
    let isUnlocked: Bool
    let isFocused: Bool
    let onTap: () -> Void
    let onSelectLevel: (String) -> Void

    var body: some View {

        ZStack {

            Button {

                guard isUnlocked else { return }

                withAnimation(
                    .spring(
                        response: 0.35,
                        dampingFraction: 0.75
                    )
                ) {
                    onTap()
                }

            } label: {

                ZStack {

                    // MARK: FOCUS GLOW

                    if isFocused {

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        .cyan.opacity(0.6),
                                        .clear,
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 120
                                )
                            )
                        .frame(width: 140, height: 140)
                    }

                    ZStack {
                        
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        .cyan.opacity(isFocused ? 0.6 : 0.3),
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 60
                                )
                            )
                            .frame(width: 100, height: 100)
                        
                        Image(node.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                    }
                        .frame(
                            width: min(geo.size.width * 0.22, 110),
                            height: min(geo.size.width * 0.22, 110)
                        )
                        .opacity(isUnlocked ? 1 : 0.35)
                        .scaleEffect(isFocused ? 1.15 : 1)
                        .shadow(
                            color: isFocused
                                ? .cyan.opacity(0.7)
                                : .black.opacity(0.5),
                            radius: isFocused ? 18 : 8
                        )

                        .overlay {

                            ZStack {

                                if !isUnlocked {
                                    lockOverlay
                                }

                                // ⭐ LEVELS AUF ISLAND
                                if isFocused {

                                    levelButtons
                                        .offset(y: 20) // ← Höhe auf Island einstellen
                                }
                            }
                        }
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var lockOverlay: some View {

        Image(systemName: "lock.fill")
            .font(.headline)
            .foregroundStyle(.white)
            .padding()
            .background(
                Circle()
                    .fill(.black.opacity(0.75))
                    .overlay(
                        Circle()
                            .stroke(.white.opacity(0.4))
                    )
            )
    }

    private var levelButtons: some View {

        HStack(spacing: 20) {

            ForEach(node.levels) { level in

                let unlocked = isLevelUnlocked(level)

                Button {

                    guard unlocked else { return }

                    onSelectLevel(level.id)

                } label: {

                    ZStack {

                        Circle()
                            .fill(
                                unlocked
                                ? LinearGradient(colors: [.purple, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing)
                                : LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                            )

                            .frame(width: 36, height: 36)

                            .overlay(

                                Circle()
                                    .stroke(
                                        .white.opacity(0.5),
                                        lineWidth: 1.2
                                    )
                            )

                            .shadow(
                                color: unlocked
                                    ? .cyan.opacity(0.6)
                                    : .black.opacity(0.4),
                                radius: 8
                            )

                        Text(

                            level.id
                                .replacingOccurrences(
                                    of: "level_",
                                    with: ""
                                )
                        )
                        .font(.caption.bold())
                        .foregroundStyle(.white)

                        if !unlocked {

                            Image(systemName: "lock.fill")
                                .font(.caption)
                                .foregroundStyle(.white)
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    private func isLevelUnlocked(_ level: Level) -> Bool {

        guard let index = node.levels.firstIndex(where: { $0.id == level.id })
        else {
            return false
        }

        if index == 0 { return true }

        let previous = node.levels[index - 1]

        return appModel.progress.clearedLevels.contains(previous.id)
    }
}
