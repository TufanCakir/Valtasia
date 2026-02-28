//
//  SkillButtonNode.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SpriteKit
    
class SkillButtonNode: SKNode {

    let skill: Skill

    init(skill: Skill) {

        self.skill = skill

        super.init()

        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func buildUI() {

        let circle = SKShapeNode(circleOfRadius: 18)
        circle.fillColor = .black.withAlphaComponent(0.7)
        circle.strokeColor = skill.color?.skColor ?? .white
        circle.lineWidth = 2

        addChild(circle)

        let label = SKLabelNode(text: "★")
        label.fontSize = 16
        label.verticalAlignmentMode = .center
        label.fontColor = skill.color?.skColor ?? .white

        addChild(label)

        // ⭐ DAS WAR DEIN FEHLER
        self.name = "skill_\(skill.id)"
    }
}
