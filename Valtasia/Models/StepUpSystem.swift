//
//  StepUpSystem.swift
//  Valtasia
//
//  Created by Tufan Cakir on 08.03.26.
//

struct StepUpSystem: Codable {
    let enabled: Bool
    let steps: [StepUpStep]
}

struct StepUpStep: Codable, Identifiable {
    var id: Int { step }

    let step: Int
    let costs: [SummonOption]?  // 👈 NEU
    let pool: [SummonPoolEntry]?
    let guaranteed: GuaranteedReward?
}

struct GuaranteedReward: Codable {
    let characterId: String
}
