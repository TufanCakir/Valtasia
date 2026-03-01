//
//  CrackFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit
import UIKit

final class CrackFactory {

    // MARK: - Gradient Cache

    private static var textureCache: [String: SKTexture] = [:]

    // MARK: - Public

    static func createNode(from crack: Crack) -> SKNode {

        let container = SKNode()
        container.name = crack.id

        let path = buildPath(for: crack)

        let glow = createGlowLayer(path: path, crack: crack)
        let core = createCoreLayer(path: path, crack: crack)

        container.addChild(glow)
        container.addChild(core)

        applyRarityScale(container, crack)

        return container
    }

    // MARK: - Glow Layer

    private static func createGlowLayer(
        path: CGPath,
        crack: Crack
    ) -> SKShapeNode {

        let glow = SKShapeNode(path: path)

        glow.lineCap = .round
        glow.lineJoin = .round
        glow.lineWidth = crack.shape.lineWidth * 3

        glow.strokeColor =
            crack.energyColor.skColor
                .withAlphaComponent(0.25)

        glow.glowWidth = crack.visual.glow
        glow.blendMode = .add
        glow.isAntialiased = true
        glow.zPosition = 0

        return glow
    }

    // MARK: - Core Layer

    private static func createCoreLayer(
        path: CGPath,
        crack: Crack
    ) -> SKShapeNode {

        let core = SKShapeNode(path: path)

        core.lineCap = .round
        core.lineJoin = .round
        core.lineWidth = crack.shape.lineWidth * 1.6

        core.strokeColor = .white
        core.strokeTexture = gradientTexture(for: crack)

        core.blendMode = .add
        core.isAntialiased = true
        core.zPosition = 1

        return core
    }

    // MARK: - Path Builder

    private static func buildPath(
        for crack: Crack
    ) -> CGPath {

        let path = CGMutablePath()

        let halfLength = crack.shape.length / 2
        path.move(to: CGPoint(x: -halfLength, y: 0))

        var currentX: CGFloat = -halfLength
        let segmentLength =
            crack.shape.length /
            CGFloat(crack.shape.segments)

        let jaggedness =
            CGFloat(crack.shape.jaggedness)

        for _ in 0..<crack.shape.segments {

            currentX += segmentLength

            let randomY =
                CGFloat.random(
                    in: -jaggedness...jaggedness
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

    // MARK: - Gradient Texture

    private static func gradientTexture(
        for crack: Crack
    ) -> SKTexture {

        // Jeder Crack eigene Textur
        let key = crack.id

        if let cached = textureCache[key] {
            return cached
        }

        let size = CGSize(width: 256, height: 8)

        let renderer =
            UIGraphicsImageRenderer(size: size)

        let image = renderer.image { ctx in

            let colors = gradientColors(crack)

            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: colors.map { $0.cgColor } as CFArray,
                locations: nil
            )!

            ctx.cgContext.drawLinearGradient(
                gradient,
                start: .zero,
                end: CGPoint(x: size.width, y: 0),
                options: []
            )
        }

        let texture = SKTexture(image: image)
        textureCache[key] = texture

        return texture
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
                .red,
                .orange,
                .yellow,
                .green,
                .blue,
                .purple
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

        let scale: CGFloat

        switch crack.rarity {

        case .common: scale = 0.55
        case .uncommon: scale = 0.65
        case .rare: scale = 0.75
        case .epic: scale = 0.85
        case .legendary: scale = 0.95
        case .mythic: scale = 1.05
        case .ancient: scale = 1.15
        case .divine: scale = 1.25
        }

        node.setScale(scale)
    }
}
