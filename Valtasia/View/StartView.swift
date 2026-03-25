//
//  StartView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 06.03.26.
//

import SwiftUI

struct StartView: View {

    @EnvironmentObject var appModel: AppModel
    @State private var animate = false

    var body: some View {
        ZStack {

            // MARK: BACKGROUND
            Image("bg_start")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {

                Spacer()

                // ⭐ LOGO
                Image("v_logo")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(animate ? 1 : 0.8)
                    .opacity(animate ? 1 : 0)
                    .animation(.easeOut(duration: 0.8), value: animate)

                Spacer()
            }
        }
        .contentShape(Rectangle())  // ⭐ wichtig für full tap area
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                appModel.appState = .story
            }
        }
        .onAppear {
            animate = true
        }
    }
}

#Preview {
    StartView()
        .environmentObject(AppModel())
}
