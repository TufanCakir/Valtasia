//
//  ExchangeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct ExchangeView: View {

    @StateObject private var exchange = ExchangeManager.shared
    @StateObject private var coins = CoinManager.shared
    @StateObject private var crystals = CrystalManager.shared

    @State private var showFail = false

    var body: some View {

        VStack {

            // MARK: HEADER
            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL AREA
            ScrollView {

                VStack(spacing: 32) {

                    ForEach(exchange.offers) { offer in
                        offerCard(offer)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 140)  // Platz für Footer
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.25),
                ],
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
}

extension ExchangeView {

    func offerCard(_ offer: ExchangeOffer) -> some View {

        let remaining = exchange.remaining(offer)

        return ZStack {

            // Soft Background
            LinearGradient(
                colors: [
                    .purple.opacity(0.25),
                    .blue.opacity(0.2),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 18) {

                // Top Row
                HStack {

                    VStack(alignment: .leading, spacing: 4) {

                        Text(offer.title)
                            .font(.title3.bold())
                            .foregroundStyle(.white)

                        Text("Limit: \(remaining) / \(offer.purchaseLimit)")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.7))
                    }

                    Spacer()
                }

                // Exchange Row
                HStack {

                    HStack(spacing: 6) {

                        Image("icon_coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("-\(offer.coinCost)")
                            .foregroundStyle(.yellow)
                    }

                    Spacer()

                    Image(systemName: "arrow.right")
                        .foregroundStyle(.white.opacity(0.5))

                    Spacer()

                    HStack(spacing: 6) {

                        Image("icon_crystal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)

                        Text("+\(offer.crystalReward)")
                            .foregroundStyle(.cyan)
                    }
                }
                .font(.headline)

                // Button
                Button {

                    if !exchange.buy(offer: offer) {
                        showFail = true
                    }

                } label: {

                    Text("Exchange")
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
                .disabled(remaining == 0)
                .opacity(remaining == 0 ? 0.4 : 1)
            }
            .padding(22)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
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
        .shadow(color: .cyan.opacity(0.35), radius: 14)
    }
}
