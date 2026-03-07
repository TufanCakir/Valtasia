//
//  SummonCategoryTabs.swift
//  Valtasia
//
//  Created by Tufan Cakir on 07.03.26.
//

import SwiftUI

struct SummonCategoryTabs: View {

    let categories: [SummonCategory]
    @Binding var selected: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 14) {
                ForEach(categories) { cat in
                    tab(cat)
                }
            }
            .padding(.horizontal)
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
