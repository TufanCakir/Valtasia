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

}

extension CharacterRarity {

    var color: Color {
        switch self {
        case .common: return .gray
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }
}
