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
                ForEach(EventCategory.allCases, id: \.self) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
        }
    }

    func tab(_ cat: EventCategory) -> some View {
        Button {
            withAnimation(.spring()) {
                selected = cat
            }
        } label: {
            Text(eventManager.title(for: cat))  // ⭐ JSON TITLE
                .font(.subheadline.bold())
                .foregroundStyle(selected == cat ? .black : .white)
                .padding(.horizontal, 18)
                .padding(.vertical, 10)
                .background {
                    Capsule().fill(
                        LinearGradient(
                            colors: selected == cat
                                ? [.cyan, .purple]
                                : [
                                    Color.white.opacity(0.08),
                                    Color.white.opacity(0.08),
                                ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                }
        }
    }
}
