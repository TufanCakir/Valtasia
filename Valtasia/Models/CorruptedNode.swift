//
//  CorruptedNode.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import Foundation

struct CorruptedNode: Codable, Identifiable {
    let id: String
    let image: String
    let positionX: CGFloat
    let positionY: CGFloat
    let connectsTo: [String] // ⭐ DAS HAT GEFEHLT
    let levels: [Level]
}
