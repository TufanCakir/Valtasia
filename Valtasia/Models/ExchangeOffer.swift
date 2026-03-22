//
//  ExchangeOffer.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

struct ExchangeOffer: Codable, Identifiable {

    let id: String
    let title: String

    // 🟡 NORMAL
    let coinCost: Int?
    let gemReward: Int?

    // 🟢 CORRUPTED
    let corruptedCoinCost: Int?
    let corruptedGemReward: Int?

    let purchaseLimit: Int
}
