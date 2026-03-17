//
//  PortalWorld.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import Foundation

struct PortalWorld: Codable, Identifiable {
    let id: String
    let background: String
    let battleBackground: String
    let unlockAfterWorld: String?
    let worldNodes: [PortalNode]
}

struct PortalReward: Codable {
    let coins: Int
    let gems: Int
}
