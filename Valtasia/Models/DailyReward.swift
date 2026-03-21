//
//  DailyReward.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import Foundation

struct DailyReward: Codable, Identifiable {
    let day: Int

    let coins: Int?
    let gems: Int?
    let exp: Int?

    let corruptedCoins: Int?
    let corruptedGems: Int?

    var id: Int { day }
}

enum DailyRewardLoader {

    static func load() -> [DailyReward] {
        guard
            let url = Bundle.main.url(
                forResource: "daily_rewards",
                withExtension: "json"
            ),
            let data = try? Data(contentsOf: url),
            let rewards = try? JSONDecoder().decode(
                [DailyReward].self,
                from: data
            )
        else {
            print("❌ daily_rewards.json konnte nicht geladen werden")
            return []
        }

        return rewards.sorted { $0.day < $1.day }
    }
}
