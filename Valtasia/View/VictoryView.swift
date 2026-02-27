//
//  VictoryView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct VictoryView: View {

    var onContinue: () -> Void

    var body: some View {

        ZStack {

            Color.black.opacity(0.6)
                .ignoresSafeArea()

            VStack(spacing: 20) {

                Text("Victory")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Enemy Defeated!")
                    .foregroundColor(.white)

                Button("Continue") {
                    onContinue()
                }
                .padding()
                .frame(width: 200)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(12)
            }
            .padding(40)
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
    }
}
