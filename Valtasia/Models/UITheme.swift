//
//  UITheme.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import SwiftUI

struct UITheme {

    let headerGradient: [Color]
    let borderGradient: [Color]
    let footerGradient: [Color]
}

extension UITheme {

    static let island = UITheme(
        headerGradient: [
            Color.black,
            Color.indigo,
        ],
        borderGradient: [
            Color.black,
            Color.indigo,
            ],
        footerGradient: [
            Color.black,
            Color.indigo,
        ]
    )

    static let corrupted = UITheme(
        headerGradient: [
            Color.black,
            Color.green,
        ],
        borderGradient: [
            Color.black,
            Color.green,
        ],
        footerGradient: [
            Color.black,
            Color.green,
        ]
    )
}
