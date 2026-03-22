//
//  LevelBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 21.03.26.
//

import SwiftUI

struct LevelBarView: View {

    @EnvironmentObject var appModel: AppModel

    let node: WorldNode
    let onSelectLevel: (String) -> Void

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        VStack(spacing: 0) {

            ScrollView(.horizontal, showsIndicators: false) {

                HStack(spacing: 16) {

                    ForEach(node.levels, id: \.id) { level in

                        let unlocked = isUnlocked(level)
                        let isCurrent = isCurrentLevel(level)

                        Button {

                            guard unlocked else { return }
                            onSelectLevel(level.id)

                        } label: {

                            ZStack {

                                Circle()
                                    .fill(
                                        unlocked
                                            ? AnyShapeStyle(
                                                LinearGradient(
                                                    colors: theme
                                                        .headerGradient,
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            : AnyShapeStyle(
                                                Color.black.opacity(0.35)
                                            )
                                    )
                                    .frame(width: 28, height: 28)

                                Text(levelNumber(level.id))
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(.white)

                                if !unlocked {
                                    Image(systemName: "lock.fill")
                                        .font(.system(size: 8))
                                        .foregroundStyle(.white.opacity(0.6))
                                }
                            }
                            .scaleEffect(isCurrent ? 1.15 : 1)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }

    private func isCurrentLevel(_ level: Level) -> Bool {

        for lvl in node.levels {
            if !appModel.progress.clearedLevels.contains(lvl.id) {
                return lvl.id == level.id
            }
        }

        return false
    }
}

// MARK: - Helpers
extension LevelBarView {

    private func levelNumber(_ id: String) -> String {
        id.replacingOccurrences(of: "level_", with: "")
    }

    private func isUnlocked(_ level: Level) -> Bool {

        guard let index = node.levels.firstIndex(where: { $0.id == level.id })
        else { return false }

        if index == 0 { return true }

        let previous = node.levels[index - 1]

        return appModel.progress.clearedLevels.contains(previous.id)
    }
}
