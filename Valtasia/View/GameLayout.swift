//
//  GameLayout.swift
//  Valtasia
//
//  Created by Tufan Cakir on 22.03.26.
//

import SwiftUI

struct GameLayout<Content: View>: View {

    @EnvironmentObject var appModel: AppModel
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    private let headerHeight: CGFloat = 100
    private let footerHeight: CGFloat = 100

    var body: some View {

        ZStack {

            content
                .padding(.top, headerHeight)
                .padding(.bottom, footerHeight)
                .zIndex(999)

            VStack(spacing: 0) {

                GameHeaderView()
                    .frame(height: headerHeight)

                Spacer()

                CustomFooter(selectedTab: $appModel.selectedTab)
                    .frame(height: footerHeight)
            }
        }
    }
}
