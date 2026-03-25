//
//  EventCategoryTabs.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct EventCategoryTabs: View {

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var eventManager: EventManager
    @Binding var selected: EventCategory

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(visibleCategories, id: \.self) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .animation(.easeInOut(duration: 0.2), value: selected)
    }

    private var visibleCategories: [EventCategory] {
        EventCategory.allCases.filter {
            !eventManager.events(for: $0, mode: .island).isEmpty
        }
    }

    func tab(_ cat: EventCategory) -> some View {

        let isSelected = selected == cat

        let fillStyle: AnyShapeStyle =
            isSelected
            ? AnyShapeStyle(
                LinearGradient(
                    colors: theme.borderGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            : AnyShapeStyle(Color.black.opacity(0.25))

        return Button {
            selected = cat
        } label: {

            Text(eventManager.title(for: cat))
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
                        .fill(fillStyle)
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
                .scaleEffect(isSelected ? 1.04 : 1)
        }
        .buttonStyle(.plain)
    }
}
