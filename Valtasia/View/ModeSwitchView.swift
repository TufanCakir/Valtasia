//
//  ModeSwitchView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.04.26.
//

import SwiftUI

struct ModeSwitchView: View {
    @EnvironmentObject var appModel: AppModel

    var body: some View {
        HStack {
            button("Island", .island)
            button("Corrupted", .corrupted)
        }
    }

    func button(_ title: String, _ mode: HomeMode) -> some View {
        Button {
            appModel.homeMode = mode
        } label: {
            Text(title)
        }
    }
}
