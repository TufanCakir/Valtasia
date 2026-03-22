//
//  ShopView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit
import SwiftUI

struct ShopView: View {

    @EnvironmentObject var appModel: AppModel

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

    private var gridColumns: [GridItem] {
        [
            GridItem(.adaptive(minimum: 150), spacing: 16)
        ]
    }

    fileprivate var filteredProducts: [StoreProduct] {
        storeProducts.filter {
            selectedCategory.isEmpty
                || $0.shopItem.category.id == selectedCategory
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

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        VStack {

            // MARK: CATEGORY BAR
            ShopCategoryBar(
                categories: uniqueCategories,
                selected: $selectedCategory
            )

            Divider()
                .background(.white.opacity(0.15))

            // MARK: CONTENT
            ScrollView {
                VStack(spacing: 20) {

                    if isLoading {
                        loadingState
                    } else if let errorMessage {
                        errorState(errorMessage)
                    } else {
                        shopGrid
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20)
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

            let ids = shopItems.compactMap { $0.storeProductId }

            try await StoreKitService.shared.loadProducts(ids: ids)

            let manager = ShopManager()
            storeProducts = manager.buildStoreProducts(shopItems: shopItems)

            isLoading = false

        } catch {
            errorMessage = "Shop konnte nicht geladen werden."
            isLoading = false
        }
    }
}

extension ShopView {
    private func purchase(_ storeProduct: StoreProduct) async {
        let item = storeProduct.shopItem

        // GRATIS
        if storeProduct.product == nil {
            grantItem(item)
            return
        }

        guard let product = storeProduct.product else { return }

        do {
            let success = try await StoreKitService.shared.purchase(product)

            if success {
                grantItem(item)
            }

        } catch {
            print("❌ Purchase error:", error)
        }
    }

    private func grantItem(_ item: ShopItem) {

        if let gems = item.gems {
            GemManager.shared.add(gems)
        }

        if let corrupted = item.corruptedGems {
            CorruptedGemManager.shared.add(corrupted)
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
}

extension ShopView {
    private var backgroundStyle: some View {
        LinearGradient(
            colors: theme.headerGradient,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var shopGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 16) {
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
