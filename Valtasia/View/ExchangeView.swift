//
//  ExchangeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct ExchangeView: View {

    @EnvironmentObject var appModel: AppModel

    @StateObject private var exchange = ExchangeManager.shared
    @StateObject private var coins = CoinManager.shared
    @StateObject private var gems = GemManager.shared
    @StateObject private var corruptedCoins = CorruptedCoinManager.shared
    @StateObject private var corruptedGems = CorruptedGemManager.shared

    @State private var showFail = false

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        VStack {

            modeSwitch
                .padding(.top, 15)

            // MARK: SCROLL AREA
            ScrollView {
                VStack(spacing: 32) {
                    let isCorrupted = appModel.homeMode == .corrupted

                    ForEach(
                        exchange.offers.filter {
                            isCorrupted
                                ? $0.corruptedCoinCost != nil
                                : $0.coinCost != nil
                        }
                    ) { offer in
                        offerCard(offer)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 100)
                }
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .alert(
            "Nicht genug Coins",
            isPresented: $showFail
        ) {
            Button("OK", role: .cancel) {}
        }
    }

    // MARK: - Mode Switch
    private var modeSwitch: some View {
        HStack {
            modeButton("Island", .island)
            modeButton("Corrupted", .corrupted)
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }

    private func modeButton(_ title: String, _ mode: HomeMode) -> some View {
        let active = appModel.homeMode == mode

        return Button {
            withAnimation(.spring()) {
                appModel.homeMode = mode
            }
        } label: {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(active ? .white : .white.opacity(0.6))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    active
                        ? LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        : nil
                )
                .clipShape(Capsule())
        }
    }
}

extension ExchangeView {
    func offerCard(_ offer: ExchangeOffer) -> some View {
        let isCorrupted = appModel.homeMode == .corrupted

        // 🔥 SAFE VALUES
        let cost =
            isCorrupted
            ? (offer.corruptedCoinCost ?? offer.coinCost ?? 0)
            : (offer.coinCost ?? 0)

        let reward =
            isCorrupted
            ? (offer.corruptedGemReward ?? offer.gemReward ?? 0)
            : (offer.gemReward ?? 0)

        let remaining = exchange.remaining(offer, isCorrupted: isCorrupted)

        let coinImage = isCorrupted ? "c_coin" : "icon_coin"
        let gemImage = isCorrupted ? "c_gem" : "icon_gem"

        return VStack(spacing: 16) {
            // MARK: HEADER
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(offer.title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("Limit: \(remaining) / \(offer.purchaseLimit)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()
            }

            // MARK: EXCHANGE ROW
            HStack {
                HStack(spacing: 6) {
                    Image(coinImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)

                    Text("-\(cost)")
                        .foregroundStyle(isCorrupted ? .green : .yellow)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .foregroundStyle(.white.opacity(0.4))

                Spacer()

                HStack(spacing: 6) {
                    Image(gemImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)

                    Text("+\(reward)")
                        .foregroundStyle(isCorrupted ? .green : .cyan)
                }
            }
            .font(.subheadline.bold())

            // MARK: BUTTON
            Button {
                if !exchange.buy(offer: offer, isCorrupted: isCorrupted) {
                    showFail = true
                }
            } label: {
                Text("Exchange")
                    .font(.caption.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .disabled(remaining == 0 || (cost == 0 && reward == 0))
            .opacity(remaining == 0 ? 0.4 : 1)
        }
        .padding()
        .background(Color.black.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
    }
}
