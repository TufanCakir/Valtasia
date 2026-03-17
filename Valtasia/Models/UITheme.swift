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
            Color.black.opacity(0.95),
            Color.blue.opacity(0.35)
        ],
        borderGradient: [.cyan, .purple],
        footerGradient: [.cyan, .purple]
    )
    
    static let portal = UITheme(
        headerGradient: [
            Color.black,
            Color.green,
            Color.black
        ],
        borderGradient: [
            Color.green,
            Color.green.opacity(0.7),
            Color.purple
        ],
        footerGradient: [
            Color.black,
            Color.green,
            Color.black
        ]
    )
}
