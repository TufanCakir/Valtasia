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
        var storeProducts: [StoreProduct] = []

        // ⭐ 1. Bereits gekaufte One-Time Items entfernen
        let availableItems = shopItems.filter {
            if $0.oneTimePurchase == true {
                let bought = UserDefaults.standard.bool(
                    forKey: "shop_bought_\($0.id)"
                )
                return !bought
            }
            return true
        }

        // ⭐ 2. Echtgeld Items
        let realMoneyItems = availableItems.filter {
            $0.category.id == "real_money"
        }

        let ids = realMoneyItems.compactMap { $0.storeProductId }

        let products =
            try await StoreKitService
            .shared
            .fetchProducts(ids: ids)

        // ⭐ 3. Echtgeld Produkte verbinden
        for product in products {
            if let item = realMoneyItems.first(where: {
                $0.storeProductId == product.id
            }) {
                storeProducts.append(
                    StoreProduct(
                        product: product,
                        shopItem: item
                    )
                )
            }
        }

        // ⭐ 4. Soft / Free Items (kein StoreKit nötig)
        let softItems = availableItems.filter { $0.category.id != "real_money" }
        storeProducts += softItems.map {
            StoreProduct(
                product: nil,
                shopItem: $0
            )
        }

        return storeProducts
    }
}
