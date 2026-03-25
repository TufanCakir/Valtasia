//
//  CharacterRarity.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

enum CharacterRarity: String, Codable {

    case common
    case rare
    case epic
    case legendary
    case corrupted
}

extension CharacterRarity {

    // 🎨 UI
    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .yellow
        case .corrupted: return .green
        }
    }

    // 📈 Scaling (late game balance verbessert)
    var growthRate: Double {
        switch self {
        case .common: return 1.05  // sehr schwach scaling
        case .rare: return 1.065
        case .epic: return 1.085
        case .legendary: return 1.11  // leicht stärker gemacht
        case .corrupted: return 1.18  // 🔥 Endgame tier
        }
    }

    // 🎯 GLOBAL DROP RATE
    var summonRate: Double {
        switch self {
        case .common: return 0.65  // 65%
        case .rare: return 0.25  // 25%
        case .epic: return 0.08  // 8%
        case .legendary: return 0.015  // 1.5%
        case .corrupted: return 0.005  // 0.5%
        }
    }
}
