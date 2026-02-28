//
//  SKColor+Enemy.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit
import SwiftUI

func colorFromString(_ name: String) -> SKColor {

    switch name {

    case "cyan": return .cyan
    case "yellow": return .yellow
    case "red": return .red
    case "orange": return .orange
    case "darkGray": return .darkGray
    case "black": return .black

    default: return .gray
    }
}
