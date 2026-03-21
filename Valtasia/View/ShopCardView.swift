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

    @StateObject private var storeKit = StoreKitService.shared
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
        .overlay(glowStroke)
    }
}

extension ShopCardView {

    fileprivate var glowStroke: some View {
        RoundedRectangle(cornerRadius: 24)
            .stroke(
                LinearGradient(
                    colors: theme.headerGradient,
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
                        colors: theme.headerGradient,
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
            VStack {
                if let gems = storeProduct.shopItem.gems {
                    Text("\(gems) Gems")
                }
                
                if let cGems = storeProduct.shopItem.corruptedGems {
                    Text("\(cGems) Corrupted Gems")
                }
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
                    colors: theme.headerGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
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
                    colors: theme.headerGradient,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                                colors: theme.headerGradient,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
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
            return       LinearGradient(
                colors: theme.headerGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "sale":
            return       LinearGradient(
                colors: theme.headerGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case "popular":
            return       LinearGradient(
                colors: theme.headerGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        default:
            return       LinearGradient(
                colors: theme.headerGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    @ViewBuilder
    fileprivate var iconImage: some View {

        // 👇 NEU: Currency check
        if storeProduct.shopItem.corruptedGems != nil {

            Image("c_gem")   // 🔴 dein corrupted icon
                .resizable()
                .scaledToFit()

        } else if storeProduct.shopItem.gems != nil {

            Image("icon_gem")     // 🔵 normales icon
                .resizable()
                .scaledToFit()

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
