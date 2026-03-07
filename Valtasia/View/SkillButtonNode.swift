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

    private let radius: CGFloat = 13  // statt 16

    private var background: SKShapeNode!
    private var iconSprite: SKSpriteNode!
    private var border: SKShapeNode!
    private var gloss: SKShapeNode!
    private var cooldownMask: SKShapeNode!
    private var cooldownLabel: SKLabelNode!

    private var isOnCooldown = false

    // MARK: - Init

    init(skill: Skill) {
        self.skill = skill
        super.init()

        self.name = "skill_\(skill.id)"
        self.zPosition = 1000

        buildUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    func canUse() -> Bool { !isOnCooldown }

    // MARK: - UI

    private func buildUI() {

        let color = skill.color?.skColor ?? .white

        // ⭐ Background Base
        background = SKShapeNode(circleOfRadius: radius)
        background.fillColor = .black.withAlphaComponent(0.65)
        background.strokeColor = .clear
        background.zPosition = 0
        addChild(background)

        // ⭐ Soft Inner Tint
        let tint = SKShapeNode(circleOfRadius: radius - 3)
        tint.fillColor = color.withAlphaComponent(0.18)
        tint.strokeColor = .clear
        tint.zPosition = 1
        addChild(tint)

        // ⭐ Border Glow
        border = SKShapeNode(circleOfRadius: radius)
        border.strokeColor = color
        border.lineWidth = 3
        border.glowWidth = 6
        border.alpha = 0.9
        border.zPosition = 3
        addChild(border)

        // ⭐ Icon (zentriert & klar)
        iconSprite = SKSpriteNode(
            color: color,
            size: CGSize(width: 16, height: 16)
        )
        iconSprite.alpha = 0.95
        iconSprite.zPosition = 4
        addChild(iconSprite)

        // ⭐ Gloss Highlight (MMO Look)
        gloss = SKShapeNode(circleOfRadius: radius)
        gloss.fillColor = .white
        gloss.alpha = 0.06
        gloss.zPosition = 5
        gloss.setScale(1.02)
        addChild(gloss)

        // ⭐ Cooldown Mask (nur Icon abdunkeln)
        cooldownMask = SKShapeNode(circleOfRadius: radius - 2)
        cooldownMask.fillColor = .black
        cooldownMask.alpha = 0
        cooldownMask.zPosition = 6
        addChild(cooldownMask)

        // ⭐ Cooldown Label
        cooldownLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        cooldownLabel.fontSize = 13
        cooldownLabel.fontColor = .white
        cooldownLabel.verticalAlignmentMode = .center
        cooldownLabel.zPosition = 7
        cooldownLabel.alpha = 0
        addChild(cooldownLabel)

        startIdlePulse()
    }

    // MARK: - Idle Glow

    private func startIdlePulse() {

        let pulse = SKAction.sequence([
            .fadeAlpha(to: 1.0, duration: 1.0),
            .fadeAlpha(to: 0.7, duration: 1.0),
        ])

        border.run(.repeatForever(pulse))
    }

    // MARK: - Press Feedback

    func pressAnimation() {

        guard !isOnCooldown else { return }

        removeAllActions()

        let press = SKAction.sequence([
            .scale(to: 0.82, duration: 0.05),
            .scale(to: 1.08, duration: 0.08),
            .scale(to: 1.0, duration: 0.06),
        ])

        let flash = SKAction.sequence([
            .fadeAlpha(to: 1.0, duration: 0.06),
            .fadeAlpha(to: 0.9, duration: 0.12),
        ])

        run(press)
        border.run(flash)
    }

    // MARK: - Cooldown

    func startCooldown(duration: TimeInterval) {

        guard duration > 0 else { return }

        isOnCooldown = true

        cooldownMask.alpha = 0.7
        cooldownLabel.alpha = 1

        let total = Int(duration)
        var remaining = total
        cooldownLabel.text = "\(remaining)"

        let tick = SKAction.sequence([
            .wait(forDuration: 1),
            .run { [weak self] in
                guard let self else { return }
                remaining -= 1
                self.cooldownLabel.text = "\(max(remaining, 0))"
            },
        ])

        let countdown = SKAction.repeat(tick, count: total)

        let finish = SKAction.run { [weak self] in
            self?.resetCooldown()
        }

        run(.sequence([countdown, finish]))
    }

    private func resetCooldown() {

        isOnCooldown = false

        cooldownMask.run(.fadeOut(withDuration: 0.2))
        cooldownLabel.run(.fadeOut(withDuration: 0.2))
    }

    // MARK: - Lock State

    func setLocked(_ locked: Bool) {

        if locked {
            background.fillColor = .darkGray
            border.strokeColor = .gray
            iconSprite.alpha = 0.25
        } else {
            let color = skill.color?.skColor ?? .white
            background.fillColor = .black.withAlphaComponent(0.65)
            border.strokeColor = color
            iconSprite.alpha = 0.95
        }
    }
}
