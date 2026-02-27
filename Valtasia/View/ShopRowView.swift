//
//  ShopRowView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI
import StoreKit

struct ShopRowView: View {

    let storeProduct: StoreProduct
    let onBuy: () -> Void

    var body: some View {

        HStack {

            VStack(alignment: .leading) {
                Text("\(storeProduct.shopItem.gems) Gems")
                    .font(.headline)

                Text(storeProduct.product.displayPrice)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            Button("Buy") {
                onBuy()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 8)
    }
}
