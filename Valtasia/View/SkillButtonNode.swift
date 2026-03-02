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

    private let radius: CGFloat = 20

    private var background: SKShapeNode!
    private var iconSprite: SKSpriteNode!
    private var border: SKShapeNode!
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

    required init?(coder: NSCoder) {
        fatalError()
    }

    func canUse() -> Bool {

        return !isOnCooldown
    }

    // MARK: - UI

    private func buildUI() {

        let color = skill.color?.skColor ?? .white

        // Background
        background = SKShapeNode(circleOfRadius: radius)
        background.fillColor = color.withAlphaComponent(0.15)
        background.strokeColor = .clear
        addChild(background)

        // Border Glow
        border = SKShapeNode(circleOfRadius: radius)
        border.strokeColor = color
        border.lineWidth = 4
        border.glowWidth = 5
        border.alpha = 0.8
        addChild(border)

        // Icon (falls du später echte Skill Icons willst -> texture)
        iconSprite = SKSpriteNode(
            color: color,
            size: CGSize(width: 20, height: 20)
        )
        iconSprite.alpha = 0.9
        iconSprite.zPosition = 2
        addChild(iconSprite)

        // Cooldown radial mask
        cooldownMask = SKShapeNode(circleOfRadius: radius)
        cooldownMask.fillColor = .black
        cooldownMask.alpha = 0
        cooldownMask.zPosition = 5
        addChild(cooldownMask)

        // Cooldown label
        cooldownLabel = SKLabelNode(fontNamed: "AvenirNext-Bold")
        cooldownLabel.fontSize = 14
        cooldownLabel.fontColor = .white
        cooldownLabel.verticalAlignmentMode = .center
        cooldownLabel.zPosition = 6
        cooldownLabel.alpha = 0
        addChild(cooldownLabel)

        startIdlePulse()
    }

    // MARK: - Idle Glow

    private func startIdlePulse() {

        let pulse = SKAction.sequence([
            .fadeAlpha(to: 1.0, duration: 0.8),
            .fadeAlpha(to: 0.6, duration: 0.8),
        ])

        border.run(.repeatForever(pulse))
    }

    // MARK: - Press Feedback

    func pressAnimation() {

        guard !isOnCooldown else { return }

        removeAction(forKey: "press")

        let press = SKAction.sequence([
            .scale(to: 0.85, duration: 0.05),
            .scale(to: 1.05, duration: 0.08),
            .scale(to: 1.0, duration: 0.05),
        ])

        run(press, withKey: "press")
    }

    // MARK: - Cooldown

    func startCooldown(duration: TimeInterval) {

        guard duration > 0 else { return }

        isOnCooldown = true

        cooldownMask.alpha = 0.65
        cooldownLabel.alpha = 1

        let total = Int(duration)
        var remaining = total

        cooldownLabel.text = "\(remaining)"

        let countdown = SKAction.repeat(
            SKAction.sequence([
                .wait(forDuration: 1),
                .run { [weak self] in
                    guard let self else { return }
                    remaining -= 1
                    self.cooldownLabel.text = "\(max(remaining, 0))"
                },
            ]),
            count: total
        )

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
            iconSprite.alpha = 0.3
        } else {
            let color = skill.color?.skColor ?? .white
            background.fillColor = color.withAlphaComponent(0.15)
            border.strokeColor = color
            iconSprite.alpha = 0.9
        }
    }
}
