//
//  Gift.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import SwiftUI

struct Gift: Codable, Identifiable {
    let id: String
    let title: String
    let icon: String
    let iconColor: String
    let colors: [String]
    let type: GiftType
    let amount: Int
}

enum GiftType: String, Codable {
    case coins
    case crystals
    case exp
}

final class GiftLoader {

    static func load() -> [Gift] {
        guard
            let url = Bundle.main.url(
                forResource: "gifts",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let gifts = try? JSONDecoder().decode([Gift].self, from: data)
        else {
            print("❌ gifts.json konnte nicht geladen werden")
            return []
        }

        return gifts
    }
}

extension Color {
    static func from(_ name: String) -> Color {
        switch name.lowercased() {
        case "yellow": return .yellow
        case "orange": return .orange
        case "cyan": return .cyan
        case "purple": return .purple
        case "blue": return .blue
        case "green": return .green
        case "red": return .red
        case "gray": return .gray
        default: return .white
        }
    }
}
