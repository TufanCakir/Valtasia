//
//  CorruptedWorld.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import Foundation

struct CorruptedWorld: Codable, Identifiable {
    let id: String
    let background: String
    let battleBackground: String
    let unlockAfterWorld: String?
    let worldNodes: [CorruptedNode]
}

struct CorruptedReward: Codable {
    let coins: Int
    let gems: Int
}
