//
//  CharacterDetailView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct CharacterDetailView: View {
    
    @EnvironmentObject var appModel: AppModel

    let owned: OwnedCharacter
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        
        ScrollView {
            
            VStack(spacing: 20) {
                
                headerSection
                
                starsSection
                
                statsSection
                
                skillsSection
                
            }
            .padding(.bottom, 30)
        }
        
        .background(
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
                    
    var headerSection: some View {
        
        VStack(spacing: 16) {
            
            ZStack {
                
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                accentColor.opacity(0.7),
                                .clear
                            ],
                            center: .center,
                            startRadius: 20,
                            endRadius: 180
                        )
                    )
                    .blur(radius: 20)
                
                Circle()
                    .stroke(
                        LinearGradient(
                            colors: [accentColor, .white.opacity(0.5)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 190, height: 190)
                
                Image(owned.base.sprite)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 170)
                    .shadow(color: accentColor.opacity(0.9), radius: 25)
            }
            
            Text(owned.base.name)
                .font(.system(size: 26, weight: .heavy))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, accentColor],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            
            Text("Lv \(owned.level)")
                .font(.caption.bold())
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(
                        colors: [accentColor.opacity(0.8), .black.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(Capsule())
            
            ProgressView(
                value: Double(owned.exp),
                total: Double(owned.requiredEXP)
            )
            .tint(accentColor)
            .scaleEffect(y: 1.6)
            .padding(.horizontal, 40)
        }
    }
    
    var accentColor: Color {
        owned.isCorrupted ? .red : owned.base.rarity.color
    }
    
    var starsSection: some View {
        
        VStack(spacing: 6) {
            
            HStack(spacing: 4) {
                ForEach(0..<owned.stars, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .foregroundStyle(owned.starGradient)
                        .shadow(color: owned.starColor.opacity(0.7), radius: 6)
                }
            }
            
            if owned.isCorrupted {
                Text("CORRUPTED")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        LinearGradient(
                            colors: [.red, .black],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(Capsule())
            }
        }
    }
    
    var statsSection: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Stats")
                .font(.headline.bold())
            
            statRow("HP", owned.base.stats.hp)
            statRow("Attack", owned.base.stats.attack)
            statRow("Energy", owned.base.stats.energyPower)
            statRow("Speed", owned.base.stats.attackSpeed)
        }
        .padding()
    }
    
    var skillsSection: some View {
        
        VStack(alignment: .leading, spacing: 14) {
            
            Text("Skills")
                .font(.headline.bold())
            
            ForEach(owned.base.skills, id: \.id) {
                skillRow($0)
            }
        }
        .padding()
    }
    
    func statRow(_ name: String, _ value: some CustomStringConvertible) -> some View {
        
        HStack {
            Text(name)
                .foregroundStyle(.white.opacity(0.7))
            
            Spacer()
            
            Text(String(describing: value))
                .bold()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(accentColor.opacity(0.6))
                )
        )
    }
    
    func skillRow(_ skill: Skill) -> some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                Text(skill.name)
                    .bold()
                
                Spacer()
                
                Text(verbatim: "x\(String(format: "%.1f", skill.multiplier)) DMG")
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.6))
            }
            
            Text("x\(String(format: "%.1f", skill.multiplier)) DMG")
                .font(.caption)
                .foregroundStyle(accentColor)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(accentColor.opacity(0.6))
                )
        )
    }
}
