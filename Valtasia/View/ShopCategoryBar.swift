//
//  CategoryBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct ShopCategoryBar: View {
    
    @EnvironmentObject var appModel: AppModel

    let categories: [ShopCategory]
    @Binding var selected: String
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 14) {

                ForEach(categories) { cat in
                    categoryButton(cat)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
        }
        .background(backgroundContainer)
        .shadow(color: .black.opacity(0.45), radius: 12, y: 6)
    }
}

// MARK: - BUTTON
extension ShopCategoryBar {

    func categoryButton(_ cat: ShopCategory) -> some View {

        let isSelected = selected == cat.id
        let color = cat.color.themeColor

        return Button {

            withAnimation(.spring(response: 0.32, dampingFraction: 0.78)) {
                selected = cat.id
            }

        } label: {

            HStack(spacing: 8) {

                Text(cat.id.capitalized)
                    .font(.caption.weight(.semibold))
            }
            .foregroundStyle(
                isSelected ? .white : .white.opacity(0.65)
            )
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(buttonBackground(isSelected, color))
            .scaleEffect(isSelected ? 1.06 : 1.0)
            .shadow(
                color: isSelected ? color.opacity(0.45) : .clear,
                radius: isSelected ? 10 : 0
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - BUTTON BG
extension ShopCategoryBar {

    @ViewBuilder
    func buttonBackground(
        _ selected: Bool,
        _ color: Color
    ) -> some View {

        Capsule()
            .fill(
                selected
                    ? AnyShapeStyle(
                        LinearGradient(
                            colors: theme.headerGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    : AnyShapeStyle(Color.white.opacity(0.05))
            )
            .overlay(
                Capsule()
                    .stroke(
                        selected
                            ? color
                            : Color.white,
                        lineWidth: selected ? 2 : 1
                    )
            )
    }
}

// MARK: - CONTAINER BG
extension ShopCategoryBar {

    var backgroundContainer: some View {

        RoundedRectangle(cornerRadius: 26)
            .fill(.ultraThinMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(
                        LinearGradient(
                            colors: theme.headerGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            .padding(.horizontal, 6)
    }
}
