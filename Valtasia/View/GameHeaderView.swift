//
//  GameHeaderView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct GameHeaderView: View {

    @ObservedObject
    var coins = CoinManager.shared

    @ObservedObject
    var crystals = CrystalManager.shared

    @ObservedObject
    var progress = PlayerProgressManager.shared

    var body: some View {

        VStack(spacing: 8) {

            HStack {

                levelView

                Spacer()

                currencyView
            }
        }
        .padding(.horizontal)
        .padding(.top,8)
        .background(.ultraThinMaterial)
    }
}

private extension GameHeaderView {

    var levelView: some View {

        VStack(alignment:.leading,spacing:4){

            Text("LV \(progress.level)")
                .font(.headline)
                .foregroundStyle(.white)

            GeometryReader { geo in

                ZStack(alignment:.leading){

                    Capsule()
                        .fill(.black.opacity(0.5))

                    Capsule()
                        .fill(.green)
                        .frame(
                            width:
                                geo.size.width *
                                CGFloat(progress.exp)
                                /
                                CGFloat(progress.requiredEXP)
                        )
                }
            }
            .frame(width:140,height:10)
        }
    }
}

private extension GameHeaderView {

    var currencyView: some View {

        HStack(spacing:14){

            currencyBubble(
                icon:"diamond.fill",
                color:.cyan,
                value:crystals.crystals
            )

            currencyBubble(
                icon:"bitcoinsign.circle.fill",
                color:.yellow,
                value:coins.coins
            )
        }
    }

    func currencyBubble(
        icon:String,
        color:Color,
        value:Int
    )-> some View{

        HStack(spacing:6){

            Image(systemName:icon)
                .foregroundStyle(color)

            Text("\(value)")
                .foregroundStyle(.white)
                .fontWeight(.bold)

        }
        .padding(.horizontal,10)
        .padding(.vertical,6)
        .background(
            Capsule()
                .fill(.black.opacity(0.6))
        )
    }
}
