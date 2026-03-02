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

    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [Color.black.opacity(0.9), Color.blue.opacity(0.25)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 16) {
                // MARK: Icon
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: icon)
                        .foregroundStyle(iconColor)
                        .font(.title3.bold())
                }

                // MARK: Text Area
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("Current: \(value)")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.6))
                }

                Spacer()

                // MARK: Button
                let claimed = GiftClaimManager.shared.isClaimed(giftId)

                Button {
                    action()
                    GiftClaimManager.shared.claim(giftId)
                } label: {
                    Text(claimed ? "CLAIMED" : "GIFT")
                        .font(.caption.bold())
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: claimed ? [.gray, .gray] : colors,
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .clipShape(Capsule())
                }
                .disabled(claimed)
                .opacity(claimed ? 0.6 : 1)
                .shadow(
                    color: colors.first?.opacity(0.5) ?? .blue,
                    radius: 8
                )
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(
                    LinearGradient(
                        colors: colors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
        .shadow(
            color: colors.first?.opacity(0.35) ?? .blue,
            radius: 14
        )
    }
}
