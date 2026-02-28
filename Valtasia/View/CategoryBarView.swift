//
//  CategoryBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct ShopCategoryBar: View {

    let categories: [ShopCategory]
    @Binding var selected: String

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 16) {

                ForEach(categories) { cat in
                    categoryButton(cat)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
        }
        .background(backgroundContainer)
        .shadow(color: .black.opacity(0.4), radius: 10)
    }
}

// MARK: BUTTON
extension ShopCategoryBar {

    func categoryButton(_ cat: ShopCategory) -> some View {

        let isSelected = selected == cat.id

        return Button {

            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selected = cat.id
            }

        } label: {

            HStack(spacing: 8) {

                Image(systemName: cat.icon)
                    .font(.caption.bold())

                Text(cat.id.capitalized)
                    .font(.caption.bold())
            }
            .foregroundStyle(
                isSelected
                    ? Color.white
                    : Color.white.opacity(0.7)
            )
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(buttonBackground(isSelected))
        }
        .buttonStyle(.plain)
    }
}

// MARK: BACKGROUND BUTTON

extension ShopCategoryBar {

    @ViewBuilder
    func buttonBackground(_ selected: Bool) -> some View {

        Capsule()
            .fill(
                selected
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: [.purple, .blue],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    : AnyShapeStyle(.ultraThinMaterial)
            )
            .overlay(

                Capsule()
                    .stroke(
                        selected
                            ? LinearGradient(
                                colors: [
                                    .cyan.opacity(0.8),
                                    .purple.opacity(0.7),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                            : LinearGradient(
                                colors: [.white.opacity(0.15)],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                        lineWidth: 1
                    )
            )
    }
}

// MARK: CONTAINER BG

extension ShopCategoryBar {

    var backgroundContainer: some View {

        RoundedRectangle(cornerRadius: 24)
            .fill(.ultraThinMaterial)
            .overlay(

                RoundedRectangle(cornerRadius: 24)
                    .stroke(

                        LinearGradient(
                            colors: [
                                .cyan.opacity(0.5),
                                .purple.opacity(0.4),
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        ),

                        lineWidth: 1
                    )
            )
    }
}
