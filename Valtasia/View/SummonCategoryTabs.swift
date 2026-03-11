//
//  SummonCategoryTabs.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct SummonCategoryTabs: View {

    @EnvironmentObject var appModel: AppModel  // 👈 neu

    let categories: [SummonCategory]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(visibleCategories) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
        }
    }

    private var visibleCategories: [SummonCategory] {
        switch appModel.tutorialState {

        case .fight, .summon:
            // Nur Tutorial anzeigen
            return categories.filter { $0.id == "tutorial" }

        case .done, .none:
            // Tutorial ausblenden
            return categories.filter { $0.id != "tutorial" }
        }
    }

    func tab(_ cat: SummonCategory) -> some View {
        Button {
            withAnimation(.spring()) {
                selected = cat.id
            }
        } label: {
            Text(cat.title)
                .font(.subheadline.bold())
                .foregroundStyle(selected == cat.id ? .black : .white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background {
                    Capsule().fill(
                        selected == cat.id
                            ? LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            : LinearGradient(
                                colors: [Color.white.opacity(0.08)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                    )
                }
        }
    }
}
