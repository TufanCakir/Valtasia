//
//  SummonCategoryTabs.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct SummonCategoryTabs: View {

    @EnvironmentObject var appModel: AppModel

    let categories: [SummonCategory]
    @Binding var selected: String

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(visibleCategories) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
        }
        .animation(.easeInOut(duration: 0.2), value: selected)
    }

    private var visibleCategories: [SummonCategory] {
        switch appModel.tutorialState {
        case .fight, .summon:
            return categories.filter { $0.id == "tutorial" }
        case .done, .none:
            return categories.filter { $0.id != "tutorial" }
        }
    }

    func tab(_ cat: SummonCategory) -> some View {

        let isSelected = selected == cat.id

        return Button {
            selected = cat.id
        } label: {

            Text(cat.title)
                .font(.subheadline.bold())
                .foregroundStyle(
                    isSelected
                        ? .white
                        : Color.white.opacity(0.6)
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background {
                    Capsule()
                        .fill(
                            isSelected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: theme.borderGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                : AnyShapeStyle(Color.black.opacity(0.25))
                        )
                }
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected
                                ? AnyShapeStyle(
                                    LinearGradient(
                                        colors: theme.borderGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                : AnyShapeStyle(Color.white.opacity(0.15)),
                            lineWidth: 1
                        )
                }
        }
        .buttonStyle(.plain)
        .padding(.top, 30)
    }
}
