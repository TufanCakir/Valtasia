//
//  TransitionLoadingView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct TransitionLoadingView: View {

    @EnvironmentObject var appModel: AppModel

    @State private var rotate = false
    @State private var pulse = false
    @State private var dots = 0

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        ZStack {

            // 🔹 BACKGROUND
            Image(appModel.currentLoadingImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .scaleEffect(pulse ? 1.05 : 1)
                .animation(
                    .easeInOut(duration: 2).repeatForever(autoreverses: true),
                    value: pulse
                )

            // 🔹 OVERLAY
            LinearGradient(
                colors: [
                    Color.black.opacity(0.9),
                    theme.headerGradient.last?.opacity(0.4) ?? .blue,
                    Color.black.opacity(0.95),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            // 🔥 CONTENT
            VStack(spacing: 30) {

                Spacer()

                ZStack {

                    // ROTATING RING
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: theme.borderGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                        .frame(width: 110, height: 110)
                        .rotationEffect(.degrees(rotate ? 360 : 0))
                        .animation(
                            .linear(duration: 1.2).repeatForever(
                                autoreverses: false
                            ),
                            value: rotate
                        )

                    // INNER PULSE
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 80, height: 80)
                        .scaleEffect(pulse ? 1.1 : 0.9)
                        .animation(
                            .easeInOut(duration: 1).repeatForever(),
                            value: pulse
                        )

                    ProgressView()
                        .tint(.white)
                        .scaleEffect(1.6)
                }

                VStack(spacing: 10) {

                    Text("Entering Battle")
                        .font(.title2.bold())
                        .foregroundStyle(.white)

                    Text("Preparing your battle\(loadingDots)")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }
            .padding(.bottom, 80)
        }
        .onAppear {
            rotate = true
            pulse = true
            startDotsAnimation()
        }
        .transition(.opacity)
    }
}

extension TransitionLoadingView {

    var loadingDots: String {
        String(repeating: ".", count: dots)
    }

    func startDotsAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { _ in
            dots = (dots + 1) % 4
        }
    }
}
