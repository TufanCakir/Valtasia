//
//  SkillButtonNode.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SpriteKit

final class SkillButtonNode: SKNode {

    // MARK: - Properties

    let skill: Skill

    private let radius: CGFloat = 14

    private var background: SKShapeNode!
    private var iconLabel: SKLabelNode!
    private var cooldownOverlay: SKShapeNode!

    // MARK: - Init

    init(skill: Skill) {

        self.skill = skill
        super.init()

        self.name = "skill_\(skill.id)"
        self.zPosition = 1000   // ⭐ Immer über Combat

        buildUI()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - UI

    private func buildUI() {

        let color = skill.color?.skColor ?? .white

        // ⭐ Background Circle
        background = SKShapeNode(circleOfRadius: radius)
        background.fillColor = color.withAlphaComponent(0.25)
        background.strokeColor = color
        background.lineWidth = 3
        background.glowWidth = 6
        background.zPosition = 0
        background.isUserInteractionEnabled = false

        addChild(background)

        // ⭐ Icon
        iconLabel = SKLabelNode(text: "★")
        iconLabel.fontSize = radius
        iconLabel.verticalAlignmentMode = .center
        iconLabel.fontColor = color
        iconLabel.zPosition = 1
        iconLabel.isUserInteractionEnabled = false

        addChild(iconLabel)

        // ⭐ Cooldown Overlay (unsichtbar erstmal)
        cooldownOverlay = SKShapeNode(circleOfRadius: radius)
        cooldownOverlay.fillColor = .black
        cooldownOverlay.alpha = 0
        cooldownOverlay.zPosition = 2
        cooldownOverlay.isUserInteractionEnabled = false

        addChild(cooldownOverlay)
    }

    // MARK: - Touch Feedback

    func pressAnimation() {

        removeAction(forKey: "press")

        let press = SKAction.sequence([
            .scale(to: 0.9, duration: 0.05),
            .scale(to: 1.0, duration: 0.08)
        ])

        run(press, withKey: "press")
    }

    // MARK: - Cooldown Support

    func startCooldown(duration: TimeInterval) {

        cooldownOverlay.alpha = 0.6

        cooldownOverlay.run(
            .sequence([
                .wait(forDuration: duration),
                .fadeOut(withDuration: 0.2)
            ])
        )
    }
}
