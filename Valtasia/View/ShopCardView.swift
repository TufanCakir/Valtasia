//
//  ShopRowView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopCardView: View {

    @State private var isPressed = false

    let storeProduct: StoreProduct
    let onBuy: () -> Void

    var body: some View {

        ZStack(alignment: .topTrailing) {

            VStack(spacing: 20) {

                iconView

                titleView

                buyButton
            }
            .padding()
            .background(cardBackground)
            .shadow(color: iconColor.opacity(0.25), radius: 10, y: 6)
            badgeView
        }
    }
}

extension ShopCardView {

    fileprivate var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                iconColor.opacity(0.7),
                                .purple.opacity(0.45),
                                .clear,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
    }
}

extension ShopCardView {

    // MARK: BADGE
    fileprivate var badgeView: some View {
        Group {
            if let tag = storeProduct.shopItem.tag {
                Text(badgeTitle(for: tag))
                    .font(.system(size: 10, weight: .black))
                    .tracking(0.5)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(badgeColor(for: tag))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
            }
        }
    }

    fileprivate func badgeTitle(for tag: String) -> String {
        switch tag {
        case "best_value": return "BESTER WERT"
        case "sale": return "ANGEBOT"
        case "popular": return "BELIEBT"
        case "new": return "NEU"
        default: return tag.uppercased()
        }
    }

    fileprivate func badgeColor(for tag: String) -> LinearGradient {
        switch tag {
        case "best_value":
            return LinearGradient(
                colors: [.yellow, .orange],
                startPoint: .leading,
                endPoint: .trailing
            )
        case "sale":
            return LinearGradient(
                colors: [.red, .pink],
                startPoint: .leading,
                endPoint: .trailing
            )
        case "popular":
            return LinearGradient(
                colors: [.blue, .cyan],
                startPoint: .leading,
                endPoint: .trailing
            )
        default:
            return LinearGradient(
                colors: [.gray, .black],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    // MARK: ICON
    fileprivate var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            iconColor.opacity(0.45),
                            .black.opacity(0.5),
                        ],
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 60
                    )
                )

            Circle()
                .stroke(iconColor.opacity(0.7), lineWidth: 1.5)

            iconImage
        }
        .padding()
    }

    @ViewBuilder
    fileprivate var iconImage: some View {

        if iconName == "diamond.fill" {

            Image("icon_crystal")
                .resizable()
                .scaledToFit()
                .foregroundStyle(iconColor)
        } else {

            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(iconColor)
        }
    }

    fileprivate var iconName: String {
        storeProduct.shopItem.category.icon
    }

    fileprivate var iconColor: Color {
        storeProduct.shopItem.category.uiColor
    }

    // MARK: TITLE
    fileprivate var titleView: some View {
        Group {
            if let crystals = storeProduct.shopItem.crystals {
                Text("\(crystals) Kristalle")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: BUY BUTTON
    fileprivate var buyButton: some View {
        Button(action: onBuy) {
            Text(buttonTitle)
                .font(.system(size: 13, weight: .heavy))
                .padding()
                .background(
                    LinearGradient(
                        colors: [.purple, iconColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
                .shadow(color: iconColor.opacity(0.4), radius: 6, y: 3)
                .buttonStyle(.plain)
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
                .scaleEffect(isPressed ? 0.97 : 1)
                .animation(.easeOut(duration: 0.12), value: isPressed)
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

#Preview {
    ShopView()
}
