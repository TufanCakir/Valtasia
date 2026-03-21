//
//  GiftView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftView: View {
    
    @EnvironmentObject var appModel: AppModel

    @ObservedObject private var claimManager = GiftClaimManager.shared

    private let gifts = GiftLoader.load()

    private var availableGifts: [Gift] {
        gifts.filter { !GiftClaimManager.shared.isClaimed($0.id) }
    }
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        VStack {
            
            GameHeaderView()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(availableGifts) { gift in
                        GiftRow(gift: gift) {
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
                colors: theme.headerGradient,
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
        
        guard let amount = gift.amount else { return }
        
        switch gift.type {
            
        case .coins:
            CoinManager.shared.add(amount)
            
        case .gems:
            GemManager.shared.add(amount)
            
        case .exp:
            PlayerProgressManager.shared.addEXP(amount)
            
        case .corruptedCoins:
            CorruptedCoinManager.shared.add(amount)
            
        case .corruptedGems:
            CorruptedGemManager.shared.add(amount)
        }
    }
}

#Preview {
    GiftView()
}
