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

        // ❌ glow entfernen
        // let glow = createGlowLayer(path: path, crack: crack)

        let core = createCoreLayer(path: path, crack: crack)

        // ❌ container.addChild(glow)
        container.addChild(core)

        return container
    }

    // MARK: - Core Layer

    private static func createCoreLayer(
        path: CGPath,
        crack: Crack
    ) -> SKShapeNode {

        let core = SKShapeNode(path: path)

        core.lineCap = .round
        core.lineJoin = .round
        core.lineWidth = 6  // feste Größe

        core.strokeColor = UIColor.white.withAlphaComponent(0.9)
        core.strokeTexture = gradientTexture(for: crack)
        core.isAntialiased = true
        core.zPosition = 1

        return core
    }

    // MARK: - Path Builder

    private static func buildPath(
        for crack: Crack
    ) -> CGPath {

        let path = CGMutablePath()
        let segments = min(crack.shape.segments, 10)
        let jaggedness = min(CGFloat(crack.shape.jaggedness), 25)
        let fixedLength: CGFloat = 120
        let halfLength = fixedLength / 2
        path.move(to: CGPoint(x: -halfLength, y: 0))

        var currentX: CGFloat = -halfLength
        let segmentLength =
            fixedLength / CGFloat(segments)

        for _ in 0..<segments {

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

    private static func gradientColors(_ crack: Crack) -> [UIColor] {

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
            return [.red, .orange, .yellow, .green, .blue, .purple]

        case .chaosBlack:
            return [.darkGray, .black]

        // ⭐ NEW ONES

        case .molten:
            return [.red, .orange, .yellow]

        case .toxic:
            return [.green, .systemGreen, .yellow]

        case .celestial:
            return [.white, .cyan, .systemBlue]

        case .shadow:
            return [.black, .purple]

        case .plasma:
            return [.magenta, .cyan]
        }
    }
}
