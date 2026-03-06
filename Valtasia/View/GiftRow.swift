//
//  GiftRow.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftRow: View {

    let giftId: String
    let title: String
    let value: Int
    let icon: String
    let iconColor: Color
    let colors: [Color]
    let action: () -> Void

    private var claimed: Bool {
        GiftClaimManager.shared.isClaimed(giftId)
    }

    var body: some View {
        HStack(spacing: 16) {

            iconView

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white)

                Text("\(value)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.white)
            }

            Spacer()

            claimButton
        }
        .padding()
        .background(cardBackground)
        .contentShape(Rectangle())
    }
}

extension GiftRow {

    fileprivate var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.88),
                        Color.blue.opacity(0.18),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
}

extension GiftRow {

    fileprivate var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            colors.first?.opacity(0.65) ?? .blue,
                            .black.opacity(0.6),
                        ],
                        center: .topLeading,
                        startRadius: 4,
                        endRadius: 40
                    )
                )
                .frame(width: 50, height: 50)

            Image(icon)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
}

extension GiftRow {

    fileprivate var claimButton: some View {

        let claimed = GiftClaimManager.shared.isClaimed(giftId)

        return Button {
            action()
            GiftClaimManager.shared.claim(giftId)
        } label: {
            Text(claimed ? "✓" : "GIFT")
                .font(.system(size: 10, weight: .bold))
                .padding()
                .background(
                    LinearGradient(
                        colors: claimed ? [.gray, .gray] : colors,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(claimed)
        .opacity(claimed ? 0.6 : 1)
    }
}

extension GiftRow {

    fileprivate var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(
                LinearGradient(
                    colors: [
                        colors.first?.opacity(0.6) ?? .blue,
                        .clear,
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 1
            )
    }
}

#Preview {
    GiftView()
}
