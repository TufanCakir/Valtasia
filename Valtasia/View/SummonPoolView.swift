//
//  SummonPoolView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct SummonPoolView: View {

    let banner: SummonBanner
    let rates: [CharacterRate]

    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER CARD (wie Banner)

            ZStack {

                LinearGradient(
                    colors: [.clear, .black.opacity(0.9)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                HStack(spacing: 16) {

                    Image(banner.bannerImage)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)

                    VStack(alignment: .leading, spacing: 8) {

                        Text(banner.title)
                            .font(.title.bold())
                            .foregroundStyle(.white)

                        Text("Pool: \(banner.pool.count) Characters")
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
                            .padding(8)
                            .background(.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }
                .padding(18)
            }
            .frame(height: 160)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [.cyan.opacity(0.7), .purple.opacity(0.6)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(color: .cyan.opacity(0.35), radius: 14)
            .padding(.horizontal)
            .padding(.top)

            // MARK: LIST

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(rates) { entry in
                        PoolRow(entry: entry)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [Color.black, Color.blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct PoolRow: View {

    let entry: CharacterRate

    var body: some View {

        let character = entry.character

        HStack(spacing: 18) {

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
            .frame(width: 72, height: 72)

            // MARK: Info

            VStack(alignment: .leading, spacing: 6) {

                Text(character.name)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(character.rarity.rawValue.capitalized)
                    .font(.caption.bold())
                    .foregroundStyle(character.rarity.color)

                Text(String(format: "Drop Rate: %.2f%%", entry.rate * 100))
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            // MARK: RATE UP

            if entry.isRateUp {
                Text("RATE UP")
                    .font(.caption2.bold())
                    .foregroundStyle(.black)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        LinearGradient(
                            colors: [.yellow, .orange],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
                    .shadow(color: .yellow.opacity(0.6), radius: 6)
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
                                    .cyan.opacity(0.6), .purple.opacity(0.5),
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
