//
//  CategoryBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct ShopCategoryBar: View {

    @Binding var selected: ShopCategory

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 14) {

                ForEach(ShopCategory.allCases, id: \.self) { cat in

                    Button {

                        withAnimation {
                            selected = cat
                        }

                    } label: {

                        Text(title(cat))
                            .padding(.horizontal, 14)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(
                                        selected == cat
                                            ? .blue
                                            : .gray.opacity(0.3)
                                    )
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    func title(_ cat: ShopCategory) -> String {

        switch cat {

        case .realMoney: return "💎 Crystals"
        case .coins: return "🪙 Coins"
        case .crystals: return "Exchange"
        case .bundles: return "Bundles"
        case .special: return "Special"
        }
    }
}
