//
//  ShopItem.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

struct ShopItem: Codable, Identifiable {

    let id: String
    let storeProductId: String?
    let category: ShopCategory

    let gems: Int?
    let corruptedGems: Int?  // 👈 NEU

    let oneTimePurchase: Bool?
    let tag: String?
}
