//
//  Crack.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

struct Crack: Codable {

    let id: String

    let rarity: CrackRarity

    let damageMultiplier: Double
    let energySpeed: Double

    let spawnWeight: Int
    let tapRewardEnergy: Int

    let shape: CrackShape

    let energyColor: EnergyColor
    let energyShader: EnergyShader
}
