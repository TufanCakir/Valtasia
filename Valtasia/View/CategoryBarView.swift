//
//  CategoryBarView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct ShopCategoryBar: View {

    @Binding var selected: ShopCategory

    var body: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            HStack(spacing: 16) {

                ForEach(ShopCategory.allCases, id: \.self) { cat in

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

        let isSelected = selected == cat

        return Button {

            withAnimation(
                .spring(
                    response: 0.35,
                    dampingFraction: 0.8
                )
            ) {

                selected = cat
            }

        } label: {

            HStack(spacing: 8) {

                Image(systemName: icon(for: cat))
                    .font(.caption.bold())

                Text(title(for: cat))
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
            .shadow(
                color: isSelected
                    ? .cyan.opacity(0.35)
                    : .clear,
                radius: 8
            )
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
func title(for cat: ShopCategory) -> String {
    switch cat {
    case .realMoney: return "Crystals"
    case .coins: return "Coins"
    case .crystals: return "Exchange"
    case .bundles: return "Bundles"
    case .special: return "Special"
    }
}

func icon(for cat: ShopCategory) -> String {
    switch cat {
    case .realMoney: return "diamond.fill"
    case .coins: return "circle.fill"
    case .crystals: return "arrow.left.arrow.right"
    case .bundles: return "shippingbox.fill"
    case .special: return "sparkles"
    }
}
