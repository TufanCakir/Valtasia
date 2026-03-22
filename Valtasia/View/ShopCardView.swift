//
//  ShopRowView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopCardView: View {

    @EnvironmentObject var appModel: AppModel

    @State private var isPressed = false

    let storeProduct: StoreProduct
    let onBuy: () -> Void

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            cardBackground

            VStack(spacing: 12) {
                badgeView

                iconView

                titleView

                buyButton
            }
            .padding()
        }
    }
}

extension ShopCardView {

    fileprivate var iconView: some View {
        ZStack {
            Circle()
                .fill(Color.black.opacity(0.25))

            iconImage
                .padding(10)
        }
        .frame(width: 60, height: 60)
    }
}

extension ShopCardView {

    fileprivate var titleView: some View {
        VStack(spacing: 2) {
            if let gems = storeProduct.shopItem.gems {
                Text("\(gems) Gems")
            }

            if let cGems = storeProduct.shopItem.corruptedGems {
                Text("\(cGems) Corrupted")
            }
        }
        .font(.subheadline.bold())
        .foregroundStyle(.white)
    }
}

extension ShopCardView {

    fileprivate var buyButton: some View {
        Button(action: onBuy) {
            Text(buttonTitle)
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}

extension ShopCardView {

    @ViewBuilder
    fileprivate var badgeView: some View {
        if let tag = storeProduct.shopItem.tag {
            Text(badgeTitle(for: tag))
                .font(.caption2.bold())
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule().fill(Color.black.opacity(0.4))
                )
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: theme.borderGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
                .foregroundStyle(.white)
        }
    }
}

extension ShopCardView {

    fileprivate var cardBackground: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.3))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }
}

extension ShopCardView {

    fileprivate func badgeTitle(for tag: String) -> String {
        switch tag {
        case "best_value": return "BESTER WERT"
        case "sale": return "ANGEBOT"
        case "popular": return "BELIEBT"
        case "new": return "NEU"
        default: return tag.uppercased()
        }
    }

    @ViewBuilder
    fileprivate var iconImage: some View {
        Group {
            if storeProduct.shopItem.corruptedGems != nil {
                Image("c_gem")
                    .resizable()
                    .scaledToFit()
            } else if storeProduct.shopItem.gems != nil {
                Image("icon_gem")
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: iconName)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(iconColor)
            }
        }
    }

    fileprivate var iconName: String {
        storeProduct.shopItem.category.icon
    }

    fileprivate var iconColor: Color {
        storeProduct.shopItem.category.uiColor
    }

    fileprivate var buttonTitle: String {
        // ⭐ Starter Pack = Kostenlos
        if storeProduct.shopItem.oneTimePurchase == true {
            return "FREE"
        }

        guard let p = storeProduct.product else { return "…" }
        return p.displayPrice
    }
}

#Preview {
    ShopView()
}
