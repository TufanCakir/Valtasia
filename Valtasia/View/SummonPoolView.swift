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
        .background(
            LinearGradient(
                colors: theme.headerGradient.map { $0.opacity(0.8) },
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }
}

extension SummonPoolView {

    fileprivate var headerCard: some View {
        ZStack {

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
                    .fill(
                        LinearGradient(
                            colors: theme.headerGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )

                VStack(spacing: 22) {

                    portrait(character)

                    Text(character.name)
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    Text(character.rarity.rawValue.capitalized)
                        .font(.caption.bold())
                        .foregroundStyle(character.rarity.color)

                    Text("Drop Rate \(entry.ratePercent)")
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.7))

                    if entry.isRateUp {
                        RateUpBadge(theme: theme)
                    }
                }
                .padding(30)
            }
            Spacer()
        }
    }

    private func portrait(_ character: Character) -> some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.25))

            Image(character.sprite)
                .resizable()
                .scaledToFit()
        }
        .frame(width: 160, height: 160)
    }
}

struct RateUpBadge: View {
    let theme: UITheme

    var body: some View {
        Text("RATE UP")
            .font(.caption.bold())
            .foregroundStyle(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
    }
}

extension CharacterRate {
    var ratePercent: String {
        String(format: "%.2f%%", rate * 100)
    }
}
