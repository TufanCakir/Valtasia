//
//  TeamManager.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI
import Combine

class TeamManager: ObservableObject {

    // ⭐ Alle Characters die Spieler besitzt
    @Published var ownedCharacters: [OwnedCharacter] = []

    // ⭐ Aktives Team (4 Slots)
    @Published var activeTeam: [OwnedCharacter] = []

    let maxTeamSize = 4


    // MARK: Add

    func addToTeam(_ character: OwnedCharacter) {

        guard activeTeam.count < maxTeamSize else { return }

        // doppelt verhindern
        guard !activeTeam.contains(where: {
            $0.id == character.id
        }) else { return }

        activeTeam.append(character)
    }

    // MARK: Remove

    func removeFromTeam(_ character: OwnedCharacter) {

        activeTeam.removeAll {

            $0.id == character.id
        }
    }

    // MARK: Check

    func isInTeam(_ character: OwnedCharacter) -> Bool {

        activeTeam.contains {

            $0.id == character.id
        }
    }
}
