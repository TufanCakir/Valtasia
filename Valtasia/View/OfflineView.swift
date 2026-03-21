//
//  OfflineView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct OfflineView: View {
    
    @EnvironmentObject var appModel: AppModel

    @ObservedObject private var network = NetworkMonitor.shared
    @Environment(\.dismiss) private var dismiss

    @State private var animate = false
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            // MARK: Background
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // MARK: Card
            VStack(spacing: 30) {

                statusIcon

                VStack(spacing: 10) {

                    Text("No Internet Connection")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("Valtasia requires an active internet connection.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.white.opacity(0.7))
                        .padding(.horizontal)
                }

                actionButton
            }
            .padding(30)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .overlay(
                RoundedRectangle(cornerRadius: 28)
                    .stroke(.white.opacity(0.12))
            )
            .padding(.horizontal, 30)
        }
        .onAppear { animate = true }
        .onChange(of: network.isConnected) { oldValue, newValue in
            if newValue {
                dismiss()  // ⭐ AUTO CLOSE
            }
        }
    }
}

extension OfflineView {

    fileprivate var statusIcon: some View {
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

            if network.isChecking {
                ProgressView()
                    .scaleEffect(1.6)
                    .tint(.white)
            } else {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 55))
                    .foregroundStyle(.red)
            }
        }
    }
}

extension OfflineView {

    fileprivate var actionButton: some View {
        Button {
            network.checkConnection()
        } label: {

            HStack(spacing: 10) {

                if network.isChecking {
                    ProgressView()
                        .tint(.white)
                }

                Text(network.isChecking ? "Checking..." : "Retry Connection")
                    .font(.headline.bold())
            }
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
        .disabled(network.isChecking)
        .padding(.horizontal, 40)
        .foregroundStyle(.white)
        .shadow(color: .purple.opacity(0.4), radius: 10)
    }
}
