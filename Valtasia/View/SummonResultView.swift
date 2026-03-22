//
//  SummonResultView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonResultView: View {

    @EnvironmentObject var appModel: AppModel

    let characters: [Character]

    @Environment(\.dismiss) private var dismiss

    let columns = [
        GridItem(.adaptive(minimum: 140), spacing: 16)
    ]

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER
            HStack {
                VStack(alignment: .leading, spacing: 4) {

                    Text("Summon Result")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("\(characters.count) Characters")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 16)
            .padding(.bottom, 10)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: RESULTS

            ScrollView {

                LazyVGrid(columns: columns, spacing: 24) {

                    ForEach(Array(characters.enumerated()), id: \.offset) {
                        _,
                        character in
                        summonCard(character)
                    }
                }
                .padding(24)
            }

            // MARK: CONTINUE BUTTON
            Button {
                dismiss()
            } label: {
                Text("Continue")
                    .font(.headline.bold())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .background(
            LinearGradient(
                colors: theme.headerGradient.map { $0.opacity(0.85) },
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationBarBackButtonHidden(true)
    }
}

extension SummonResultView {

    func summonCard(_ character: Character) -> some View {

        return VStack(spacing: 12) {

            ZStack {

                Circle()
                    .fill(Color.black.opacity(0.25))
                    .frame(width: 100, height: 100)

                Image(character.sprite)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
            }

            Text(character.name)
                .font(.headline)
                .foregroundStyle(.white)

            Text(character.rarity.rawValue.uppercased())
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.4))
                )
                .overlay(
                    Capsule()
                        .stroke(character.rarity.color, lineWidth: 1)
                )
                .foregroundStyle(character.rarity.color)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.black.opacity(0.35))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 3
                )
        )
    }
}
