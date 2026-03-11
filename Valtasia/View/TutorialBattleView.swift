//
//  TutorialBattleView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct TutorialBattleView: View {

    let teamManager: TeamManager
    let onFinished: () -> Void

    @StateObject private var vm = TutorialBattleViewModel()

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            VStack(spacing: 30) {

                Spacer()

                if let step = vm.currentStep {

                    switch step.type {

                    case .dialog:
                        dialogBox(step)

                    case .action:
                        actionHint(step)

                    case .finish:
                        finishView
                    }
                }

                Spacer()
            }
            .padding()
        }
        .onChange(of: vm.isFinished) { oldValue, newValue in
            if newValue { onFinished() }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                vm.finishImmediately()
            } label: {
                Text("Skip")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding()
                    .background(.black)
                    .clipShape(Capsule())
            }
        }
    }
}

extension TutorialBattleView {

    func dialogBox(_ step: TutorialStep) -> some View {
        VStack(spacing: 16) {

            Text(step.speaker ?? "")
                .font(.headline)
                .foregroundStyle(.cyan)

            Text(step.text ?? "")
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)

            Button("Weiter") {
                vm.next()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 10)
            .background(.cyan)
            .clipShape(Capsule())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension TutorialBattleView {

    func actionHint(_ step: TutorialStep) -> some View {
        VStack(spacing: 12) {

            Text("Aktion erforderlich")
                .font(.headline)
                .foregroundStyle(.yellow)

            Text(hintText(for: step.action))
                .foregroundStyle(.white.opacity(0.8))
                .multilineTextAlignment(.center)

            Text("Führe die Aktion im Kampf aus…")
                .font(.subheadline)
                .foregroundStyle(.yellow)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(.yellow)
                .clipShape(Capsule())
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    func triggerTutorialAction(_ action: String?) {

        switch action {
        case "tap_enemy":
            NotificationCenter.default.post(
                name: .tutorialTapEnemy,
                object: nil
            )

        case "use_skill":
            NotificationCenter.default.post(
                name: .tutorialUseSkill,
                object: nil
            )

        default:
            break
        }
    }

    func hintText(for action: String?) -> String {
        switch action {
        case "tap_enemy": return "Tippe auf einen Gegner"
        case "use_skill": return "Benutze eine Fähigkeit"
        default: return "Führe die Aktion aus"
        }
    }
}

extension TutorialBattleView {

    var finishView: some View {
        VStack(spacing: 16) {
            Text("Tutorial abgeschlossen")
                .font(.title.bold())
                .foregroundStyle(.green)
        }
    }
}
