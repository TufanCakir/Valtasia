//
//  SummonResultView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonResultView: View {

    let characters: [Character]

    @Environment(\.dismiss) private var dismiss

    let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 20)
    ]

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Summon Result")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("\(characters.count) Characters Summoned")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)

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
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
            }
            .padding(.bottom, 30)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.25),
                ],
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

        let color = character.rarity.color

        return VStack(spacing: 12) {

            ZStack {

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                color.opacity(0.5),
                                .clear,
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 120
                        )
                    )
                    .frame(width: 120, height: 120)

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
                .padding(.vertical, 5)
                .background(color.opacity(0.2))
                .foregroundStyle(color)
                .clipShape(Capsule())
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.6),
                                    .purple.opacity(0.5),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(color: .cyan.opacity(0.25), radius: 10)
    }
}
