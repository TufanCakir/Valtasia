//
//  GiftView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftView: View {

    @ObservedObject private var claimManager = GiftClaimManager.shared

    private let gifts = GiftLoader.load()

    private var availableGifts: [Gift] {
        gifts.filter { !GiftClaimManager.shared.isClaimed($0.id) }
    }

    var body: some View {
        VStack {
            GameHeaderView()
                .padding()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(availableGifts) { gift in
                        GiftRow(
                            giftId: gift.id,
                            title: gift.title,
                            value: gift.amount,
                            icon: gift.icon,
                            iconColor: .from(gift.iconColor),
                            colors: gift.colors.map { .from($0) }
                        ) {
                            claim(gift)
                        }
                    }
                }
                .padding()
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension GiftView {

    private func claim(_ gift: Gift) {
        switch gift.type {
        case .coins:
            CoinManager.shared.add(gift.amount)

        case .gems:
            GemManager.shared.add(gift.amount)

        case .exp:
            PlayerProgressManager.shared.addEXP(gift.amount)
        }
    }
}

#Preview {
    GiftView()
}
