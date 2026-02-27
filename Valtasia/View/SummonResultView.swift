//
//  SummonResultView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonResultView: View {

    let character: Character

    var body: some View {

        VStack(spacing: 20) {

            Text("You summoned!")
                .font(.largeTitle)

            Image(character.sprite)
                .resizable()
                .scaledToFit()
                .frame(height: 220)

            Text(character.name)
                .font(.title)

            Text(character.rarity.rawValue.uppercased())
                .font(.headline)
                .foregroundStyle(colorForRarity(character.rarity))

            Spacer()
        }
        .padding()
    }
}

func colorForRarity(_ rarity: Rarity) -> Color {
    switch rarity {
    case .common: return .gray
    case .rare: return .blue
    case .epic: return .purple
    case .legendary: return .yellow
    }
}
