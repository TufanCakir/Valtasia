//
//  Level.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

struct Level: Codable, Identifiable {

    var id: String

    var battleBackground: String?
    
    var enemies: [String]
    
    let portalHPMultiplier: Double?
    let portalReward: PortalReward?
}
