//
//  ShopManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit

class ShopManager {

    func loadShopProducts(
        shopItems: [ShopItem]
    ) async throws -> [StoreProduct] {

        print("🛒 --- SHOP LOAD START ---")
        print("📦 ShopItems gesamt:", shopItems.count)

        var storeProducts: [StoreProduct] = []

        // ⭐ 1. Bereits gekaufte One-Time Items entfernen
        let availableItems = shopItems.filter {
            if $0.oneTimePurchase == true {
                let bought = UserDefaults.standard.bool(
                    forKey: "shop_bought_\($0.id)"
                )
                print("🔹 OneTime:", $0.id, "gekauft:", bought)
                return !bought
            }
            return true
        }

        print("✅ Verfügbare Items:", availableItems.count)

        // ⭐ 2. Echtgeld Items
        let realMoneyItems = availableItems.filter {
            $0.category.id == "real_money"
        }

        print("💰 Echtgeld Items:", realMoneyItems.count)

        let ids = realMoneyItems.compactMap { $0.storeProductId }

        print("🆔 Angefragte Produkt-IDs:")
        ids.forEach { print("   •", $0) }

        let products =
            try await StoreKitService
            .shared
            .fetchProducts(ids: ids)

        print("📥 Von StoreKit geladene Produkte:")
        products.forEach { print("   •", $0.id) }

        // ⭐ 3. Echtgeld Produkte verbinden
        for product in products {

            if let item = realMoneyItems.first(where: {
                $0.storeProductId == product.id
            }) {

                print(
                    "🔗 Verbinde Produkt:",
                    product.id,
                    "→ ShopItem:",
                    item.id
                )

                storeProducts.append(
                    StoreProduct(
                        product: product,
                        shopItem: item
                    )
                )
            } else {
                print("⚠️ Kein ShopItem gefunden für Produkt:", product.id)
            }
        }

        // ⭐ 4. Soft / Free Items (kein StoreKit nötig)
        let softItems = availableItems.filter {
            $0.category.id != "real_money"
        }

        print("🎁 Soft Items:", softItems.count)

        for item in softItems {
            print("   •", item.id)
        }

        storeProducts += softItems.map {
            StoreProduct(
                product: nil,
                shopItem: $0
            )
        }

        let sorted = storeProducts.sorted {
            ($0.shopItem.crystals ?? 0) < ($1.shopItem.crystals ?? 0)
        }

        print("📊 Finale Shop-Reihenfolge:")
        for p in sorted {
            let crystals = p.shopItem.crystals ?? 0
            print("   •", p.shopItem.id, "-", crystals, "💎")
        }

        print("🛒 --- SHOP LOAD END ---")

        return sorted
    }
}
