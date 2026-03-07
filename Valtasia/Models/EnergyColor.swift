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
    case molten
    case toxic
    case celestial
    case shadow
    case plasma

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

        case .molten:
            return UIColor(red: 1.0, green: 0.35, blue: 0.05, alpha: 1)  // Lava

        case .toxic:
            return UIColor(red: 0.55, green: 1.0, blue: 0.0, alpha: 1)  // Neon Green

        case .celestial:
            return UIColor(red: 0.6, green: 0.8, blue: 1.0, alpha: 1)  // Star Blue

        case .shadow:
            return UIColor(red: 0.15, green: 0.0, blue: 0.25, alpha: 1)  // Dark Purple

        case .plasma:
            return UIColor(red: 1.0, green: 0.0, blue: 0.8, alpha: 1)  // Neon Pink
        }
    }
}
