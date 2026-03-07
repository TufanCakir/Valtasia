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
            GridItem(.flexible(), spacing: 18),
            GridItem(.flexible(), spacing: 18),
        ]
    }

    fileprivate var filteredProducts: [StoreProduct] {
        storeProducts.filter {
            $0.shopItem.category.id == selectedCategory
        }
    }

    private var loadingState: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.3)
                .tint(.cyan)

            Text("Shop wird geladen...")
                .foregroundStyle(.white.opacity(0.7))
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    private func errorState(_ message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundStyle(.red)

            Text(message)
                .foregroundStyle(.white.opacity(0.85))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 80)
    }

    var body: some View {
        VStack(spacing: 0) {

            // MARK: HEADER
            GameHeaderView()
                .padding(.horizontal)
                .padding(.top)

            // MARK: CATEGORY BAR
            ShopCategoryBar(
                categories: uniqueCategories,
                selected: $selectedCategory
            )
            .padding(.top, 10)
            .padding(.bottom, 14)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: CONTENT
            ScrollView {
                VStack(spacing: 22) {

                    if isLoading {
                        loadingState
                    } else if let errorMessage {
                        errorState(errorMessage)
                    } else {
                        shopGrid
                    }
                }
                .padding(.horizontal)
                .padding(.top, 18)
                .padding(.bottom, 40)
            }
            .scrollIndicators(.hidden)
        }
        .background { backgroundStyle }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .task { await loadShop() }
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

extension ShopView {
    private var backgroundStyle: some View {
        LinearGradient(
            colors: [Color.black, Color.blue.opacity(0.25)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var shopGrid: some View {
        LazyVGrid(
            columns: gridColumns,
            spacing: 18
        ) {
            ForEach(filteredProducts, id: \.id) { item in
                ShopCardView(storeProduct: item) {
                    Task { await purchase(item) }
                }
            }
        }
    }
}

#Preview {
    ShopView()
}
