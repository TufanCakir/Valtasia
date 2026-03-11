//
//  ShopRowView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopCardView: View {

    @StateObject private var storeKit = StoreKitService.shared
    @State private var isPressed = false

    let storeProduct: StoreProduct
    let onBuy: () -> Void

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
        .overlay(glowStroke)
    }
}

extension ShopCardView {

    fileprivate var glowStroke: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(
                LinearGradient(
                    colors: [.cyan.opacity(0.7), .purple.opacity(0.6)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ),
                lineWidth: 3
            )
    }
}

extension ShopCardView {

    fileprivate var iconView: some View {
        ZStack {
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            iconColor.opacity(0.35),
                            .black.opacity(0.7),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            iconImage
        }
    }
}

extension ShopCardView {

    fileprivate var titleView: some View {
        Group {
            if let gems = storeProduct.shopItem.gems {
                Text("\(gems) Gems")
                    .font(.headline.bold())
                    .foregroundStyle(.white)
            }
        }
    }
}

extension ShopCardView {

    fileprivate var buyButton: some View {
        Button(action: onBuy) {
            HStack(spacing: 8) {

                Text(buttonTitle)
                    .bold()
            }
            .font(.subheadline.bold())
            .foregroundStyle(.white)
            .padding()
            .background(
                LinearGradient(
                    colors: storeProduct.shopItem.oneTimePurchase == true
                        ? [.green, .mint]
                        : [.cyan, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(Capsule())
            .shadow(color: .cyan.opacity(0.35), radius: 6)
            .scaleEffect(isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

extension ShopCardView {

    fileprivate var badgeView: some View {
        Group {
            if let tag = storeProduct.shopItem.tag {
                Text(badgeTitle(for: tag))
                    .font(.caption2.bold())
                    .padding()
                    .background(badgeColor(for: tag))
                    .foregroundStyle(.white)
                    .clipShape(Capsule())
                    .shadow(color: .black.opacity(0.25), radius: 4, y: 2)
            }
        }
    }
}

extension ShopCardView {

    fileprivate var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .background(
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.9),
                        iconColor.opacity(0.15),
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [
                                iconColor.opacity(0.6),
                                .purple.opacity(0.4),
                                .clear,
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(
                color: iconColor.opacity(isPressed ? 0.6 : 0.25),
                radius: isPressed ? 18 : 10
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

    @ViewBuilder
    fileprivate var iconImage: some View {

        if iconName == "diamond.fill" {

            Image("icon_gem")
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
