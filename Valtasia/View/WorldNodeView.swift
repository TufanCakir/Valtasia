//
//  WorldNodeView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct WorldNodeView: View {
    
    @EnvironmentObject var appModel: AppModel
    
    let node: WorldNode
    let geo: GeometryProxy
    let isUnlocked: Bool
    let isFocused: Bool
    let onTap: () -> Void
    let onSelectLevel: (String) -> Void
    
    var body: some View {
        
        ZStack {
            
            Button(action: {
                guard isUnlocked else { return }
                onTap()
            }) {
                
                Image(node.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 140, height: 140)
                    .opacity(isUnlocked ? 1 : 0.4)
                    .scaleEffect(isFocused ? 1.1 : 1.0)
                    .animation(.spring(), value: isFocused)
                    .overlay {
                        if !isUnlocked {
                            lockOverlay
                        }
                    }
            }
            .zIndex(0)
            
            if isFocused {
                levelButtons
                    .offset(y: -0)
                    .zIndex(10)
            }
        }
    }
    
    private var lockOverlay: some View {
        Image(systemName: "lock.fill")
            .foregroundStyle(.white)
            .padding(8)
            .background(
                Circle()
                    .fill(.black.opacity(0.6))
            )
    }
    
    private var levelButtons: some View {
        
        HStack(spacing: 18) {
            
            ForEach(node.levels) { level in
                
                let unlocked = isLevelUnlocked(level)
                
                Button {
                    guard unlocked else { return }
                    onSelectLevel(level.id)
                } label: {
                    
                    Circle()
                        .fill(unlocked ? .white : .gray.opacity(0.4))
                        .frame(width: 50, height: 50)
                        .overlay(
                            Text(level.id.replacingOccurrences(of: "level_", with: ""))
                                .foregroundStyle(.black)
                        )
                        .overlay {
                            if !unlocked {
                                Image(systemName: "lock.fill")
                                    .foregroundStyle(.white)
                            }
                        }
                        .shadow(radius: 8)
                }
            }
        }
    }
    
    private func isLevelUnlocked(_ level: Level) -> Bool {
        
        guard let index = node.levels.firstIndex(where: { $0.id == level.id }) else {
            return false
        }
        
        if index == 0 { return true }
        
        let previous = node.levels[index - 1]
        
        return appModel.progress.clearedLevels.contains(previous.id)
    }
}
