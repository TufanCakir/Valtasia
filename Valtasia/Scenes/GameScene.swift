//
//  GameScene.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

class GameScene: SKScene {
    
    var world: World?
    
    var appModel: AppModel?   // ⭐ HIER

    // MARK: Managers

    var teamManager: TeamManager?

    // MARK: Data

    var cracks: [Crack] = []
    var enemies: [Enemy] = []

    var enemyNode: SKNode?
    var currentEnemy: EnemyInstance?
    
    var portraitNodes: [SKSpriteNode] = []
    var hpBarBG: SKShapeNode?
    var hpBarFill: SKShapeNode?
    var expBarFill: SKShapeNode?
    var currentExp: CGFloat = 0
    
    var onVictory: (() -> Void)?
    
    var levelId: String?
    
    // MARK: Scene Start

    override func didMove(to view: SKView) {

        if let world {

            let bg =
            SKSpriteNode(
                imageNamed: world.battleBackground
            )

            bg.position =
            CGPoint(
                x:size.width/2,
                y:size.height/2
            )

            bg.size = size

            bg.zPosition = -100

            addChild(bg)
        }

        addChild(crackLayer)   // ⭐ NUR HIER

        loadCracks()

        spawnRandomEnemy()

        setupHPBar()
        setupEXPBar()

        spawnTeamPortraits()
        run(.wait(forDuration: 0.05)) { [weak self] in
            self?.spawnCracks(count: 6)
        }
    }
    
    func setupHPBar() {

        hpBarBG?.removeFromParent()

        let width: CGFloat = 240
        let height: CGFloat = 16

        let bg = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 6)
        bg.fillColor = .darkGray
        bg.strokeColor = .clear
        bg.position = CGPoint(x: size.width/2, y: size.height - 120)
        bg.zPosition = 50
        addChild(bg)

