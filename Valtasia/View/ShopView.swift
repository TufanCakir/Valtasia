//
//  ShopView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI
import StoreKit

struct ShopView: View {

    @State private var storeProducts: [StoreProduct] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {

        NavigationStack {

            Group {

                if isLoading {
                    ProgressView("Loading Shop...")
                }

                else if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                else {
                    List(storeProducts, id: \.product.id) { item in
                        ShopRowView(storeProduct: item) {
                            Task {
                                await purchase(item)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Shop")
        }
        .task {
            await loadShop()
        }
    }

    // MARK: - Load Products

    private func loadShop() async {

        do {

            // 1️⃣ JSON laden (später durch echten Loader ersetzen)
            let shopItems: [ShopItem] = [
                ShopItem(id: "gem_small",
                         storeProductId: "com.valtasia.gems.small",
                         gems: 500),

                ShopItem(id: "gem_medium",
                         storeProductId: "com.valtasia.gems.medium",
                         gems: 1200)
            ]

            // 2️⃣ Apple Produkte laden
            let manager = ShopManager()
            let products = try await manager.loadShopProducts(shopItems: shopItems)

            storeProducts = products
            isLoading = false

        } catch {
            errorMessage = "Failed to load shop."
            isLoading = false
        }
    }

    // MARK: - Purchase

    private func purchase(_ storeProduct: StoreProduct) async {

        do {
            let result = try await storeProduct.product.purchase()

            switch result {

            case .success(let verification):

                switch verification {

                case .verified(_):
                    print("Purchase successful")
                    // Gems gutschreiben hier

                case .unverified(_, _):
                    print("Purchase unverified")
                }

            case .pending:
                print("Purchase pending")

            case .userCancelled:
                print("User cancelled")

            @unknown default:
                break
            }

        } catch {
            print("Purchase failed")
        }
    }
}
