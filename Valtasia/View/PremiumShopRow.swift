//
//  PremiumShopRow.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import StoreKit
import SwiftUI

struct PremiumShopRow: View {

    let storeProduct: StoreProduct
    let onBuy: () -> Void

    var body: some View {

        ZStack {

            LinearGradient(
                colors: [
                    storeProduct.shopItem.category.color.opacity(0.3),
                    .blue.opacity(0.2),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            HStack(spacing: 18) {

                iconView

                VStack(alignment: .leading, spacing: 6) {

                    titleView

                    subtitleView
                }

                Spacer()

                buyButton
            }
            .padding()
        }
        .frame(height: 120)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
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
        )
        .shadow(
            color: .cyan.opacity(0.35),
            radius: 12
        )
    }
}

extension PremiumShopRow {

    var iconView: some View {

        ZStack {

            Circle()
                .fill(iconColor.opacity(0.2))

            Image(systemName: iconName)
                .font(.title)
                .foregroundStyle(iconColor)
        }
        .frame(width: 60, height: 60)
    }

    var iconName: String {
        storeProduct.shopItem.category.iconName
    }

    var iconColor: Color {
        storeProduct.shopItem.category.color
    }
}

extension PremiumShopRow {

    var titleView: some View {

        Group {

            if let gems = storeProduct.shopItem.gems {
                Text("\(gems) Crystals")
            } else if let coins = storeProduct.shopItem.coins {
                Text("\(coins) Coins")
            }
        }
        .font(.headline)
        .foregroundStyle(.white)
    }

    var subtitleView: some View {

        Group {

            if let product = storeProduct.product {
                Text(product.displayPrice)
            } else {
                Text("Pay with Crystals")
            }
        }
        .font(.caption)
        .foregroundStyle(.white.opacity(0.75))
    }
}

extension PremiumShopRow {

    var buyButton: some View {

        Button {

            onBuy()

        } label: {

            Text(buttonTitle)
                .font(.caption.bold())
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [.purple, .blue],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }

    var buttonTitle: String {

        if let product = storeProduct.product {
            return product.displayPrice
        }

        return "Buy"
    }
}
