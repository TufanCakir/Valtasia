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
    @State private var selectedCategory: String = "real_money"

    fileprivate var uniqueCategories: [ShopCategory] {
        Array(
            Dictionary(
                grouping: storeProducts.map { $0.shopItem.category },
                by: { $0.id }
            ).values.compactMap { $0.first }
        )
    }

    fileprivate var contentList: some View {
        Group {
            if isLoading {
                ProgressView("Loading Shop...")
                    .tint(.white)
                    .padding(.top, 60)

            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding(.top, 60)

            } else {
                LazyVGrid(
                    columns: gridColumns,
                    spacing: 16  // ⭐ mehr Abstand zwischen Cards
                ) {
                    ForEach(filteredProducts, id: \.id) { item in
                        ShopCardView(storeProduct: item) {
                            Task { await purchase(item) }
                        }
                    }
                }
            }
        }
    }

    private var gridColumns: [GridItem] {
        [
            GridItem(
                .adaptive(minimum: 120),  // ⭐ Cards minimal breiter
                spacing: 16  // ⭐ Abstand Spalten
            )
        ]
    }

    fileprivate var filteredProducts: [StoreProduct] {
        storeProducts.filter {
            $0.shopItem.category.id == selectedCategory
        }
    }

    var body: some View {
        VStack {
            // MARK: HEADER
            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            // MARK: CATEGORY BAR
            ShopCategoryBar(
                categories: uniqueCategories,
                selected: $selectedCategory
            )
            .padding()

            // MARK: CONTENT
            ScrollView {
                contentList
                    .padding()
            }
            .scrollIndicators(.hidden)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.black,
                    Color.blue.opacity(0.25),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadShop()
        }
    }
}

extension ShopView {
    fileprivate func loadShop() async {
        do {
            let shopItems: [ShopItem] = try JSONLoader.load("shop")
            let manager = ShopManager()
            let products = try await manager.loadShopProducts(
                shopItems: shopItems
            )
            storeProducts = products

            if let first = uniqueCategories.first {
                selectedCategory = first.id
            }

            isLoading = false
        } catch {
            errorMessage = "Failed to load shop."
            isLoading = false
        }
    }
}

extension ShopView {
    private func purchase(_ storeProduct: StoreProduct) async {
        let item = storeProduct.shopItem

        // ⭐ GRATIS PACK
        if storeProduct.product == nil {
            if let crystals = item.crystals {
                CrystalManager.shared.add(crystals)
            }

            if item.oneTimePurchase == true {
                UserDefaults.standard.set(
                    true,
                    forKey: "shop_bought_\(item.id)"
                )

                storeProducts.removeAll {
                    $0.shopItem.id == item.id
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
                if case .verified(_) = verification {
                    if let crystals = item.crystals {
                        CrystalManager.shared.add(crystals)
                    }

                    if item.oneTimePurchase == true {
                        UserDefaults.standard.set(
                            true,
                            forKey: "shop_bought_\(item.id)"
                        )

                        storeProducts.removeAll {
                            $0.shopItem.id == item.id
                        }
                    }
                }

            default:
                break
            }

        } catch {
            print("Purchase failed")
        }
    }
}

#Preview {
    ShopView()
}
