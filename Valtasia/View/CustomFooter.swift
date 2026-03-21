//
//  CustomFooter.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct CustomFooter: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @Binding var selectedTab: RootView.Tab
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }
    
    var body: some View {
        
        ZStack {
            
            Image(appModel.homeMode == .corrupted
                  ? "footer_green_bg"
                  : "footer_purple_bg")
            .resizable()
            .scaledToFill()
            .frame(height: 100)
            .clipped()
            
            .overlay(
                Rectangle()
                    .stroke(
                        LinearGradient(
                            colors: appModel.homeMode == .corrupted ? [.green] : [.indigo],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 3
                    )
            )
            
            HStack(spacing: 16) {
                footerButton(.home, "house.fill", "Home")
                footerButton(.team, "person.3.fill", "Team")
                footerButton(.summon, "sparkles", "Summon")
                footerButton(.shop, "cart.fill", "Shop")
                footerButton(.exchange, "arrow.2.circlepath", "Exchange")
            }
            .padding(.horizontal)
        }
        .frame(height: 100)
        .padding()
        .animation(.easeInOut(duration: 0.4), value: appModel.homeMode)
    }
}

extension CustomFooter {

    func footerButton(
        _ tab: RootView.Tab,
        _ icon: String,
        _ title: String
    ) -> some View {

        let selected = selectedTab == tab

        return Button {

            UIImpactFeedbackGenerator(style: .medium)
                .impactOccurred()

            withAnimation(
                .spring(
                    response: 0.4,
                    dampingFraction: 0.75
                )
            ) {
                selectedTab = tab
            }

        } label: {

            VStack(spacing: 6) {

                ZStack {

                    if selected {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        theme.borderGradient.last ?? .white,
                                        .clear
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 35
                                )
                            )
                            .frame(width: 50, height: 50)
                    }

                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(
                            selected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: theme.borderGradient,
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                : AnyShapeStyle(Color.white.opacity(0.6))
                        )
                }

                Text(title)
                    .font(.caption2.bold())
                    .foregroundStyle(
                        selected
                            ? Color.white
                            : Color.white.opacity(0.6)
                    )
            }
            .frame(maxWidth: .infinity)
            .scaleEffect(selected ? 1.1 : 1)
        }
        .buttonStyle(.plain)
    }
}

