//
//  Story.swift
//  Valtasia
//
//  Created by Tufan Cakir on 20.03.26.
//

struct StoryChapter: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let image: String
    let worldId: String
    
    let type: StoryType   // 💥 DAS HINZUFÜGEN
}
