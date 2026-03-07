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
    private let cardSize = CGSize(width: 86, height: 112)

    init(owned: OwnedCharacter) {
        self.owned = owned
        super.init()
        buildUI()
        updateEXP(animated: false)
        startIdleFloat()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: UI

    private func buildUI() {

        zPosition = 100

        // ⭐ Shadow
        let shadow = SKShapeNode(rectOf: cardSize, cornerRadius: 16)
        shadow.fillColor = .black
        shadow.alpha = 0.28
        shadow.position = CGPoint(x: 0, y: -5)
        shadow.zPosition = 0
        addChild(shadow)

        // ⭐ Card BG
        let bg = SKShapeNode(rectOf: cardSize, cornerRadius: 16)
        bg.fillColor = .black.withAlphaComponent(0.65)
        bg.strokeColor = .white.withAlphaComponent(0.25)
        bg.lineWidth = 2
        bg.zPosition = 1
        addChild(bg)

        // ⭐ Portrait Glow Frame
        let frame = SKShapeNode(
            rectOf: CGSize(width: 70, height: 70),
            cornerRadius: 12
        )
        frame.strokeColor = .cyan
        frame.lineWidth = 2
        frame.glowWidth = 6
        frame.alpha = 0.6
        frame.position = CGPoint(x: 0, y: 18)
        frame.zPosition = 2
        addChild(frame)

        // ⭐ Portrait
        let portrait = SKSpriteNode(imageNamed: owned.base.sprite)
        portrait.size = CGSize(width: 64, height: 64)
        portrait.position = CGPoint(x: 0, y: 18)
        portrait.zPosition = 3
        addChild(portrait)

        // ⭐ EXP BG
        let expBG = SKShapeNode(
            rectOf: CGSize(width: 66, height: 10),
            cornerRadius: 4
        )
        expBG.fillColor = .darkGray
        expBG.strokeColor = .clear
        expBG.position = CGPoint(x: 0, y: -40)
        expBG.zPosition = 2
        addChild(expBG)

        // ⭐ EXP Fill (anchor links)
        let fill = SKShapeNode(
            rectOf: CGSize(width: 66, height: 10),
            cornerRadius: 4
        )
        fill.fillColor = .cyan
        fill.strokeColor = .clear
        fill.position = CGPoint(x: -33, y: 0)  // linksbündig
        fill.xScale = 0
        fill.zPosition = 3
        expBG.addChild(fill)

        expFill = fill
    }

    // MARK: EXP

    func updateEXP(animated: Bool = true) {

        let ratio = CGFloat(owned.exp) / CGFloat(owned.requiredEXP)
        let clamped = max(0, min(1, ratio))

        if animated {
            let action = SKAction.scaleX(to: clamped, duration: 0.25)
            action.timingMode = .easeOut
            expFill.run(action)
        } else {
            expFill.xScale = clamped
        }
    }

    // MARK: Idle Animation

    private func startIdleFloat() {

        let float = SKAction.sequence([
            .moveBy(x: 0, y: 2, duration: 1.6),
            .moveBy(x: 0, y: -2, duration: 1.6),
        ])

        run(.repeatForever(float))
    }
}
