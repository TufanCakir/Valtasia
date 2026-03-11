//
//  TutorialBattleViewModel.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import Combine
import Foundation

final class TutorialBattleViewModel: ObservableObject {

    @Published private(set) var battle: TutorialBattle?
    @Published private(set) var stepIndex: Int = 0

    init() {
        loadTutorial()  // ⭐ DAS FEHLT

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidAttack),
            name: .tutorialPlayerDidAttack,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerDidUseSkill),
            name: .tutorialPlayerDidUseSkill,
            object: nil
        )
    }

    func finishImmediately() {
        guard let steps = battle?.steps else { return }
        stepIndex = steps.count - 1
    }

    private func loadTutorial() {
        do {
            battle = try JSONLoader.load("intro_battle")
            print("✅ Tutorial geladen")
        } catch {
            print("❌ Tutorial JSON Fehler:", error.localizedDescription)
        }
    }

    @objc private func playerDidAttack() {
        guard currentStep?.action == "tap_enemy" else { return }
        next()
    }

    @objc private func playerDidUseSkill() {
        guard currentStep?.action == "use_skill" else { return }
        next()
    }

    var currentStep: TutorialStep? {
        guard
            let steps = battle?.steps,
            steps.indices.contains(stepIndex)
        else { return nil }

        return steps[stepIndex]
    }

    func next() {
        stepIndex += 1
    }

    var isFinished: Bool {
        currentStep?.type == .finish
    }
}
