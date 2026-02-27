//
//  ShopCategory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

enum ShopCategory: String, Codable, CaseIterable {

    case realMoney
    case crystals
    case coins
    case bundles
    case special

    var iconName: String {

        switch self {

        case .realMoney: return "diamond.fill"
        case .crystals: return "bitcoinsign.circle.fill"
        case .coins: return "c.circle.fill"
        case .bundles: return "shippingbox.fill"
        case .special: return "sparkles"
        }
    }

    var color: Color {

        switch self {

        case .realMoney: return .cyan
        case .crystals: return .purple
        case .coins: return .yellow
        case .bundles: return .orange
        case .special: return .pink
        }
    }
}
