//
//  CharacterDetailView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct CharacterDetailView: View {

    let owned: OwnedCharacter

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER

            VStack(spacing: 16) {

                ZStack {

                    Circle()
                        .fill(

                            RadialGradient(
                                colors: [
                                    owned.base.rarity.color.opacity(0.5),
                                    .clear,
                                ],
                                center: .center,
                                startRadius: 10,
                                endRadius: 140
                            )
                        )
                        .frame(width: 200, height: 200)

                    Image(owned.base.sprite)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 170)
                        .shadow(
                            color: owned.base.rarity.color.opacity(0.7),
                            radius: 18
                        )
                }

                Text(owned.base.name)
                    .font(.title.bold())
                    .foregroundStyle(.white)

                Text("Lv \(owned.level)")
                    .font(.caption.bold())
                    .padding(.horizontal, 14)
                    .padding(.vertical, 6)
                    .background(.white.opacity(0.15))
                    .clipShape(Capsule())

                ProgressView(
                    value: Double(owned.exp),
                    total: Double(owned.requiredEXP)
                )
                .tint(owned.base.rarity.color)
                .padding(.horizontal, 40)

            }
            .padding(.top, 24)
            .padding(.bottom, 14)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: STATS

            VStack(alignment: .leading, spacing: 18) {

                Text("Stats")
                    .font(.headline.bold())
                    .foregroundStyle(.white.opacity(0.9))

                statRow("HP", owned.base.stats.hp)

                statRow("Attack", owned.base.stats.attack)

                statRow(
                    "Energy",
                    owned.base.stats.energyPower
                )

                statRow(
                    "Speed",
                    owned.base.stats.attackSpeed
                )

            }
            .padding(22)

            Spacer()
        }

        .background(

            LinearGradient(
                colors: [
                    .black,
                    .blue.opacity(0.25),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }

    // MARK: STAT ROW

    func statRow(_ name: String, _ value: some CustomStringConvertible)
        -> some View
    {

        HStack {

            Text(name)
                .foregroundStyle(.white.opacity(0.8))

            Spacer()

            Text(verbatim: String(describing: value))
                .bold()
                .foregroundStyle(.white)
        }
        .padding(14)
        .background(

            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(

                    RoundedRectangle(cornerRadius: 16)
                        .stroke(

                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.6),
                                    .purple.opacity(0.5),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1.2
                        )
                )
        )
    }
}

extension Rarity {

    var color: Color {

        switch self {

        case .common:
            return .gray

        case .rare:
            return .blue

        case .epic:
            return .purple

        case .legendary:
            return .yellow
        }
    }
}
