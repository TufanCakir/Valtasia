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

        HStack(spacing: 16) {

            iconView

            VStack(alignment: .leading, spacing: 6) {

                titleView

                subtitleView
            }

            Spacer()

            buyButton
        }
        .padding(14)
        .background(

            RoundedRectangle(cornerRadius: 18)
                .fill(.ultraThinMaterial)
                .overlay(

                    RoundedRectangle(cornerRadius: 18)
                        .stroke(.white.opacity(0.15))
                )
        )
        .padding(.horizontal)
    }
}

extension ShopRowView {

    // MARK: ICON

    fileprivate var iconView: some View {

        ZStack {

            Circle()
                .fill(iconColor.opacity(0.2))

            Image(systemName: iconName)
                .font(.title2)
                .foregroundStyle(iconColor)

        }
        .frame(width: 60, height: 60)
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

            if let gems =
                storeProduct.shopItem.gems
            {

                Text("\(gems) Crystals")
                    .font(.headline)

            }

            else if let coins =
                storeProduct.shopItem.coins
            {

                Text("\(coins) Coins")
                    .font(.headline)
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
                    .foregroundStyle(.secondary)

            } else {

                Text("Pay with Crystals")
                    .foregroundStyle(.secondary)
            }
        }
        .font(.caption)
    }

    // MARK: BUY BUTTON

    fileprivate var buyButton: some View {

        Button {

            onBuy()

        } label: {

            Text(buttonTitle)
                .fontWeight(.bold)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
        }
        .buttonStyle(.borderedProminent)
        .tint(iconColor)
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
