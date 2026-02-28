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

        case "arcane": return .cyan
        case "shadow": return .purple
        case "ice": return .cyan
        case "crimson": return .red

        default:
            return .white
        }
    }
}
