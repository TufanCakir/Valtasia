    //
    //  GameScene.swift
    //  Valtasia
    //
    //  Created by Tufan Cakir on 27.02.26.
    //

    import SpriteKit

    class GameScene: SKScene {
        
        var world: World?

        var appModel: AppModel?  // ⭐ HIER

        // MARK: Managers

        var teamManager: TeamManager?

        // MARK: Data

        var cracks: [Crack] = []
        var enemies: [Enemy] = []

        var enemyNode: SKNode?
        var currentEnemy: EnemyInstance?

        var characterCards: [CharacterCardNode] = []
        var hpBarBG: SKShapeNode?
        var hpBarFill: SKShapeNode?
        var expBarFill: SKShapeNode?
        var currentExp: CGFloat = 0
        private let crackCount = 6
        var onVictory: (() -> Void)?

        var levelId: String?

        // MARK: Scene Start

        override func didMove(to view: SKView) {

            setupBackground()
            addChild(crackLayer)

            loadCracks()
            spawnRandomEnemy()

            setupUI()
            spawnTeamPortraits()

            spawnCracks(count: crackCount)
        }

        private func setupBackground() {

            let backgroundName =
                world?.battleBackground ?? "ocean_bg"

            let bg = SKSpriteNode(imageNamed: backgroundName)

            bg.position = CGPoint(
                x: size.width / 2,
                y: size.height / 2
            )

            bg.size = size
            bg.zPosition = -100

            addChild(bg)
        }

        private func setupUI() {

            setupHPBar()
        }

        func setupHPBar() {

            hpBarBG?.removeFromParent()

            let width: CGFloat = 240
            let height: CGFloat = 16

            let bg = SKShapeNode(
                rectOf: CGSize(width: width, height: height),
                cornerRadius: 6
            )
            bg.fillColor = .darkGray
            bg.strokeColor = .clear
            bg.position = CGPoint(x: size.width / 2, y: size.height - 120)
            bg.zPosition = 50
            addChild(bg)

            let fill = SKShapeNode(
                rectOf: CGSize(width: width, height: height),
                cornerRadius: 6
            )
            fill.fillColor = .green
            fill.strokeColor = .clear
            fill.position = .zero
            fill.zPosition = 51
            bg.addChild(fill)

            hpBarBG = bg
            hpBarFill = fill
        }

        func updateHPBar() {

            guard let enemy = currentEnemy,
                let fill = hpBarFill
            else { return }

            let maxHP = max(1, enemy.base.hp)

            let ratio =
                CGFloat(enemy.hp) / CGFloat(maxHP)

            fill.xScale = max(0, min(1, ratio))

            fill.position.x =
                -(240 * (1 - fill.xScale)) / 2
        }

        // MARK: Load JSON
        func loadCracks() {

            do {
                cracks = try JSONLoader.load("cracks")
                print("✅ Loaded Cracks:", cracks.count)
            } catch {
                print("❌ Crack JSON ERROR:")
                print(error.localizedDescription)
            }
        }

        // MARK: Enemy
        func spawnRandomEnemy() {

            guard
                let enemy = randomEnemy()
            else { return }

            currentEnemy =
                EnemyInstance(base: enemy)

            enemyNode?.removeFromParent()

            let node =
                EnemyShapeFactory.makeNode(from: enemy)

            node.position =
                CGPoint(
                    x: size.width / 2,
                    y: size.height - 200
                )

            node.zPosition = 10

            addChild(node)

            enemyNode = node

            updateHPBar()
        }

        private func weightedRandomCrack() -> Crack? {

            guard !cracks.isEmpty else {
                print("❌ No cracks loaded")
                return nil
            }

            let totalWeight =
                cracks.reduce(0) { $0 + $1.spawn.weight }

            guard totalWeight > 0 else {
                return cracks.randomElement()
            }

            let random =
                Int.random(in: 0..<totalWeight)

            var current = 0

            for crack in cracks {

                current += crack.spawn.weight

                if random < current {
                    return crack
                }
            }

            return cracks.randomElement()
        }

        private func randomEnemy() -> Enemy? {

        if let event = EventRuntime.shared.activeEvent,
        let levelId = event.bossLevelId {

        print("EVENT LEVEL:",levelId)

        if let level =
        EventDatabase.shared.level(id: levelId){

        guard let enemyId =
        level.enemies.randomElement()
        else { return nil }

        return EnemyDatabase.shared.enemy(id: enemyId)

        }

        }

        // NORMAL GAME

        guard
        let levelId,
        let level = appModel?.level(for: levelId),
        let enemyId = level.enemies.randomElement()
        else {

        print("Enemy spawn failed")
        return nil
        }

        return EnemyDatabase.shared.enemy(id: enemyId)
        }

        // MARK: Portraits
        func spawnTeamPortraits() {

            guard let team =
            teamManager?.activeTeam else { return }

            characterCards.forEach{$0.removeFromParent()}
            characterCards.removeAll()

            var x: CGFloat = 100

            for owned in team {

                let card =
                CharacterCardNode(owned: owned)

                card.position =
                CGPoint(x: x, y: 100)

                card.zPosition = 100

                addChild(card)

                characterCards.append(card)

                x += 110
            }
        }

        // MARK: Crack
        private let crackLayer = SKNode()

        func spawnCracks(count: Int) {

            crackLayer.removeAllChildren()

            let minY = size.height * 0.35
            let maxY = size.height * 0.65

            let spacing =
                size.width / CGFloat(count + 1)

            for index in 0..<count {

                guard
                    let crack =
                        weightedRandomCrack()
                else { continue }

                let node =
                    CrackFactory.createNode(from: crack)

                node.name = crack.id

                let x =
                    spacing * CGFloat(index + 1)

                let y =
                    CGFloat.random(in: minY...maxY)

                node.position = CGPoint(x: x, y: y)

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
            
            let line = SKShapeNode(path: path)
            
            line.lineWidth = crack.shape.lineWidth
            line.strokeColor = crack.energyColor.skColor
            line.glowWidth = crack.visual.glow
            line.blendMode = .add
            line.alpha = 0.9
            line.glowWidth = crack.visual.glow
            line.run(.sequence([
                .scale(to: 1.05, duration: 0.05),
                .scale(to: 1.0, duration: 0.05)
            ]))
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
        override func touchesBegan(
            _ touches: Set<UITouch>,
            with event: UIEvent?
        ) {

            guard let touch = touches.first else { return }

            let location = touch.location(in: self)

            let nodesTouched = nodes(at: location)

            for node in nodesTouched {

                var target: SKNode? = node

                // ⭐ Container finden
                while target != nil {

                    // ⭐ SKILL BUTTON
                    if let name = target?.name,
                       name.starts(with: "skill_") {

                        let skillId =
                        name.replacingOccurrences(
                            of: "skill_",
                            with: ""
                        )

                        useSkill(skillId)
                        return
                    }

                    // ⭐ CRACK
                    if let id = target?.name,
                       let crack =
                        cracks.first(where: { $0.id == id }) {

                        attack(with: crack)
                        return
                    }

                    target = target?.parent
                }
            }
        }

        // MARK: Combat
        func attack(with crack: Crack) {

            guard let enemy = currentEnemy,
                  let enemyNode,
                  let team = teamManager?.activeTeam
            else { return }

            var totalDamage = 0

            for (index, owned) in team.enumerated() {

                guard index < characterCards.count else { continue }

                let portrait = characterCards[index]

                // ⭐ Damage basiert auf Character Stats
                let baseAttack = owned.base.stats.attack
                let energyPower = owned.base.stats.energyPower

                guard let skill =
                owned.base.skills.randomElement()
                else { continue }

                let damage = Int(

                Double(baseAttack) * skill.multiplier

                + Double(energyPower) * 0.4
                )

                totalDamage += damage
                
                if let particle = skill.particle {

                    spawnSkillEffect(
                        named: particle,
                        color: skill.color,
                        from: portrait.position,
                        to: enemyNode.position
                    )
                }

                // ⭐ Energy Line pro Character
                spawnEnergyLine(
                    crack: crack,
                    from: portrait.position,
                    to: enemyNode.position
                )

                // Kleine Delay Animation für Flow
                portrait.run(.sequence([
                    .scale(to: 1.1, duration: 0.05),
                    .scale(to: 1.0, duration: 0.05)
                ]))
            }

            // ⭐ Gesamtschaden anwenden
            enemy.hp = max(0, enemy.hp - totalDamage)

            enemyNode.run(
                .sequence([
                    .moveBy(x: -10, y: 0, duration: 0.05),
                    .moveBy(x: 20, y: 0, duration: 0.05),
                    .moveBy(x: -10, y: 0, duration: 0.05),
                ])
            )

            updateHPBar()

            spawnEnergyEffect(
                crack: crack,
                at: enemyNode.position
            )

            if enemy.hp <= 0 {
                enemyDefeated()
            }

            crackLayer.removeAllChildren()
            spawnCracks(count: crackCount)
        }

        func enemyDefeated() {
            
            if EventRuntime.shared.activeEvent?.type == "boss" {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .eventBossCleared,
                        object: nil
                    )
                }
            }

            CoinManager.shared.add(50)
            CrystalManager.shared.add(1)

            if let team = teamManager?.activeTeam {

                for owned in team {

                    owned.addEXP(30)
                }
            }

            characterCards.forEach {

                $0.updateEXP()
            }

            enemyNode?.run(
                .sequence([
                    .fadeOut(withDuration: 0.3),
                    .removeFromParent(),
                ])
            )

            run(
                .sequence([
                    .wait(forDuration: 0.5),
                    .run { [weak self] in
                        self?.onVictory?()
                    },
                ])
            )
        }

        func useSkill(_ skillId:String){

        guard let enemy = currentEnemy,
              let enemyNode
        else { return }

        for card in characterCards {

            guard let skill =
            card.owned.base.skills.first(
                where:{$0.id == skillId}
            )
            else { continue }

            let damage = Int(

            Double(card.owned.base.stats.attack)
            * skill.multiplier
            )

            enemy.hp -= damage

            if let particle = skill.particle {

                spawnSkillEffect(
                    named: particle,
                    color: skill.color,
                    from: card.position,
                    to: enemyNode.position
                )
            }
        }

        updateHPBar()

        if enemy.hp <= 0 {

        enemyDefeated()

        }
        }
        
        func spawnSkillEffect(
            named: String,
            color: String?,
            from start: CGPoint,
            to end: CGPoint
        ) {

            guard let emitter = SKEmitterNode(fileNamed: named)
            else { return }

            // ⭐ Startposition beim Character
            emitter.position = start
            emitter.zPosition = 20
            emitter.targetNode = self   // wichtig für korrekte Koordinaten

            if let color {
                emitter.particleColor = color.skColor
                emitter.particleColorBlendFactor = 1
            }

            addChild(emitter)

            // ⭐ Fluganimation zum Gegner
            let move = SKAction.move(to: end, duration: 0.3)
            move.timingMode = .easeOut

            let stopEmission = SKAction.run {
                emitter.particleBirthRate = 0
            }

            let wait = SKAction.wait(forDuration: 0.5)
            let remove = SKAction.removeFromParent()

            emitter.run(.sequence([
                move,
                stopEmission,
                wait,
                remove
            ]))
        }
        
        // MARK: FX
        func spawnEnergyEffect(
            crack: Crack,
            at position: CGPoint
        ) {

            guard
                let emitter =
                    SKEmitterNode(fileNamed: "EnergyParticle")
            else { return }

            emitter.position = position

            emitter.particleColor =
                crack.energyColor.skColor

            emitter.particleColorBlendFactor = 1

            if crack.energyColor == .chaosBlack {

                emitter.particleAlpha = 0.8
            }

            if crack.energyColor == .rainbow {

                let sequence = SKAction.sequence([

                    .run { emitter.particleColor = .red },
                    .wait(forDuration: 0.12),

                    .run { emitter.particleColor = .orange },
                    .wait(forDuration: 0.12),

                    .run { emitter.particleColor = .yellow },
                    .wait(forDuration: 0.12),

                    .run { emitter.particleColor = .green },
                    .wait(forDuration: 0.12),

                    .run { emitter.particleColor = .blue },
                    .wait(forDuration: 0.12),

                    .run { emitter.particleColor = .purple },
                    .wait(forDuration: 0.12),
                ])

                emitter.run(
                    .repeat(sequence, count: 4)
                )
            }

            addChild(emitter)

            emitter.run(
                .sequence([
                    .wait(forDuration: 1),
                    .removeFromParent(),
                ])
            )
        }
    }

    extension Notification.Name {
        static let eventBossCleared =
        Notification.Name("eventBossCleared")
    }

