//
//  Array+Safe.swift.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import Foundation

extension Array {

    subscript(safe index: Int) -> Element? {
        indices.contains(index)
            ? self[index]
            : nil
    }
}
