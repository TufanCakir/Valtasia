//
//  World.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

struct World: Codable, Identifiable {

    let id: String

    let background: String
    let battleBackground: String

    let unlockAfterWorld: String?

    let worldNodes: [WorldNode]
}
