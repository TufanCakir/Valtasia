//
//  StoreKitService.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import StoreKit

class StoreKitService {

    static let shared = StoreKitService()

    func fetchProducts(
        ids: [String]
    ) async throws -> [Product] {

        return try await Product.products(
            for: ids
        )
    }
}
