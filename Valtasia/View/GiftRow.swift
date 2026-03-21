//
//  GiftRow.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import SwiftUI

struct GiftRow: View {
    
    @EnvironmentObject var appModel: AppModel
    
    let gift: Gift
    let action: () -> Void
    
    private var claimed: Bool {
        GiftClaimManager.shared.isClaimed(gift.id)
    }
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }
    
    var body: some View {
        HStack(spacing: 16) {
            
            iconView
            
            VStack(alignment: .leading, spacing: 4) {
                Text(gift.title ?? "Unknown")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.white)
                
                Text("\(gift.amount ?? 0)")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundStyle(.white)
            }
            
            Spacer()
            
            claimButton
        }
        .padding()
        .background(cardBackground)
        .overlay(borderOverlay)
        .contentShape(Rectangle())
    }
    
    private var iconView: some View {
        ZStack {
            
            Image(gift.icon ?? "icon_gem")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
        }
    }
    
    private var claimButton: some View {
        
        Button {
            action()
            GiftClaimManager.shared.claim(gift.id)
        } label: {
            Text(claimed ? "✓" : "CLAIM")
                .font(.system(size: 10, weight: .bold))
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .disabled(claimed)
        .opacity(claimed ? 0.5 : 1)
    }
    
    private var cardBackground: some View {
        RoundedRectangle(cornerRadius: 18)
            .fill(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
    }
    
    private var borderOverlay: some View {
        RoundedRectangle(cornerRadius: 18)
            .stroke(
                LinearGradient(
                    colors: theme.headerGradient,
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                lineWidth: 3
            )
    }
}

#Preview {
    GiftView()
}
