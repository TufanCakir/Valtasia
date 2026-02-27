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

        let ids =
        shopItems.map {
            $0.storeProductId
        }

        let products =
        try await StoreKitService
            .shared
            .fetchProducts(ids: ids)

        return products.compactMap {

            product in

            guard let item =
            shopItems.first(
             where: {
              $0.storeProductId ==
              product.id
             }
            )
            else { return nil }

            return StoreProduct(
                product: product,
                shopItem: item
            )
        }
    }
}
