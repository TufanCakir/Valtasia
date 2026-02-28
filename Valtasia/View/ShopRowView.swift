//
//  ShopRowView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopRowView: View {

    let storeProduct: StoreProduct
    let onBuy: () -> Void

    var body: some View {

        HStack(spacing: 18) {

            iconView

            VStack(alignment: .leading, spacing: 8) {

                titleView

                subtitleView
            }

            Spacer()

            buyButton
        }
        .padding(18)
        .background(

            RoundedRectangle(cornerRadius: 22)
                .fill(.ultraThinMaterial)

                .overlay(

                    RoundedRectangle(cornerRadius: 22)
                        .stroke(

                            LinearGradient(
                                colors: [
                                    iconColor.opacity(0.6),
                                    .purple.opacity(0.5),
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                )
        )
        .shadow(
            color: iconColor.opacity(0.25),
            radius: 10
        )
    }
}

extension ShopRowView {

    // MARK: ICON

    fileprivate var iconView: some View {

        ZStack {

            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            iconColor.opacity(0.35),
                            .black.opacity(0.4),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(
                    iconColor.opacity(0.6),
                    lineWidth: 1.5
                )

            Image(systemName: iconName)
                .font(.title2.bold())
                .foregroundStyle(iconColor)

        }
        .frame(width: 64, height: 64)
    }

    fileprivate var iconName: String {
        storeProduct.shopItem.category.iconName
    }

    fileprivate var iconColor: Color {
        storeProduct.shopItem.category.color
    }

    // MARK: TITLE

    fileprivate var titleView: some View {

        Group {
            if let gems = storeProduct.shopItem.gems {
                Text("\(gems) Crystals")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            } else if let coins = storeProduct.shopItem.coins {
                Text("\(coins) Coins")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: SUBTITLE

    fileprivate var subtitleView: some View {

        Group {

            if let product =
                storeProduct.product
            {

                Text(product.displayPrice)

            } else {

                Text("Pay with Crystals")
            }
        }
        .font(.caption)
        .foregroundStyle(.white.opacity(0.7))
    }

    // MARK: BUY BUTTON
    fileprivate var buyButton: some View {

        Button {

            onBuy()

        } label: {

            Text(buttonTitle)
                .font(.caption.bold())
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background(

                    LinearGradient(
                        colors: [
                            .purple,
                            iconColor,
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
    }

    fileprivate var buttonTitle: String {

        if let product =
            storeProduct.product
        {

            return product.displayPrice
        }

        return "Buy"
    }
}
