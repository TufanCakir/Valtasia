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

        VStack(spacing: 0) {

            // MARK: HEADER
            header
                .padding(.horizontal, 20)
                .padding(.top, 18)
                .padding(.bottom, 12)

            Divider()
                .background(.white.opacity(0.15))

            // MARK: CATEGORY BAR
            ShopCategoryBar(selected: $selectedCategory)
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

    var header: some View {

        HStack {

            VStack(alignment: .leading, spacing: 4) {

                Text("Premium Shop")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Text("Erweitere deine Macht")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 8) {

                HStack(spacing: 8) {
                    Image(systemName: "circle.fill")
                    Text("\(CoinManager.shared.coins)")
                }

                HStack(spacing: 8) {
                    Image(systemName: "diamond.fill")
                        .foregroundStyle(.cyan)
                    Text("\(CrystalManager.shared.crystals)")
                        .bold()
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
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

                ForEach(filteredProducts, id: \.shopItem.id) { item in

                    PremiumShopRow(storeProduct: item) {

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
    fileprivate func loadShop() async {
        do {
            let shopItems: [ShopItem] = try JSONLoader.load("shop")
            let manager = ShopManager()
            let products = try await manager.loadShopProducts(
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
