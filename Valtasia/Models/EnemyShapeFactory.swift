//
//  EnemyShapeFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

final class EnemyShapeFactory {

    static func makeNode(from enemy: Enemy) -> SKNode {

        let container = SKNode()

        let body: SKShapeNode

        switch enemy.shape {

        case "circle":
            body = SKShapeNode(circleOfRadius: 60)

        case "square":
            body = SKShapeNode(
                rectOf: CGSize(width: 120, height: 120),
                cornerRadius: 12
            )

        case "triangle":

            let path = CGMutablePath()

            path.move(to: CGPoint(x: 0, y: 60))
            path.addLine(to: CGPoint(x: -60, y: -60))
            path.addLine(to: CGPoint(x: 60, y: -60))
            path.closeSubpath()

            body = SKShapeNode(path: path)

        case "star":

            body = SKShapeNode(path: starPath())

        case "blob":

            body = SKShapeNode(
                ellipseOf: CGSize(width: 130, height: 100)
            )

        case "vampire":

            body = SKShapeNode(circleOfRadius: 65)

            addVampireFace(to: container)

        case "warrior":

            body = SKShapeNode(
                rectOf: CGSize(width: 120, height: 120)
            )

            addSword(to: container)

        case "mage":

            body = SKShapeNode(circleOfRadius: 60)

            addMageHat(to: container)

        default:

            body = SKShapeNode(circleOfRadius: 50)
        }

        body.fillColor = colorFromString(enemy.color)
        body.strokeColor = .white
        body.lineWidth = 4

        container.addChild(body)

        addFunnyFace(to: container)

        return container
    }
}

extension EnemyShapeFactory {

    fileprivate static func addFunnyFace(to parent: SKNode) {

        let eyeL = SKShapeNode(circleOfRadius: 6)
        eyeL.fillColor = .black
        eyeL.position = CGPoint(x: -20, y: 10)

        let eyeR = SKShapeNode(circleOfRadius: 6)
        eyeR.fillColor = .black
        eyeR.position = CGPoint(x: 20, y: 10)

        let mouth = SKShapeNode(
            rectOf: CGSize(width: 30, height: 6),
            cornerRadius: 3
        )

        mouth.fillColor = .black
        mouth.position = CGPoint(x: 0, y: -20)

        parent.addChild(eyeL)
        parent.addChild(eyeR)
        parent.addChild(mouth)
    }
}

extension EnemyShapeFactory {

    fileprivate static func starPath() -> CGPath {

        let path = CGMutablePath()

        let points = 5
        let radius: CGFloat = 70

        for i in 0..<(points * 2) {

            let angle =
                CGFloat(i) * .pi / CGFloat(points)

            let r =
                i % 2 == 0 ? radius : radius * 0.4

            let x = cos(angle) * r
            let y = sin(angle) * r

            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }

        path.closeSubpath()

        return path
    }
}

extension EnemyShapeFactory {

    fileprivate static func addVampireFace(to node: SKNode) {
        let fang = SKShapeNode(rectOf: CGSize(width: 6, height: 14))
        fang.fillColor = .white
        fang.position = CGPoint(x: -10, y: -28)
        node.addChild(fang)
    }

    fileprivate static func addSword(to node: SKNode) {
        let sword = SKShapeNode(rectOf: CGSize(width: 8, height: 60))
        sword.fillColor = .gray
        sword.position = CGPoint(x: 60, y: 0)
        node.addChild(sword)
    }

    fileprivate static func addMageHat(to node: SKNode) {
        let hat = SKShapeNode(rectOf: CGSize(width: 90, height: 20))
        hat.fillColor = .purple
        hat.position = CGPoint(x: 0, y: 70)
        node.addChild(hat)
    }
}
