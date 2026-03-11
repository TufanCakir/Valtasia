//
//  VictoryView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct VictoryView: View {

    var onContinue: () -> Void

    var body: some View {

        ZStack {

            // MARK: Background Blur Overlay

            LinearGradient(
                colors: [
                    Color.black.opacity(0.85),
                    Color.blue.opacity(0.4),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {

                Text("VICTORY")
                    .font(.largeTitle.bold())
                    .tracking(2)
                    .foregroundStyle(.white)

                Text("Enemy Defeated!")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))

                Divider()
                    .background(.white.opacity(0.2))

                Button {
                    onContinue()
                } label: {

                    Text("Continue")
                        .font(.caption.bold())
                        .padding(.horizontal, 26)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [.purple, .blue],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        .cyan.opacity(0.7),
                                        .purple.opacity(0.6),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .cyan.opacity(0.35), radius: 20)
            .padding(.horizontal, 32)
        }
    }
}
