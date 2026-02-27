//
//  ShopView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopView: View {

    @State private var storeProducts: [StoreProduct] = []
    @State private var isLoading = true
    @State private var errorMessage: String?
    @State private var selectedCategory: ShopCategory = .realMoney

    var body: some View {

        NavigationStack {

            VStack {

                ShopCategoryBar(selected: $selectedCategory)

                contentList
            }
            .navigationTitle("Shop")
        }
        .task {
            await loadShop()
        }
    }
}

extension ShopView {

    fileprivate func loadShop() async {

        do {

            let shopItems: [ShopItem] =
                try JSONLoader.load("shop")

            let manager = ShopManager()

            let products =
                try await manager.loadShopProducts(
                    shopItems: shopItems
                )

            storeProducts = products
            isLoading = false

        } catch {

            errorMessage = "Failed to load shop."
            isLoading = false
        }
    }
}

extension ShopView {

    fileprivate var contentList: some View {

        Group {

            if isLoading {
                ProgressView("Loading Shop...")
            }

            else if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }

            else {
                List(filteredProducts, id: \.shopItem.id) { item in

                    ShopRowView(storeProduct: item) {

                        Task {
                            await purchase(item)
                        }
                    }
                }
            }
        }
    }

    fileprivate var filteredProducts: [StoreProduct] {

        storeProducts.filter {
            $0.shopItem.category == selectedCategory
        }
    }
}

extension ShopView {

    private func purchase(_ storeProduct: StoreProduct) async {

        // ⭐ Soft Currency
        if storeProduct.product == nil {

            if let coins = storeProduct.shopItem.coins {

                let success = CrystalManager.shared.spend(50)

                if success {
                    CoinManager.shared.add(coins)
                }
            }

            return
        }

        // ⭐ Echtgeld
        guard let product = storeProduct.product else { return }

        do {

            let result = try await product.purchase()

            switch result {

            case .success(let verification):

                switch verification {

                case .verified(_):

                    if let gems = storeProduct.shopItem.gems {
                        CrystalManager.shared.add(gems)
                    }

                case .unverified(_, _):
                    print("Unverified")
                }

            case .pending:
                print("Pending")

            case .userCancelled:
                print("Cancelled")

            @unknown default:
                break
            }

        } catch {
            print("Purchase failed")
        }
    }
}
