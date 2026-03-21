//
//  VictoryView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct VictoryView: View {
    
    @EnvironmentObject var appModel: AppModel

    var onContinue: () -> Void
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            // MARK: Background Blur Overlay

            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 28) {
                
                Text("VICTORY")
                    .font(.largeTitle.bold())
                    .tracking(2)
                    .foregroundStyle(.white)
                
                Text("Enemy Defeated!")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.75))
                
                Divider()
                    .background(.white.opacity(0.2))
                
                Button {
                    onContinue()
                } label: {
                    
                    Text("Continue")
                        .font(.caption.bold())
                        .padding(.horizontal, 26)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                colors: theme.headerGradient,
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                        )
                    }
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24)
                            .stroke(
                                LinearGradient(
                                    colors: theme.borderGradient,
                                    startPoint: .top,
                                    endPoint: .bottom
                                ),
                                lineWidth: 2
                            )
                    )
            )
            .shadow(color: .cyan.opacity(0.35), radius: 20)
            .padding(.horizontal, 32)
        }
    }

