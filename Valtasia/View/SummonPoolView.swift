//
//  SummonPoolView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct SummonPoolView: View {

    let banner: SummonBanner
    let rates: [CharacterRate]  // ⭐ kommt jetzt vom Manager

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text(banner.title)
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Pool: \(rates.count) Characters")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 18)
            .padding(.bottom, 12)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL

            ScrollView {

                VStack(spacing: 22) {

                    ForEach(rates) { entry in
                        poolRow(entry)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
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
    }
}

func poolRow(
    _ entry: CharacterRate
) -> some View {

    let character = entry.character

    return HStack(spacing: 18) {

        // MARK: Avatar

        ZStack {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            character.rarity.color.opacity(0.35),
                            .black.opacity(0.4),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(
                    character.rarity.color.opacity(0.7),
                    lineWidth: 1.5
                )

            Image(character.sprite)
                .resizable()
                .scaledToFit()
                .padding(10)
        }
        .frame(width: 70, height: 70)

        // MARK: Info

        VStack(alignment: .leading, spacing: 6) {

            Text(character.name)
                .font(.headline)
                .foregroundStyle(.white)

            Text(character.rarity.rawValue.capitalized)
                .font(.caption.bold())
                .foregroundStyle(character.rarity.color)

            Text(
                String(
                    format: "Rate: %.2f%%",
                    entry.rate * 100
                )
            )
            .font(.caption2)
            .foregroundStyle(
                entry.isRateUp
                    ? .yellow
                    : .white.opacity(0.7)
            )
        }

        Spacer()

        // MARK: RATE UP BADGE

        if entry.isRateUp {

            Text("RATE UP")
                .font(.caption.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.yellow)
                .clipShape(Capsule())
        }
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
