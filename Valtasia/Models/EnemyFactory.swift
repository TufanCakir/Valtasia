//
//  EnemyFactory.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

final class EnemyFactory {

    static func makeNode(from enemy: Enemy) -> SKNode {

        let container = SKNode()

        // ⭐ PNG laden über Enemy ID
        let texture = SKTexture(imageNamed: enemy.id)

        if texture.size() == .zero {
            print("❌ Missing PNG:", enemy.id)
        }

        let sprite = SKSpriteNode(texture: texture)

        // falls PNG fehlt -> fallback
        if sprite.texture == nil {

            print("Missing PNG for:", enemy.id)

            let fallback = SKShapeNode(circleOfRadius: 60)
            fallback.fillColor = .red
            container.addChild(fallback)

            return container
        }

        // Determine a target width based on the presenting screen. Avoid UIScreen.main (deprecated on iOS 26).
        let targetWidth: CGFloat = {
            // Try to resolve from SpriteKit view/window context first
            if let screen = sprite.scene?.view?.window?.windowScene?.screen {
                return screen.bounds.width * 0.45
            }
            // Fallbacks: use the view's bounds if available
            if let viewWidth = sprite.scene?.view?.bounds.width, viewWidth > 0 {
                return viewWidth * 0.45
            }
            // As a last resort, use legacy UIScreen.main on older systems where it's not deprecated at compile time
            #if !os(watchOS)
            if #available(iOS 26.0, *) {
                // Avoid UIScreen.main on iOS 26+; choose a conservative default
                return 320 * 0.45
            } else {
                return UIScreen.main.bounds.width * 0.45
            }
            #else
            return 320 * 0.45
            #endif
        }()

        let scale = targetWidth / sprite.size.width
        sprite.setScale(scale)
        
        sprite.zPosition = 10

        container.addChild(sprite)

        return container
    }
}
