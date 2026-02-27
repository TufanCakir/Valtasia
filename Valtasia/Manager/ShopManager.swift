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

        // Echtgeld Items
        let realMoneyItems = shopItems.filter {
            $0.category == .realMoney
        }

        let ids = realMoneyItems.compactMap {
            $0.storeProductId
        }

        let products =
            try await StoreKitService
            .shared
            .fetchProducts(ids: ids)

        // Echtgeld Produkte verbinden
        for product in products {

            if let item = realMoneyItems.first(
                where: { $0.storeProductId == product.id }
            ) {

                storeProducts.append(
                    StoreProduct(
                        product: product,
                        shopItem: item
                    )
                )
            }
        }

        // ⭐ Soft Currency Produkte (kein StoreKit nötig)
        let softItems = shopItems.filter {
            $0.category != .realMoney
        }

        storeProducts += softItems.map {

            StoreProduct(
                product: nil,
                shopItem: $0
            )
        }

        return storeProducts
    }
}
