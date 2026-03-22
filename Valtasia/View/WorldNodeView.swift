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

        Button {
            guard isUnlocked else { return }

            withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                onTap()
            }

        } label: {

            ZStack {

                // MARK: NODE
                nodeView

                // MARK: LOCK
                if !isUnlocked {
                    lockOverlay
                }
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - NODE UI
extension WorldNodeView {

    private var nodeView: some View {
        ZStack {

            Circle()
                .fill(Color.black.opacity(0.4))

            Circle()
                .stroke(
                    isFocused
                        ? LinearGradient(
                            colors: [.indigo, .purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : LinearGradient(
                            colors: [.white.opacity(0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                    lineWidth: isFocused ? 2.5 : 1.2
                )

            Image(node.image)
                .resizable()
                .scaledToFit()
                .padding(14)
        }
        .frame(
            width: min(geo.size.width * 0.22, 100),
            height: min(geo.size.width * 0.22, 100)
        )
        .opacity(isUnlocked ? 1 : 0.35)
        .scaleEffect(isFocused ? 1.08 : 1)
    }
}

// MARK: - LOCK
extension WorldNodeView {

    private var lockOverlay: some View {
        Image(systemName: "lock.fill")
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(8)
            .background(
                Circle()
                    .fill(Color.black.opacity(0.75))
            )
    }
}

// MARK: - HELPERS
extension WorldNodeView {

    private func levelNumber(_ id: String) -> String {
        id.replacingOccurrences(of: "level_", with: "")
    }

    private func isLevelUnlocked(_ level: Level) -> Bool {

        guard let index = node.levels.firstIndex(where: { $0.id == level.id })
        else { return false }

        if index == 0 { return true }

        let previous = node.levels[index - 1]

        return appModel.progress.clearedLevels.contains(previous.id)
    }
}
