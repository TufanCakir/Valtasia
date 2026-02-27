//
//  CrackFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

class CrackFactory {

    static func createNode(
        from crack: Crack
    ) -> SKShapeNode {

        let path = CGMutablePath()

        path.move(to: .zero)

        var currentX: CGFloat = 0

        let segmentLength =
            crack.shape.length / CGFloat(crack.shape.segments)

        for _ in 0..<crack.shape.segments {

            currentX += segmentLength

            let range =
                (-crack.shape.jaggedness)...(crack.shape.jaggedness)

            let randomY =
                CGFloat.random(in: range)

            path.addLine(
                to: CGPoint(
                    x: currentX,
                    y: randomY
                )
            )
        }

        let node = SKShapeNode(path: path)

        node.lineWidth =
            crack.shape.lineWidth

        // Farbe
        switch crack.energyColor {

        case .arcaneBlue:

            node.strokeColor = .cyan
            node.glowWidth = 4

        case .gold:

            node.strokeColor = .yellow
            node.glowWidth = 7

        case .crimson:

            node.strokeColor = .red
            node.glowWidth = 6

        case .violet:

            node.strokeColor = .purple
            node.glowWidth = 8

        case .emerald:

            node.strokeColor = .green
            node.glowWidth = 6

        case .ice:

            node.strokeColor = .systemTeal
            node.glowWidth = 7

        case .chaosBlack:

            node.strokeColor = .black
            node.glowWidth = 10

        case .rainbow:

            node.strokeColor = .white
            node.glowWidth = 12
        }

        switch crack.rarity {
        case .common:
            break
        case .uncommon:
            node.setScale(1.05)
        case .rare:
            node.setScale(1.1)
        case .epic:
            node.setScale(1.2)
        case .legendary:
            node.setScale(1.35)
        case .mythic:
            node.setScale(1.5)
        case .ancient:
            node.setScale(1.7)
        case .divine:
            node.setScale(2.0)
        }

        switch crack.energyShader {
        case .pulse_flow:
            node.run(
                .repeatForever(
                    .sequence([
                        .fadeAlpha(to: 0.7, duration: 0.3),
                        .fadeAlpha(to: 1, duration: 0.3),
                    ])
                )
            )
        case .lightning_flow:
            node.run(
                .repeatForever(
                    .sequence([
                        .rotate(byAngle: .pi / 40, duration: 0.05),
                        .rotate(byAngle: -.pi / 40, duration: 0.05),
                    ])
                )
            )
        case .void_flow:
            node.run(
                .repeatForever(
                    .scale(to: 1.1, duration: 0.4)
                )
            )
        case .legend_flow:
            node.run(
                .repeatForever(
                    .sequence([
                        .scale(to: 1.2, duration: 0.5),
                        .scale(to: 1, duration: 0.5),
                    ])
                )
            )
        case .chaos_flow:
            node.run(
                .repeatForever(
                    .sequence([
                        .rotate(byAngle: .pi / 10, duration: 0.1),
                        .rotate(byAngle: -.pi / 10, duration: 0.1),
                    ])
                )
            )
        default:
            break
        }

        return node
    }
}
