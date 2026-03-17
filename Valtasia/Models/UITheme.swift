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
            Color.blue.opacity(0.35),
            Color.purple.opacity(0.35),
        ],
        borderGradient: [.cyan, .purple],
        footerGradient: [
            Color.blue.opacity(0.35),
            Color.purple.opacity(0.35),
        ]
    )

    static let portal = UITheme(
        headerGradient: [
            Color.green.opacity(0.35),
            Color.purple.opacity(0.35),
        ],
        borderGradient: [
            Color.green,
            Color.purple,
        ],
        footerGradient: [
            Color.green.opacity(0.35),
            Color.purple.opacity(0.35),
        ]
    )
}
