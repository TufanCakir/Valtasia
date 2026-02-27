//
//  SKColor+Enemy.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI
import SpriteKit

func colorFromString(_ name: String) -> SKColor {

    switch name {

    case "blue": return .blue
    case "red": return .red
    case "green": return .green
    case "yellow": return .yellow
    case "purple": return .purple

    default: return .gray
    }
}
