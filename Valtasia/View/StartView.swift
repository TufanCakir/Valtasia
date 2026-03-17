//
//  StartView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import SwiftUI

struct StartView: View {

    @EnvironmentObject var appModel: AppModel  

    var body: some View {
        ZStack {

            Image("bg_1")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack(spacing: 16) {

                Text("Valtasia")
                    .font(.system(size: 50, weight: .heavy))
                    .foregroundStyle(.indigo)
                    .shadow(color: .black, radius: 10)
            }
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
