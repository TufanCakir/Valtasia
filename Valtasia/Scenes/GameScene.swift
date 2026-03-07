//
//  GameScene.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SpriteKit

class GameScene: SKScene {

    var world: World?
    var isTutorialMode: Bool = false
    var appModel: AppModel?  // ⭐ HIER

    // MARK: Managers

    var teamManager: TeamManager?

    // MARK: Data

    var cracks: [Crack] = []
    var enemies: [Enemy] = []

    var enemyNode: SKNode?
    var currentEnemy: EnemyInstance?
    private var skillButtons: [SkillButtonNode] = []

    var characterCards: [CharacterCardNode] = []
    var hpBarBG: SKShapeNode?
    var hpBarFill: SKShapeNode?
    var expBarFill: SKShapeNode?
    var currentExp: CGFloat = 0
    private let crackCount = 6
    var onVictory: (() -> Void)?
    private let hpBarWidth: CGFloat = 260
    var levelId: String?
    private var crackRefreshRunning = false
    private var attackLocked = false
    private var skillBarNode = SKNode()

    // MARK: Scene Start
    override func didMove(to view: SKView) {

        setupBackground()

        addChild(crackLayer)  // ⭐ FEHLT AKTUELL
        addChild(uiLayer)
        addChild(footerLayer)
        setupSkillBar()
        spawnFooterSkills()

        loadCracks()
        spawnRandomEnemy()

        setupUI()
        spawnTeamPortraits()

        setupTutorialListeners()  // ⭐ NEU
    }

    @objc private func tutorialTapEnemy() {
        guard let crackNode = crackLayer.children.randomElement(),
            let id = crackNode.name,
            let crack = cracks.first(where: { $0.id == id })
        else { return }

        attack(with: crack)
    }

    @objc private func tutorialUseSkill() {
        guard
            let skillId = teamManager?
                .activeTeam
                .first?
                .base
                .skills
                .first?
                .id
        else { return }

        useSkill(skillId)
    }

