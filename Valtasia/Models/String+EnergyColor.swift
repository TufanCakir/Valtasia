//
//  String+EnergyColor.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SpriteKit

extension String {

    var skColor: SKColor {

        switch self {

        // MARK: - Core
        case "arcaneBlue":
            return SKColor(red: 0.25, green: 0.65, blue: 1.0, alpha: 1)

        case "gold":
            return SKColor(red: 1.0, green: 0.8, blue: 0.2, alpha: 1)

        case "crimson":
            return SKColor(red: 0.85, green: 0.1, blue: 0.2, alpha: 1)

        case "violet":
            return SKColor(red: 0.6, green: 0.3, blue: 1.0, alpha: 1)

        case "emerald":
            return SKColor(red: 0.1, green: 0.85, blue: 0.45, alpha: 1)

        case "ice":
            return SKColor(red: 0.7, green: 0.95, blue: 1.0, alpha: 1)

        case "rainbow":
            return .white

        case "chaosBlack":
            return SKColor(white: 0.08, alpha: 1)

        // MARK: - New Crack Colors

        case "molten":  // Lava
            return SKColor(red: 1.0, green: 0.35, blue: 0.05, alpha: 1)

        case "toxic":  // Neon Acid
            return SKColor(red: 0.6, green: 1.0, blue: 0.0, alpha: 1)

        case "celestial":  // Star Light
            return SKColor(red: 0.65, green: 0.85, blue: 1.0, alpha: 1)

        case "shadow":  // Dark Purple
            return SKColor(red: 0.2, green: 0.0, blue: 0.3, alpha: 1)

        case "plasma":  // Neon Magenta
            return SKColor(red: 1.0, green: 0.0, blue: 0.8, alpha: 1)

        // MARK: - Fallback
        default:
            print("⚠️ Unknown EnergyColor:", self)
            return .white
        }
    }
}
