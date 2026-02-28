//
//  Crack.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import CoreGraphics

struct Crack: Codable {

    let id: String
    let rarity: CrackRarity
    let damageMultiplier: Double

    let energy: EnergyData
    let spawn: SpawnData
    let visual: VisualData

    let shape: CrackShape
    let energyColor: EnergyColor
    let energyShader: EnergyShader
}

struct EnergyData: Codable {
    let speed: Double
    let tapReward: Int
    let critChance: Double
}

struct SpawnData: Codable {
    let weight: Int
}

struct VisualData: Codable {
    let gradientSpeed: Double
    let glow: CGFloat
    let particleChance: Double
}
