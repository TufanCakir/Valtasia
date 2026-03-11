//
//  ExchangeOffer.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

struct ExchangeOffer: Codable, Identifiable {

    let id: String

    let title: String

    let coinCost: Int

    let gemReward: Int

    let purchaseLimit: Int
}