        let fill = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 6)
        fill.fillColor = .green
        fill.strokeColor = .clear
        fill.position = .zero
        fill.zPosition = 51
        bg.addChild(fill)

        hpBarBG = bg
        hpBarFill = fill
    }
    
    func setupEXPBar() {

        let width: CGFloat = 240
        let height: CGFloat = 12

        let bg = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 6)
        bg.fillColor = .darkGray
        bg.strokeColor = .clear
        bg.position = CGPoint(x: size.width/2, y: 50)
        bg.zPosition = 50
        addChild(bg)

        let fill = SKShapeNode(rectOf: CGSize(width: width, height: height), cornerRadius: 6)
        fill.fillColor = .cyan
        fill.strokeColor = .clear
        fill.position = .zero
        fill.xScale = 0
        bg.addChild(fill)

        expBarFill = fill
    }
    
    func updateHPBar() {

        guard let enemy = currentEnemy,
              let fill = hpBarFill
        else { return }

        let maxHP = max(1, enemy.base.hp)   // ✅ statt enemy.base.stats.hp
        let ratio = CGFloat(enemy.hp) / CGFloat(maxHP)

        fill.xScale = max(0, min(1, ratio))
    }

    // MARK: Load JSON

    func loadCracks() {

        do {
            cracks = try JSONLoader.load("cracks")
            print("Loaded Cracks:", cracks.count)
        } catch {
            print(error)
        }
    }

    // MARK: Enemy
    func spawnRandomEnemy() {

        guard
            let levelId,
            let level = appModel?.level(for: levelId)
        else {
            print("Level not found")
            return
        }

        print("Level enemies:", level.enemies)

        guard let enemyId = level.enemies.randomElement() else {
            print("No enemyId")
            return
        }

        print("Chosen enemyId:", enemyId)

        guard let enemy =
            EnemyDatabase.shared.enemy(id: enemyId)
        else {
            print("Enemy not found in database")
            return
        }

        print("Enemy FOUND:", enemy.id)

        currentEnemy = EnemyInstance(base: enemy)

        enemyNode?.removeFromParent()

        let node = EnemyShapeFactory.makeNode(from: enemy)

        node.position = CGPoint(
            x: size.width / 2,
            y: size.height - 200
        )

        node.zPosition = 10

        addChild(node)

        enemyNode = node

        updateHPBar()
    }
    
    // MARK: Portraits

    func spawnTeamPortraits() {

        guard let team =
            teamManager?.activeTeam
        else { return }

        portraitNodes.removeAll()

        var x: CGFloat = 100

        for owned in team {

            let character = owned.base

            guard let sprite =
                character.defaultSkin?.sprite
            else { continue }

            let portrait =
            SKSpriteNode(imageNamed: sprite)

            portrait.size =
            CGSize(width: 90, height: 90)

            portrait.position =
            CGPoint(x: x, y: 90)

            portrait.zPosition = 100

            portraitNodes.append(portrait)

            addChild(portrait)

            x += 110
        }
    }

    // MARK: Crack
    private let crackLayer = SKNode()

    func spawnCracks(count: Int) {

        crackLayer.removeAllChildren()

        // Schutz gegen ungültige Scene Größe
        let minX: CGFloat = 100
        let maxX = max(minX + 1, size.width - 100)

        let minY = size.height * 0.35
        let maxY = max(minY + 1, size.height * 0.65)

        guard maxX > minX, maxY > minY else {
            print("Scene size too small for crack spawn")
            return
        }

        for _ in 0..<count {

            guard let crack = cracks.randomElement()
            else { continue }

            let node = CrackFactory.createNode(from: crack)
            node.name = crack.id

            node.position = CGPoint(
                x: CGFloat.random(in: minX...maxX),
                y: CGFloat.random(in: minY...maxY)
            )

            node.userData = ["used": false]

            crackLayer.addChild(node)
        }
    }

    // MARK: Energy Line

    func spawnEnergyLine(
        crack: Crack,
        from start: CGPoint,
        to end: CGPoint
    ) {

        let path = CGMutablePath()

        path.move(to: start)

        let segments =
        crack.shape.segments

        for i in 1...segments {

            let t =
            CGFloat(i) / CGFloat(segments)

            let x =
            start.x + (end.x - start.x) * t

            let baseY =
            start.y + (end.y - start.y) * t

            let jaggedness = crack.shape.jaggedness

            let randomY =
            CGFloat.random(
                in: -jaggedness...jaggedness
            )

            path.addLine(
                to: CGPoint(
                    x: x,
                    y: baseY + randomY
                )
            )
        }

        let line =
        SKShapeNode(path: path)

        line.lineWidth =
        crack.shape.lineWidth

        line.strokeColor = .cyan

        addChild(line)

        line.run(
            .sequence([
                .wait(forDuration: 0.4),
                .fadeOut(withDuration: 0.2),
                .removeFromParent()
            ])
        )
    }

    // MARK: Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        for node in nodes(at: location) {

            guard let shape = node as? SKShapeNode,
                  let id = shape.name,
                  let crack = cracks.first(where: { $0.id == id }),
                  let used = shape.userData?["used"] as? Bool,
                  used == false
            else { continue }

            // markieren als benutzt
            shape.userData?["used"] = true
            shape.alpha = 0.3

            attack(with: crack)
        }
    }
    
    // MARK: Combat
    func attack(with crack: Crack) {

        guard let enemy = currentEnemy,
              let enemyNode,
              let portrait = portraitNodes.first
        else { return }

        let damage = Int(100 * crack.damageMultiplier)

        enemy.hp = max(0, enemy.hp - damage)

        updateHPBar()

        // EXP
        currentExp += 0.1
        expBarFill?.xScale = min(1, currentExp)

        spawnEnergyLine(
            crack: crack,
            from: portrait.position,
            to: enemyNode.position
        )

        spawnEnergyEffect(
            crack: crack,
            at: enemyNode.position
        )

        if enemy.hp <= 0 {
            enemyDefeated()
        }
    }
    
    func enemyDefeated() {

        // ⭐ Coins Reward
        DispatchQueue.main.async {

        CoinManager.shared.add(50)
        CrystalManager.shared.add(1)

        PlayerProgressManager.shared.addEXP(30)

        }
        enemyNode?.run(
            .sequence([
                .fadeOut(withDuration: 0.3),
                .removeFromParent()
            ])
        )

        run(.sequence([
            .wait(forDuration: 0.5),
            .run { [weak self] in
                self?.onVictory?()
            }
        ]))
    }

    // MARK: FX

    func spawnEnergyEffect(
        crack: Crack,
        at position: CGPoint
    ) {

        guard let emitter =
        SKEmitterNode(
            fileNamed: "EnergyParticle"
        )
        else { return }

        emitter.position = position

        switch crack.energyColor {

        case .arcaneBlue:
            emitter.particleColor = .blue

        case .gold:
            emitter.particleColor = .yellow

        case .crimson:
            emitter.particleColor = .red

        case .violet:
            emitter.particleColor = .purple
        }

        addChild(emitter)

        emitter.run(
            .sequence([
                .wait(forDuration: 1),
                .removeFromParent()
            ])
        )
    }
}

