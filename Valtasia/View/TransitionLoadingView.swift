//
//  TransitionLoadingView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct TransitionLoadingView: View {

    @EnvironmentObject var appModel: AppModel

    var body: some View {
        ZStack {

            // MARK: Background Image
            Image(appModel.currentLoadingImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // MARK: Gradient Overlay (wie SummonView Background)
            LinearGradient(
                colors: [
                    Color.black.opacity(0.85),
                    Color.blue.opacity(0.35),
                    Color.black.opacity(0.9),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // MARK: Center Card
            VStack(spacing: 26) {

                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 110, height: 110)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [
                                            .cyan.opacity(0.8),
                                            .purple.opacity(0.8),
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .cyan.opacity(0.35), radius: 18)

                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.8)
                }

                VStack(spacing: 8) {
                    Text("Loading")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Preparing your battle…")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 36)
            .background(
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 28)
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
            .shadow(color: .black.opacity(0.6), radius: 30, y: 10)
        }
        .transition(.opacity)
    }
}
