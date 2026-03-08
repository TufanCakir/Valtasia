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

            // MARK: Banner Gradient Overlay (wie Summon)
            LinearGradient(
                colors: [.clear, .black.opacity(0.9)],
                startPoint: .center,
                endPoint: .bottom
            )

            VStack(spacing: 16) {
                badgeView

                iconView

                titleView

                buyButton

            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(glowStroke)
        .shadow(color: iconColor.opacity(0.35), radius: 14)
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
                lineWidth: 2
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
                            iconColor.opacity(0.45),
                            .black.opacity(0.6),
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Circle()
                .stroke(iconColor.opacity(0.7), lineWidth: 1.5)

            iconImage
        }
    }
}

extension ShopCardView {

    fileprivate var titleView: some View {
        Group {
            if let crystals = storeProduct.shopItem.crystals {
                Text("\(crystals) Kristalle")
                    .font(.title3.bold())
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
            .font(.title3.bold())
            .foregroundStyle(.white)
            .padding()
            .background(
                LinearGradient(
                    colors: [.cyan, .purple],
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
                        lineWidth: 1
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

    fileprivate var buttonTitle: String {
        guard let p = storeProduct.product else { return "…" }
        return p.price.formatted(p.priceFormatStyle)
    }
}

#Preview {
    ShopView()
}
