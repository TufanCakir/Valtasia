//
//  GiftRow.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftRow: View {

    @EnvironmentObject var appModel: AppModel

    let gift: Gift
    let action: () -> Void

    private var claimed: Bool {
        GiftClaimManager.shared.isClaimed(gift.id)
    }

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        HStack(spacing: 16) {

            iconView

            VStack(alignment: .leading, spacing: 6) {

                Text(gift.title ?? "Reward")
                    .font(.subheadline.bold())
                    .foregroundStyle(.white)

                statView
            }

            Spacer()

            claimButton
        }
        .padding()
        .background(cardBackground)
        .overlay(cardBorder)
        .scaleEffect(claimed ? 0.97 : 1)
        .animation(.easeInOut(duration: 0.2), value: claimed)
    }
}

extension GiftRow {

    var statView: some View {
        HStack(spacing: 6) {

            Image(gift.icon ?? "icon_gem")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)

            Text("\(gift.amount ?? 0)")
                .font(.caption.bold())
                .foregroundStyle(.white.opacity(0.8))
        }
    }
}

extension GiftRow {

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                ),
            )
    }

    var cardBorder: some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(
                LinearGradient(
                    colors: theme.borderGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 1.5
            )
    }
}

extension GiftRow {

    var iconView: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.35))
                .frame(width: 50, height: 50)

            Image(gift.icon ?? "icon_gem")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

extension GiftRow {

    var claimButton: some View {

        Button {
            action()
            GiftClaimManager.shared.claim(gift.id)
            UIImpactFeedbackGenerator(style: .light).impactOccurred()  // 🔥 nicer feel
        } label: {

            Text(claimed ? "✓" : "CLAIM")
                .font(.caption.bold())
                .frame(minWidth: 80)
                .padding(.vertical, 8)
                .background(
                    Capsule()
                        .fill(
                            claimed
                                ? AnyShapeStyle(Color.green.opacity(0.7))
                                : AnyShapeStyle(
                                    LinearGradient(
                                        colors: theme.headerGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                )
                .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
        .disabled(claimed)
        .opacity(claimed ? 0.6 : 1)
    }
}

#Preview {
    GiftView()
}
