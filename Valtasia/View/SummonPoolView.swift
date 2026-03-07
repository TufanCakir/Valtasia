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

            headerCard

            TabView {
                ForEach(rates) { entry in
                    PoolPage(entry: entry)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 40)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
        .background(BackgroundStyle.main)
        .ignoresSafeArea()
    }
}

extension SummonPoolView {

    fileprivate var headerCard: some View {
        ZStack {
            BackgroundStyle.headerFade

            HStack(spacing: 16) {

                Image(banner.bannerImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 120)

                VStack(alignment: .leading, spacing: 6) {
                    Text(banner.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("Pool: \(rates.count) Characters")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()

                Button(action: dismiss.callAsFunction) {
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
        .overlay(GlowStyle.cardStroke)
        .shadow(color: .cyan.opacity(0.35), radius: 14)
        .padding()
    }
}

struct PoolPage: View {

    let entry: CharacterRate

    var body: some View {

        let character = entry.character

        VStack {

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(GlowStyle.cardStroke)

                VStack(spacing: 22) {

                    portrait(character)

                    Text(character.name)
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text(character.rarity.rawValue.capitalized)
                        .font(.headline)
                        .foregroundStyle(character.rarity.color)

                    Text("Drop Rate \(entry.ratePercent)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.75))

                    if entry.isRateUp {
                        RateUpBadge()
                    }
                }
                .padding(30)
            }
            .shadow(color: .cyan.opacity(0.35), radius: 18)

            Spacer()
        }
    }

    private func portrait(_ character: Character) -> some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            character.rarity.color.opacity(0.4),
                            .black.opacity(0.5),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Image(character.sprite)
                .resizable()
                .scaledToFit()
                .padding(28)
        }
        .frame(width: 180, height: 180)
    }
}

struct RateUpBadge: View {
    var body: some View {
        Text("RATE UP")
            .font(.caption.bold())
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: [.yellow, .orange],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .yellow.opacity(0.6), radius: 8)
    }
}

enum BackgroundStyle {

    static let main =
        LinearGradient(
            colors: [Color.black, Color.blue.opacity(0.25)],
            startPoint: .top,
            endPoint: .bottom
        )

    static let headerFade =
        LinearGradient(
            colors: [.clear, .black.opacity(0.9)],
            startPoint: .center,
            endPoint: .bottom
        )
}

enum GlowStyle {

    static let cardStroke =
        RoundedRectangle(cornerRadius: 28)
        .stroke(
            LinearGradient(
                colors: [.cyan.opacity(0.7), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            lineWidth: 2
        )
}

extension CharacterRate {
    var ratePercent: String {
        String(format: "%.2f%%", rate * 100)
    }
}
