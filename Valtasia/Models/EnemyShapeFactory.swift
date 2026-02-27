//
//  EnemyShapeFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

final class EnemyShapeFactory {

    static func makeNode(from enemy: Enemy) -> SKShapeNode {

        let node: SKShapeNode

        switch enemy.shape {

        case "circle":
            node = SKShapeNode(circleOfRadius: 60)

        case "square":
            node = SKShapeNode(
                rectOf: CGSize(width: 120, height: 120),
                cornerRadius: 12
            )

        case "triangle":

            let path = CGMutablePath()

            path.move(to: CGPoint(x: 0, y: 60))
            path.addLine(to: CGPoint(x: -60, y: -60))
            path.addLine(to: CGPoint(x: 60, y: -60))
            path.closeSubpath()

            node = SKShapeNode(path: path)

        default:
            node = SKShapeNode(circleOfRadius: 50)
        }

        node.fillColor = colorFromString(enemy.color)
        node.strokeColor = .white
        node.lineWidth = 4

        return node
    }
}
