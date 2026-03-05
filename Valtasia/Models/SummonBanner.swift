//
//  SummonBanner.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

struct SummonBanner: Codable, Identifiable {

    let id: String
    let title: String
    let bannerImage: String

    let summons: [SummonOption]
    let poolLimit: Int

    let pool: [SummonPoolEntry]
}

struct SummonOption: Codable, Identifiable {
    var id: Int { amount }
    let amount: Int
    let cost: Int
}

struct SummonPoolEntry: Codable, Identifiable {

    var id: String { characterId }

    let characterId: String
    let rate: Double
    let rateUp: Bool
}
