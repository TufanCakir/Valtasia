//
//  StartView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import SwiftUI

struct StartView: View {

    @EnvironmentObject var appModel: AppModel  // ← wichtig

    var body: some View {
        ZStack {

            Image("bg_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 16) {

                Text("Valtasia")
                    .font(.system(size: 42, weight: .heavy))
                    .foregroundStyle(.white)
                    .shadow(radius: 10)

                Text("Tap anywhere to start")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .padding()
            }
            .padding()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            appModel.switchToGame()
        }
    }
}

#Preview {
    StartView()
}
