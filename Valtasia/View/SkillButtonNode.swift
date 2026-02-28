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

        let radius: CGFloat = 28
        let color = skill.color?.skColor ?? .white

        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = color.withAlphaComponent(0.25)
        circle.strokeColor = color
        circle.lineWidth = 3
        circle.glowWidth = 6

        addChild(circle)

        let label = SKLabelNode(text: "★")
        label.fontSize = 22
        label.verticalAlignmentMode = .center
        label.fontColor = color

        addChild(label)

        self.name = "skill_\(skill.id)"

        let hitbox = SKShapeNode(circleOfRadius: radius + 14)
        hitbox.fillColor = .clear
        hitbox.strokeColor = .clear
        hitbox.name = self.name
        addChild(hitbox)
    }
}