    private func setupTutorialListeners() {

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tutorialTapEnemy),
            name: .tutorialTapEnemy,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(tutorialUseSkill),
            name: .tutorialUseSkill,
            object: nil
        )
    }

    func setupSkillBar() {

        let barHeight: CGFloat = 110
        let sidePadding: CGFloat = 20
        let bottomPadding: CGFloat = 28

        let barWidth = size.width - sidePadding * 2

        skillBarNode.removeFromParent()
        skillBarNode = SKNode()
        skillBarNode.zPosition = 1

        let bg = SKShapeNode(
            rectOf: CGSize(width: barWidth, height: barHeight),
            cornerRadius: 22
        )

        bg.fillColor = .black.withAlphaComponent(0.55)
        bg.strokeColor = .white.withAlphaComponent(0.12)
        bg.lineWidth = 2

        bg.position = .zero
        skillBarNode.addChild(bg)

        skillBarNode.position = CGPoint(
            x: size.width / 2,
            y: barHeight / 2 + bottomPadding
        )

        footerLayer.addChild(skillBarNode)
    }

    func spawnFooterSkills() {

        skillButtons.forEach { $0.removeFromParent() }
        skillButtons.removeAll()

        guard let team = teamManager?.activeTeam else { return }
        let skills = team.flatMap { $0.base.skills }
        guard !skills.isEmpty else { return }

        let columns = 4
        let spacingX: CGFloat = 46
        let spacingY: CGFloat = 40

        let startX = -spacingX * 1.5
        let startY: CGFloat = 22

        for (i, skill) in skills.enumerated() {

            let col = i % columns
            let row = i / columns

            let button = SkillButtonNode(skill: skill)
            button.setScale(1)

            let x = startX + CGFloat(col) * spacingX
            let y = startY - CGFloat(row) * spacingY

            button.position = CGPoint(x: x, y: y)

            skillBarNode.addChild(button)
            skillButtons.append(button)
        }
    }

    private func setupBackground() {

        let backgroundName =
            EventRuntime.shared.activeEvent?.battleBackground
            ?? world?.battleBackground
            ?? "ocean_bg"

        let bg = SKSpriteNode(imageNamed: backgroundName)

        bg.position = CGPoint(
            x: size.width / 2,
            y: size.height / 2
        )

        bg.size = size
        bg.zPosition = -100
        bg.setScale(1.15)

        addChild(bg)
    }

    private func setupUI() {

        setupHPBar()
    }

    func setupHPBar() {

        hpBarBG?.removeFromParent()

        guard enemyNode != nil else { return }

        let container = SKNode()
        container.zPosition = 20000

        container.position = CGPoint(
            x: size.width / 2,
            y: size.height * 0.90  // vorher 0.88
        )

        let frame = SKShapeNode(
            rectOf: CGSize(width: hpBarWidth, height: 20),
            cornerRadius: 8
        )

        frame.fillColor = .darkGray
        frame.strokeColor = .white
        frame.lineWidth = 3

        container.addChild(frame)

        let fill = SKShapeNode(
            rectOf: CGSize(width: hpBarWidth - 6, height: 14),
            cornerRadius: 6
        )

        fill.fillColor = .green
        fill.strokeColor = .clear

        fill.position.x = -(hpBarWidth / 2) + (hpBarWidth - 6) / 2

        container.addChild(fill)

        uiLayer.addChild(container)

        hpBarBG = frame
        hpBarFill = fill
    }

    func updateHPBar() {

        guard let enemy = currentEnemy,
            let fill = hpBarFill
        else { return }

        let ratio = CGFloat(enemy.hp) / CGFloat(enemy.maxHP)

        let action = SKAction.scaleX(
            to: max(0, min(1, ratio)),
            duration: 0.18
        )

        action.timingMode = .easeOut

        fill.run(action)

        if ratio <= 0.3 {
            if fill.action(forKey: "pulse") == nil {
                let pulse = SKAction.sequence([
                    .fadeAlpha(to: 0.5, duration: 0.4),
                    .fadeAlpha(to: 1.0, duration: 0.4),
                ])
                fill.run(.repeatForever(pulse), withKey: "pulse")
            }
        } else {
            fill.removeAction(forKey: "pulse")
            fill.alpha = 1.0
        }

        if ratio > 0.6 {
            fill.fillColor = .green
        } else if ratio > 0.3 {
            fill.fillColor = .yellow
        } else {
            fill.fillColor = .red
        }

        fill.position.x = -((hpBarWidth - 6) * (1 - fill.xScale)) / 2
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

    private func determineEnemyLevel() -> Int {

        guard let world else { return 1 }

        // world_1 → 1
        // world_5 → 5
        if let number = Int(
            world.id.replacingOccurrences(of: "world_", with: "")
        ) {
            return number * 5  // ⭐ Skalierungsfaktor
        }

        return 1
    }

    // MARK: Enemy
    func spawnRandomEnemy() {

        guard let enemy = randomEnemy() else {
            print("❌ randomEnemy returned nil")
            return
        }

        print("✅ Spawning enemy:", enemy.id)

        currentEnemy = EnemyInstance(
            base: enemy,
            level: determineEnemyLevel()
        )

        enemyNode?.removeFromParent()

        let node =
            EnemyFactory.makeNode(from: enemy)

        node.position = CGPoint(
            x: size.width / 2,
            y: size.height * 0.78  // vorher 0.7
        )

        node.setScale(0.85)  // minimal größer wirkt näher an Kamera

        node.zPosition = 10

        addChild(node)

        let shadow = SKShapeNode(
            ellipseOf: CGSize(width: 180 * 0.85, height: 40 * 0.85)
        )
        shadow.fillColor = .black
        shadow.alpha = 0.25
        shadow.zPosition = 5
        shadow.position = CGPoint(x: node.position.x, y: node.position.y - 120)

        let float = SKAction.sequence([
            .moveBy(x: 0, y: 10, duration: 2),
            .moveBy(x: 0, y: -10, duration: 2),
        ])

        node.run(.repeatForever(float))

        node.addChild(shadow)
        shadow.position = CGPoint(x: 0, y: -120)

        node.alpha = 0.88
        if let spriteNode = node as? SKSpriteNode {
            spriteNode.color = .black
            spriteNode.colorBlendFactor = 0.1
        }

        enemyNode = node
        spawnPermanentConnections()
        setupHPBar()
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
            let levelId = event.bossLevelId
        {

            print("EVENT LEVEL:", levelId)

            if let level =
                EventDatabase.shared.level(id: levelId)
            {

                guard
                    let enemyId =
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

    func spawnPermanentConnections() {

        guard let enemyNode else { return }
        guard !cracks.isEmpty else { return }

        // ⭐⭐⭐ WICHTIG: alte Verbindungen entfernen
        crackLayer.removeAllChildren()
        crackLayer.setScale(0.95)
        let spacing: CGFloat = 0
        let totalWidth = spacing * CGFloat(characterCards.count - 1)
        let startOffset = -totalWidth / 2

        for (index, portrait) in characterCards.enumerated() {

            guard let crack = weightedRandomCrack() else { continue }

            let portraitHeight =
                portrait.calculateAccumulatedFrame().height

            let start = CGPoint(
                x: portrait.position.x,
                y: portrait.position.y + portraitHeight * 0.5 + 20
            )

            let end = CGPoint(
                x: enemyNode.position.x
                    + startOffset
                    + CGFloat(index) * spacing,
                y: enemyNode.position.y + 100
            )

            spawnConnectionCracks(
                crack: crack,
                from: start,
                to: end,
                count: crackCount
            )
        }
    }

    // MARK: Portraits
    func spawnTeamPortraits() {

        guard let team = teamManager?.activeTeam else { return }

        characterCards.forEach { $0.removeFromParent() }
        characterCards.removeAll()

        let count = team.count
        guard count > 0 else { return }

        // ⭐ Scale abhängig von Teamgröße
        let scale = max(0.65, 1.0 - CGFloat(count) * 0.1)

        // ⭐ Abstand passt sich an
        let spacing: CGFloat = 110 * scale

        let totalWidth =
            spacing * CGFloat(count - 1)

        let startX =
            size.width / 2 - totalWidth / 2

        for (index, owned) in team.enumerated() {

            let card = CharacterCardNode(owned: owned)

            card.setScale(scale)

            let x =
                startX + CGFloat(index) * spacing

            card.position = CGPoint(
                x: x,
                y: size.height * 0.22  // vorher 0.12
            )

            card.zPosition = 100

            uiLayer.addChild(card)

            characterCards.append(card)
        }

        // ⭐⭐⭐ HIER NUR EINMAL
        spawnPermanentConnections()
    }

    func spawnConnectionCracks(
        crack: Crack,
        from start: CGPoint,
        to end: CGPoint,
        count: Int
    ) {

        let dx = end.x - start.x
        let dy = end.y - start.y
        let angle = atan2(dy, dx)

        for i in 1...count {

            let t = CGFloat(i) / CGFloat(count + 1)

            let x = start.x + dx * t
            let y = start.y + dy * t

            let node = CrackFactory.createNode(from: crack)

            node.name = crack.id

            node.position = CGPoint(x: x, y: y)

            node.zRotation = angle

            node.zPosition = 320

            // ⭐ WICHTIG:
            // verschiebt das Segment entlang seiner Richtung
            let halfLength = crack.shape.length / 2
            let offsetX = cos(angle) * halfLength
            let offsetY = sin(angle) * halfLength

            node.position = CGPoint(
                x: x - offsetX,
                y: y - offsetY
            )

            crackLayer.addChild(node)
        }
    }

    // MARK: Crack
    private let crackLayer: SKNode = {
        let node = SKNode()
        node.zPosition = 100
        return node
    }()

    func spawnCracks(count: Int) {

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
        path.addLine(to: end)

        let line = SKShapeNode(path: path)

        line.lineWidth = crack.shape.lineWidth
        line.strokeColor = crack.energyColor.skColor
        line.glowWidth = 12
        line.blendMode = .add
        line.alpha = 0.9
        line.zPosition = 15

        addChild(line)

        line.run(
            .sequence([
                .fadeOut(withDuration: 0.25),
                .removeFromParent(),
            ])
        )
    }

    private let uiLayer: SKNode = {
        let node = SKNode()
        node.zPosition = 10000
        return node
    }()

    // MARK: Touch
    override func touchesBegan(
        _ touches: Set<UITouch>,
        with event: UIEvent?
    ) {

        guard let touch = touches.first else { return }

        let location = touch.location(in: self)

        // ⭐ PRIORITY 1 – echte SkillButtons
        let uiNodes =
            uiLayer.nodes(at: location) + footerLayer.nodes(at: location)

        for node in uiNodes {
            if let skillButton =
                node.firstParent(of: SkillButtonNode.self)
            {

                if skillButton.canUse() {

                    skillButton.pressAnimation()

                    useSkill(skillButton.skill.id)

                    if let cd = skillButton.skill.cooldown {

                        skillButton.startCooldown(duration: cd)
                    }
                }
                return
            }
        }

        // ⭐ PRIORITY 2 – nur Crack Layer prüfen
        let crackNodes = crackLayer.nodes(at: location)

        for node in crackNodes {

            if let id = node.name,
                let crack = cracks.first(where: { $0.id == id })
            {

                attack(with: crack)
                return
            }
        }
    }

    func refreshCracks() {

        guard !crackRefreshRunning else { return }

        crackRefreshRunning = true

        run(
            .sequence([

                .wait(forDuration: 0.25),

                .run { [weak self] in

                    guard let self else { return }

                    self.crackLayer.removeAllChildren()

                    self.spawnPermanentConnections()

                    self.crackRefreshRunning = false
                },
            ])
        )
    }

    func spawnFloatingDamage(
        _ damage: Int,
        at position: CGPoint,
        color: SKColor = .white
    ) {

        let label = SKLabelNode(fontNamed: "AvenirNext-Bold")

        label.text = "\(damage)"
        label.fontSize = 26
        label.fontColor = color
        label.zPosition = 30000

        label.position = CGPoint(
            x: position.x + CGFloat.random(in: -25...25),
            y: position.y + 40
        )

        label.alpha = 0

        addChild(label)

        let appear = SKAction.fadeIn(withDuration: 0.05)

        let floatUp =
            SKAction.moveBy(
                x: CGFloat.random(in: -15...15),
                y: 80,
                duration: 0.8
            )

        floatUp.timingMode = .easeOut

        let scale = SKAction.sequence([

            .scale(to: 1.2, duration: 0.1),
            .scale(to: 1.0, duration: 0.2),
        ])

        let fade =
            SKAction.fadeOut(withDuration: 0.6)

        label.run(

            .sequence([

                appear,

                .group([
                    floatUp,
                    scale,
                ]),

                fade,
                .removeFromParent(),
            ])
        )
    }

    // MARK: Combat
    func attack(with crack: Crack) {

        if isTutorialMode {
            NotificationCenter.default.post(
                name: .tutorialPlayerDidAttack,
                object: nil
            )
        }

        guard !attackLocked else { return }

        attackLocked = true

        guard
            let enemyNode,
            let team = teamManager?.activeTeam
        else { return }

        var totalDamage = 0

        for (index, owned) in team.enumerated() {

            guard index < characterCards.count else { continue }

            let portrait = characterCards[index]

            let result =
                CombatCalculator.basicDamage(
                    owned: owned,
                    crack: crack
                )

            totalDamage += result.amount

            spawnFloatingDamage(
                result.amount,
                at: enemyNode.position,
                color: result.isCrit
                    ? .yellow
                    : crack.energyColor.skColor
            )

            animateAttack(
                portrait: portrait,
                crack: crack,
                index: index,
                teamCount: team.count,
                enemyNode: enemyNode
            )
        }

        applyDamage(totalDamage)

        run(.wait(forDuration: 0.15)) {

            self.attackLocked = false
        }
    }

    private func animateAttack(
        portrait: CharacterCardNode,
        crack: Crack,
        index: Int,
        teamCount: Int,
        enemyNode: SKNode
    ) {

        let spread: CGFloat = 50

        let offsetX =
            CGFloat(index - teamCount / 2) * spread

        let end = CGPoint(
            x: enemyNode.position.x + offsetX,
            y: enemyNode.position.y + 20
        )

        spawnEnergyLine(
            crack: crack,
            from: portrait.position,
            to: end
        )

        portrait.run(
            .sequence([
                .scale(to: 1.1, duration: 0.05),
                .scale(to: 1.0, duration: 0.05),
            ])
        )
    }

    private func applyDamage(
        _ damage: Int,
        crack: Crack? = nil  // ⭐ Default
    ) {
        guard let enemy = currentEnemy else { return }

        enemy.hp = max(0, enemy.hp - damage)

        updateHPBar()

        if let enemyNode, let crack {
            spawnEnergyEffect(
                crack: crack,
                at: enemyNode.position
            )
        }

        refreshCracks()

        if enemy.hp <= 0 {
            enemyDefeated()
        }
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

        let coins =
            Int(Double(50) * EventManager.shared.coinMultiplier())

        CoinManager.shared.add(coins)

        let crystals =
            Int(Double(1) * EventManager.shared.crystalMultiplier())

        CrystalManager.shared.add(crystals)

        if let team = teamManager?.activeTeam {

            let multiplier =
                EventManager.shared.expMultiplier()

            for owned in team {

                let exp = Int(Double(30) * multiplier)

                owned.addEXP(exp)
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

    private let footerLayer: SKNode = {
        let node = SKNode()
        node.zPosition = 20000
        return node
    }()

    func useSkill(_ skillId: String) {

        if isTutorialMode {
            NotificationCenter.default.post(
                name: .tutorialPlayerDidUseSkill,
                object: nil
            )
        }

        guard !attackLocked else { return }
        attackLocked = true

        guard
            let enemyNode
        else {
            attackLocked = false
            return
        }

        for card in characterCards {

            guard
                let skill = card.owned.base.skills.first(
                    where: { $0.id == skillId }
                )
            else { continue }

            let result = CombatCalculator.skillDamage(
                owned: card.owned,
                skill: skill
            )

            applyDamage(result.amount)

            spawnFloatingDamage(
                result.amount,
                at: enemyNode.position,
                color: result.isCrit ? .yellow : .cyan
            )

            if let particle = skill.particle {
                spawnSkillEffect(
                    named: particle,
                    color: skill.color,
                    from: card.position,
                    to: enemyNode.position
                )
            }

            break
        }

        // ⭐ Unlock NACH Impact
        run(.wait(forDuration: 0.25)) {
            self.attackLocked = false
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
        emitter.targetNode = self  // wichtig für korrekte Koordinaten

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

        emitter.run(
            .sequence([
                move,
                stopEmission,
                wait,
                remove,
            ])
        )
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

extension SKNode {

    func firstParent<T: SKNode>(
        of type: T.Type
    ) -> T? {

        var node: SKNode? = self

        while let current = node {

            if let match = current as? T {
                return match
            }

            node = current.parent
        }

        return nil
    }
}

extension Notification.Name {
    static let eventBossCleared =
        Notification.Name("eventBossCleared")
}

extension Notification.Name {
    static let tutorialTapEnemy = Notification.Name("tutorialTapEnemy")
    static let tutorialUseSkill = Notification.Name("tutorialUseSkill")
}

extension Notification.Name {
    static let tutorialPlayerDidAttack =
        Notification.Name("tutorialPlayerDidAttack")

    static let tutorialPlayerDidUseSkill =
        Notification.Name("tutorialPlayerDidUseSkill")
}
