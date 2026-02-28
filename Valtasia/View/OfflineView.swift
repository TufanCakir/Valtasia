//
//  OfflineView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct OfflineView: View {

    @State private var animate = false

    var body: some View {

        ZStack {

            // Background
            LinearGradient(
                colors: [
                    .black,
                    .blue.opacity(0.4),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            RadialGradient(
                colors: [.purple.opacity(0.4), .clear],
                center: .topTrailing,
                startRadius: 50,
                endRadius: 500
            )
            .ignoresSafeArea()

            VStack(spacing: 30) {

                ZStack {

                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [.red, .pink],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 3
                                )
                        )
                        .shadow(
                            color: .red.opacity(0.5),
                            radius: animate ? 25 : 10
                        )
                        .animation(
                            .easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: animate
                        )

                    Image(systemName: "wifi.slash")
                        .font(.system(size: 55))
                        .foregroundStyle(.red)
                }

                VStack(spacing: 8) {

                    Text("No Internet Connection")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text(
                        "Valtasia requires an active internet connection to continue."
                    )
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.7))
                    .padding(.horizontal)
                }

                Button {
                    // Retry Logic hier einfügen
                } label: {

                    Text("Retry Connection")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 40)
                .foregroundStyle(.white)
                .shadow(color: .purple.opacity(0.4), radius: 10)
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.horizontal, 30)
        }
        .onAppear {
            animate = true
        }
    }
}
