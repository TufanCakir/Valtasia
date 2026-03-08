//
//  PitySystem.swift
//  Valtasia
//
//  Created by Tufan Cakir on 08.03.26.
//

struct PitySystem: Codable {
    let enabled: Bool
    let requiredPulls: Int
    let guaranteedPool: [PityEntry]
}

struct PityEntry: Codable {
    let characterId: String
}
