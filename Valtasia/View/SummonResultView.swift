//
//  SummonResultView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct SummonResultView: View {

    let character: Character
    @Environment(\.dismiss) private var dismiss

    var body: some View {

        VStack(spacing: 0) {

            // MARK: HEADER STYLE (wie SummonView)

            HStack {

                VStack(alignment: .leading, spacing: 4) {

                    Text("Summon Result")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)

                    Text("Ein neuer Kämpfer ist erschienen")
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

            Spacer()

            // MARK: RESULT CARD

            VStack(spacing: 22) {

                Text("YOU SUMMONED")
                    .font(.caption.bold())
                    .tracking(2)
                    .foregroundStyle(.white.opacity(0.8))

                ZStack {

                    RoundedRectangle(cornerRadius: 24)
                        .fill(.ultraThinMaterial)

                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.7),
                                    .purple.opacity(0.6),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )

                    VStack(spacing: 18) {

                        // Glow Background

                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        rarityColor.opacity(0.5),
                                        .clear,
                                    ],
                                    center: .center,
                                    startRadius: 10,
                                    endRadius: 160
                                )
                            )
                            .frame(width: 220, height: 220)
                            .overlay {

                                Image(character.sprite)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .shadow(
                                        color: rarityColor.opacity(0.7),
                                        radius: 20
                                    )
                            }

                        Text(character.name)
                            .font(.title.bold())
                            .foregroundStyle(.white)

                        Text(character.rarity.rawValue.uppercased())
                            .font(.caption.bold())
                            .padding(.horizontal, 18)
                            .padding(.vertical, 8)
                            .background(
                                rarityColor.opacity(0.2)
                            )
                            .foregroundStyle(rarityColor)
                            .clipShape(Capsule())
                            .overlay {

                                Capsule()
                                    .stroke(rarityColor, lineWidth: 1.5)
                            }
                    }
                    .padding(24)
                }
                .shadow(
                    color: .cyan.opacity(0.35),
                    radius: 14
                )

                Button {

                    dismiss()

                } label: {

                    Text("Continue")
                        .font(.caption.bold())
                        .padding(.horizontal, 22)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: [
                                    .purple,
                                    .blue,
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }

        // MARK: BACKGROUND = EXACT SAME STYLE

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

    var rarityColor: Color {

        switch character.rarity {

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
