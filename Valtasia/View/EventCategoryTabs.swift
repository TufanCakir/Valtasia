//
//  EventCategoryTabs.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct EventCategoryTabs: View {

    @EnvironmentObject var eventManager: EventManager
    @Binding var selected: EventCategory

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(visibleCategories, id: \.self) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
        }
    }

    // ⭐ Nur Kategorien mit Events anzeigen
    private var visibleCategories: [EventCategory] {
        EventCategory.allCases.filter { cat in
            !eventManager.events(for: cat).isEmpty
        }
    }

    func tab(_ cat: EventCategory) -> some View {

        let isSelected = selected == cat

        return Button {
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selected = cat
            }
        } label: {

            Text(eventManager.title(for: cat))
                .font(.subheadline.weight(.bold))
                .foregroundStyle(isSelected ? .black : .white.opacity(0.85))
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background {
                    Capsule()
                        .fill(
                            isSelected
                                ? LinearGradient(
                                    colors: [.cyan, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                                : LinearGradient(
                                    colors: [
                                        Color.white.opacity(0.06),
                                        Color.white.opacity(0.04),
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        )
                }
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected
                                ? Color.white.opacity(0.25)
                                : Color.white.opacity(0.08),
                            lineWidth: isSelected ? 1.5 : 1
                        )
                }
                .scaleEffect(isSelected ? 1.06 : 1.0)
                .shadow(
                    color: isSelected
                        ? .cyan.opacity(0.35)
                        : .clear,
                    radius: 10
                )
        }
        .buttonStyle(.plain)
    }
}
