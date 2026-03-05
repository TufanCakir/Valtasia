//
//  EventWorldView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventWorldView: View {

    var body: some View {

        ZStack {

            Image("water_bg")
                .resizable()
                .ignoresSafeArea()

            VStack {

                Text("Boss Raid")
                    .font(.largeTitle.bold())

                NavigationLink("Enter Raid") {
                    EventBossRaidView()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
