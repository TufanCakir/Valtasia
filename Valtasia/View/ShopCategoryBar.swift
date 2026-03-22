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

            HStack(spacing: 10) {
                ForEach(categories) { cat in
                    categoryButton(cat)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .background(backgroundContainer)
        .animation(.easeInOut(duration: 0.2), value: selected)
        .padding()
    }
}

extension ShopCategoryBar {

    func categoryButton(_ cat: ShopCategory) -> some View {

        let isSelected = selected == cat.id

        return Button {
            selected = cat.id
        } label: {

            Text(cat.id.capitalized)
                .font(.caption.bold())
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
                .scaleEffect(isSelected ? 1.04 : 1)
        }
        .buttonStyle(.plain)
    }
}

extension ShopCategoryBar {

    var backgroundContainer: some View {

        RoundedRectangle(cornerRadius: 20)
            .fill(Color.black.opacity(0.25))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .padding(.horizontal, 6)
    }
}
