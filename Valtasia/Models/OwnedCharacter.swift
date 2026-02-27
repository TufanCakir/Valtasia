//
//  OwnedCharacter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import Foundation

struct OwnedCharacter: Identifiable, Hashable {

    let id = UUID()           // ⭐ EINDEUTIG
    let base: Character       // Referenz auf Daten
}
