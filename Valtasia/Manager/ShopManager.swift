//
//  ShopManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit

class ShopManager {

    func buildStoreProducts(
        shopItems: [ShopItem]
    ) -> [StoreProduct] {

        var storeProducts: [StoreProduct] = []

        let availableItems = shopItems.filter {
            if $0.oneTimePurchase == true {
                !UserDefaults.standard.bool(
                    forKey: "shop_bought_\($0.id)"
                )
            } else {
                true
            }
        }

        for item in availableItems {

            if let id = item.storeProductId,
                let product = StoreKitService.shared.product(for: id)
            {

                storeProducts.append(
                    StoreProduct(product: product, shopItem: item)
                )

            } else {
                storeProducts.append(
                    StoreProduct(product: nil, shopItem: item)
                )
            }
        }

        return storeProducts.sorted {
            ($0.shopItem.gems ?? 0) < ($1.shopItem.gems ?? 0)
        }
    }
}
