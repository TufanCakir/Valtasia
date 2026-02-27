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
        crack.shape.length /
        CGFloat(crack.shape.segments)

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

        case .gold:
            node.strokeColor = .yellow

        case .crimson:
            node.strokeColor = .red

        case .violet:
            node.strokeColor = .purple
        }

        node.glowWidth = 2

        return node
    }
}
