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
    private let radius: CGFloat = 13

    private var background: SKShapeNode!
    private var border: SKShapeNode!
    private var iconSprite: SKSpriteNode!
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

        // ⭐ Background
        background = SKShapeNode(circleOfRadius: radius)
        background.fillColor = .black.withAlphaComponent(0.7)
        background.strokeColor = .clear
        addChild(background)

        // ⭐ Border (clean, no glow)
        border = SKShapeNode(circleOfRadius: radius)
        border.strokeColor = color
        border.lineWidth = 2
        border.zPosition = 2
        addChild(border)

        // ⭐ Icon
        iconSprite = SKSpriteNode(
            color: color,
            size: CGSize(width: 16, height: 16)
        )
        iconSprite.alpha = 0.95
        iconSprite.zPosition = 3
        addChild(iconSprite)

        // ⭐ Cooldown Mask
        cooldownMask = SKShapeNode(circleOfRadius: radius - 2)
        cooldownMask.fillColor = .black
        cooldownMask.alpha = 0
        cooldownMask.zPosition = 4
        addChild(cooldownMask)

        // ⭐ Cooldown Label
        cooldownLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        cooldownLabel.fontSize = 12
        cooldownLabel.fontColor = .white
        cooldownLabel.verticalAlignmentMode = .center
        cooldownLabel.zPosition = 5
        cooldownLabel.alpha = 0
        addChild(cooldownLabel)

        startIdlePulse()
    }

    // MARK: - Idle Animation (clean instead of glow)

    private func startIdlePulse() {

        let scale = SKAction.sequence([
            .scale(to: 1.05, duration: 0.8),
            .scale(to: 1.0, duration: 0.8),
        ])

        run(.repeatForever(scale))
    }

    // MARK: - Press Feedback

    func pressAnimation() {

        guard !isOnCooldown else { return }

        let press = SKAction.sequence([
            .scale(to: 0.85, duration: 0.05),
            .scale(to: 1.1, duration: 0.08),
            .scale(to: 1.0, duration: 0.06),
        ])

        run(press)
    }

    // MARK: - Cooldown

    func startCooldown(duration: TimeInterval) {

        guard duration > 0 else { return }

        isOnCooldown = true

        cooldownMask.alpha = 0.6
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
            background.fillColor = .black.withAlphaComponent(0.7)
            border.strokeColor = color
            iconSprite.alpha = 0.95
        }
    }
}
