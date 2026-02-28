//
//  CrackFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit
import UIKit

class CrackFactory {

    // MARK: - Public

    static func createNode(from crack: Crack) -> SKNode {

        let container = SKNode()

        let path = buildPath(for: crack)

        // ⭐ Glow Layer
        let glow = SKShapeNode(path: path)
        glow.lineCap = .round
        glow.lineJoin = .round
        glow.lineWidth = crack.shape.lineWidth * 4
        glow.strokeColor = crack.energyColor.skColor.withAlphaComponent(0.25)
        glow.glowWidth = 20
        container.addChild(glow)

        // ⭐ Core Layer
        let core = SKShapeNode(path: path)
        core.lineCap = .round
        core.lineJoin = .round
        core.lineWidth = crack.shape.lineWidth * 1.6
        core.strokeColor = .white
        core.strokeTexture = gradientTexture(for: crack)
        container.addChild(core)

        applyRarityScale(container, crack)

        return container
    }

    // MARK: - Path Builder

    private static func buildPath(for crack: Crack) -> CGPath {

        let path = CGMutablePath()

        let halfLength = crack.shape.length / 2
        path.move(to: CGPoint(x: -halfLength, y: 0))

        var currentX: CGFloat = -halfLength
        let segmentLength =
            crack.shape.length / CGFloat(crack.shape.segments)

        for _ in 0..<crack.shape.segments {

            currentX += segmentLength

            let jaggedness =
                CGFloat(crack.shape.jaggedness)

            let randomY =
                CGFloat.random(
                    in: (-jaggedness)...jaggedness
                )

            path.addLine(
                to: CGPoint(
                    x: currentX,
                    y: randomY
                )
            )
        }

        return path
    }

    // MARK: - Gradient

    private static func gradientTexture(
        for crack: Crack
    ) -> SKTexture {

        let size = CGSize(width: 256, height: 8)

        UIGraphicsBeginImageContext(size)
        let ctx = UIGraphicsGetCurrentContext()!

        let colors = gradientColors(crack)

        let gradient = CGGradient(
            colorsSpace: CGColorSpaceCreateDeviceRGB(),
            colors: colors.map { $0.cgColor } as CFArray,
            locations: nil
        )!

        ctx.drawLinearGradient(
            gradient,
            start: CGPoint(x: 0, y: 0),
            end: CGPoint(x: size.width, y: 0),
            options: []
        )

        let image =
            UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return SKTexture(image: image)
    }

    private static func gradientColors(
        _ crack: Crack
    ) -> [UIColor] {

        switch crack.energyColor {

        case .arcaneBlue:
            return [.cyan, .systemBlue]

        case .gold:
            return [.yellow, .orange]

        case .crimson:
            return [.red, .systemPink]

        case .violet:
            return [.purple, .magenta]

        case .emerald:
            return [.green, .cyan]

        case .ice:
            return [.white, .systemTeal]

        case .rainbow:
            return [
                .red, .orange, .yellow,
                .green, .blue, .purple,
            ]

        case .chaosBlack:
            return [.darkGray, .black]
        }
    }

    // MARK: - Rarity Scale

    private static func applyRarityScale(
        _ node: SKNode,
        _ crack: Crack
    ) {

        switch crack.rarity {

        case .common:
            node.setScale(1.2)

        case .uncommon:
            node.setScale(1.35)

        case .rare:
            node.setScale(1.6)

        case .epic:
            node.setScale(1.9)

        case .legendary:
            node.setScale(2.3)

        case .mythic:
            node.setScale(2.8)

        case .ancient:
            node.setScale(3.2)

        case .divine:
            node.setScale(3.6)
        }
    }
}
