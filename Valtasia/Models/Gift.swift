//
//  Gift.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import SwiftUI

struct Gift: Codable, Identifiable {
    let id: String
    let title: String?
    let icon: String?
    let iconColor: String?
    let colors: [String]?

    let type: GiftType
    let amount: Int?
}

enum GiftType: String, Codable {
    case coins
    case gems
    case exp
    case corruptedCoins = "corrupted_coins"
    case corruptedGems = "corrupted_gems"
}

final class GiftLoader {

    static func load() -> [Gift] {
        guard let url = Bundle.main.url(forResource: "gifts", withExtension: "json") else {
            print("❌ gifts.json nicht im Bundle gefunden")
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let gifts = try JSONDecoder().decode([Gift].self, from: data)
            return gifts
        } catch {
            print("❌ gifts.json decode error:", error)
            return []
        }
    }
}

extension Color {
    static func from(_ name: String?) -> Color {
        guard let name else { return .white }

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
