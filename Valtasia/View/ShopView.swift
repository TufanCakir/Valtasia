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
            .padding(.horizontal, 20)
            .padding(.top, 14)

            // MARK: CONTENT
            ScrollView {

                VStack(spacing: 24) {
                    contentList
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 140)  // Platz für Footer
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

    fileprivate var contentList: some View {

        VStack(spacing: 20) {

            if isLoading {

                ProgressView("Loading Shop...")
                    .tint(.white)
                    .padding(.top, 40)
            }

            else if let errorMessage {

                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding(.top, 40)
            }

            else {

                ForEach(filteredProducts, id: \.id) { item in

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
            $0.shopItem.category.id == selectedCategory
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
