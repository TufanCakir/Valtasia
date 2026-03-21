//
//  SummonPoolView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct SummonPoolView: View {
    
    @EnvironmentObject var appModel: AppModel

    let banner: SummonBanner
    let rates: [CharacterRate]

    @Environment(\.dismiss) private var dismiss
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        VStack(spacing: 0) {

            headerCard

            TabView {
                ForEach(rates) { entry in
                    PoolPage(entry: entry, theme: theme)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 40)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))
        }
        .background(BackgroundStyle.main(theme))
        .ignoresSafeArea()
    }
}

extension SummonPoolView {

    fileprivate var headerCard: some View {
        ZStack {
            BackgroundStyle.headerFade(theme)

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
                        .foregroundStyle(.white)
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
        .overlay(GlowStyle.cardStroke(theme))
        .shadow(color: .cyan.opacity(0.35), radius: 14)
        .padding()
    }
}

struct PoolPage: View {

    let entry: CharacterRate
    let theme: UITheme

    var body: some View {

        let character = entry.character

        VStack {

            Spacer()

            ZStack {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.ultraThinMaterial)
                    .overlay(GlowStyle.cardStroke(theme))

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
                        RateUpBadge(theme: theme)
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
    let theme: UITheme
    
    var body: some View {
        Text("RATE UP")
            .font(.caption.bold())
            .foregroundStyle(.black)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .yellow.opacity(0.6), radius: 8)
    }
}

enum BackgroundStyle {
    static func main(_ theme: UITheme) -> LinearGradient {
        LinearGradient(
            colors: theme.headerGradient,
            startPoint: .leading,
            endPoint: .trailing
        )
    }

    static func headerFade(_ theme: UITheme) -> LinearGradient {
        LinearGradient(
            colors: theme.headerGradient,
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

enum GlowStyle {
    static func cardStroke(_ theme: UITheme) -> some View {
        RoundedRectangle(cornerRadius: 28)
            .stroke(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 3
            )
    }
}

extension CharacterRate {
    var ratePercent: String {
        String(format: "%.2f%%", rate * 100)
    }
}
