//
//  ModeSwitchView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.04.26.
//

import SwiftUI

struct ModeSwitchView: View {
    @EnvironmentObject var appModel: AppModel

    let theme: UITheme?

    init(theme: UITheme? = nil) {
        self.theme = theme
    }

    var body: some View {
        HStack {
            modeButton("Island", mode: .island)
            modeButton("Corrupted", mode: .corrupted)
        }
        .padding()
        .background(
            LinearGradient(
                colors: resolvedTheme.headerGradient,
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: resolvedTheme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

extension ModeSwitchView {

    fileprivate var resolvedTheme: UITheme {
        theme ?? (appModel.homeMode == .corrupted ? .corrupted : .island)
    }

    fileprivate func modeButton(_ title: String, mode: HomeMode) -> some View {
        let isActive = appModel.homeMode == mode

        return Button {
            withAnimation(.spring()) {
                appModel.homeMode = mode
            }
        } label: {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(isActive ? .white : .white.opacity(0.6))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: isActive
                            ? resolvedTheme.headerGradient : [.clear, .clear],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
        }
    }
}
