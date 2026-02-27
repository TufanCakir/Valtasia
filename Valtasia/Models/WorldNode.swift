//
//  WorldNode.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

struct WorldNode: Codable, Identifiable {

    let id: String

    let image: String

    let positionX: CGFloat
    let positionY: CGFloat

    let connectsTo: [String]

    let levels: [Level]   // ⭐ NICHT [String] !!
}
