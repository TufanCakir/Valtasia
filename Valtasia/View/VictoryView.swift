//
//  VictoryView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct VictoryView: View {

    @EnvironmentObject var appModel: AppModel
    var onContinue: () -> Void

    @State private var animate = false

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            // MARK: BACKGROUND
            LinearGradient(
                colors: theme.headerGradient.map { $0.opacity(0.9) },
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {

                Spacer()

                // MARK: TITLE
                Text("VICTORY")
                    .font(.system(size: 42, weight: .heavy))
                    .tracking(3)
                    .foregroundStyle(.white)
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.5), value: animate)

                Text("Enemy Defeated")
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.7))
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.7), value: animate)

                // MARK: CARD
                VStack(spacing: 16) {

                    Divider()
                        .background(.white.opacity(0.15))

                    // 👉 hier kannst du später Rewards reinbauen
                    Text("Well done, hero.")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))

                    Divider()
                        .background(.white.opacity(0.15))

                    // MARK: BUTTON
                    Button {
                        onContinue()
                    } label: {
                        Text("Continue")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(
                                        LinearGradient(
                                            colors: theme.borderGradient,
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                            )
                            .foregroundStyle(.white)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.3))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: theme.borderGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1.5
                        )
                )
                .padding(.horizontal, 28)
                .scaleEffect(animate ? 1 : 0.95)
                .opacity(animate ? 1 : 0)
                .animation(.easeOut(duration: 0.8), value: animate)

                Spacer()
            }
        }
        .onAppear {
            animate = true
        }
    }
}
