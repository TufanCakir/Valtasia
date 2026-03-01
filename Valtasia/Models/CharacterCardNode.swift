//
//  CharacterCardNode.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SpriteKit

class CharacterCardNode: SKNode {

    let owned: OwnedCharacter

    private var expFill: SKShapeNode!

    // ⭐ Skills pro Character
    private var skillButtons: [SkillButtonNode] = []

    init(owned: OwnedCharacter) {

        self.owned = owned

        super.init()

        buildUI()
        spawnSkills()  // ⭐ Skills erzeugen
        updateEXP()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: UI

    private func buildUI() {

        // CARD BG
        let bg = SKShapeNode(
            rectOf: CGSize(width: 75, height: 95),
            cornerRadius: 12
        )

        bg.fillColor = .black.withAlphaComponent(0.6)
        bg.strokeColor = .white
        bg.lineWidth = 2

        addChild(bg)

        // Portrait

        let portrait = SKSpriteNode(
            imageNamed: owned.base.sprite
        )

        portrait.size =
        CGSize(width: 60, height: 60)

        portrait.position =
            CGPoint(x: 0, y: 12)

        addChild(portrait)

        // EXP BG

        let expBG = SKShapeNode(
            rectOf: CGSize(width: 60, height: 8),
            cornerRadius: 3
        )

        expBG.fillColor = .darkGray

        expBG.position =
            CGPoint(x: 0, y: -35)

        addChild(expBG)

        // EXP Fill

        let fill = SKShapeNode(
            rectOf: CGSize(width: 70, height: 8),
            cornerRadius: 3
        )

        fill.fillColor = .cyan

        fill.position = .zero

        expBG.addChild(fill)

        expFill = fill
    }

    // MARK: Skills

    private func spawnSkills() {

        skillButtons.forEach { $0.removeFromParent() }
        skillButtons.removeAll()

        let skills = owned.base.skills
        guard !skills.isEmpty else { return }

        let buttonSpacing: CGFloat = 32
        let totalWidth = buttonSpacing * CGFloat(skills.count - 1)

        var startX = -totalWidth / 2

        for skill in skills {

            let button = SkillButtonNode(skill: skill)

            button.position = CGPoint(
                x: startX,
                y: 55
            )

            addChild(button)
            skillButtons.append(button)

            startX += buttonSpacing
        }
    }

    // MARK: EXP

    func updateEXP() {

        let ratio =
            CGFloat(owned.exp) / CGFloat(owned.requiredEXP)

        expFill.xScale =
            max(0, min(1, ratio))

        expFill.position.x =
            -(70 * (1 - expFill.xScale)) / 2
    }
}

