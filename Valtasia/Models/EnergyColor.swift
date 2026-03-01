//
//  EnergyColor.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

enum EnergyColor: String, Codable {
    case arcaneBlue
    case gold
    case crimson
    case violet
    case emerald
    case ice
    case rainbow
    case chaosBlack

    var skColor: UIColor {
        switch self {
        case .arcaneBlue: return .systemBlue
        case .gold: return .systemYellow
        case .crimson: return .systemRed
        case .violet: return .systemPurple
        case .emerald: return .systemGreen
        case .ice: return .cyan
        case .rainbow: return .white
        case .chaosBlack: return .black
        }
    }
}   
