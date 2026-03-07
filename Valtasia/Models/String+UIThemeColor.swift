//
//  String+UIThemeColor.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

extension String {

    var themeColor: Color {
        switch self.lowercased() {

        case "purple": return .purple
        case "cyan": return .cyan
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "orange": return .orange
        case "yellow": return .yellow
        case "pink": return .pink
        case "teal": return .teal
        case "indigo": return .indigo
        case "mint": return .mint

        // Custom Theme Colors
        case "arcane": return Color(red: 0.25, green: 0.65, blue: 1.0)
        case "void": return Color(red: 0.4, green: 0.0, blue: 0.6)
        case "gold": return Color(red: 1.0, green: 0.8, blue: 0.2)

        default:
            print("⚠️ Unknown theme color:", self)
            return .white
        }
    }
}
