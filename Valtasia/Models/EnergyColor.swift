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
    case chaosBlack
    case rainbow

    var skColor: SKColor {

        switch self {

        case .arcaneBlue: return .blue
        case .gold: return .yellow
        case .crimson: return .red
        case .violet: return .purple
        case .emerald: return .green
        case .ice: return .cyan
        case .chaosBlack: return .black
        case .rainbow: return .white
        }
    }

    var glow: CGFloat {

        switch self {

        case .chaosBlack: return 10
        case .rainbow: return 12
        default: return 6
        }
    }
}
