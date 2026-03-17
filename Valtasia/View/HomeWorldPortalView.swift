//
//  HomeWorldPortalView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 17.03.26.
//

import SwiftUI

struct HomeWorldPortalView: View {
    
    @EnvironmentObject var appModel: AppModel
    
    let world: PortalWorld
    let onSelectLevel: (String) -> Void
    
    @State private var focusedNode: PortalNode?
    @State private var pulse = false
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                connectionLines(in: geo)
                nodesView(in: geo)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever()) {
                    pulse.toggle()
                }
            }
        }
    }
}

extension HomeWorldPortalView {
    
    fileprivate var backgroundView: some View {
        Image(world.background)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
    
    fileprivate func connectionLines(in geo: GeometryProxy) -> some View {
        ZStack {
            ForEach(world.worldNodes) { node in
                ForEach(node.connectsTo, id: \.self) { targetId in
                    
                    if let target = world.worldNodes.first(where: { $0.id == targetId }) {
                        
                        Path { path in
                            path.move(to: point(for: node, in: geo))
                            path.addLine(to: point(for: target, in: geo))
                        }
                        .stroke(
                            LinearGradient(
                                colors: [.cyan, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(lineWidth: 3, lineCap: .round)
                        )
                        .shadow(color: .cyan.opacity(0.8), radius: 10)
                    }
                }
            }
        }
    }
    
    fileprivate func point(for node: PortalNode, in geo: GeometryProxy) -> CGPoint {
        let padding: CGFloat = 60
        let width = geo.size.width - (padding * 2)
        
        return CGPoint(
            x: padding + width * node.positionX,
            y: geo.size.height * node.positionY
        )
    }
    
    fileprivate func nodesView(in geo: GeometryProxy) -> some View {
        
        ForEach(world.worldNodes) { node in
            
            let isUnlocked = isNodeUnlocked(node)
            let isFocused = focusedNode?.id == node.id
            
            let scale: CGFloat = isFocused
                ? (pulse ? 1.25 : 1.15)
                : 1.0
            
            ZStack {
                
                if isFocused {
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [.cyan.opacity(0.6), .clear],
                                center: .center,
                                startRadius: 10,
                                endRadius: 120
                            )
                        )
                        .frame(width: 160, height: 160)
                }
                
                Image(node.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .opacity(isUnlocked ? 1 : 0.35)
                    .overlay {
                        ZStack {
                            if !isUnlocked {
                                lockOverlay
                            }
                            
                            if isFocused {
                                levelButtons(node)
                                    .offset(y: 40)
                            }
                        }
                    }
            }
            .position(point(for: node, in: geo))
            .scaleEffect(scale)
            .onTapGesture {
                guard isUnlocked else { return }
                
                withAnimation(.spring()) {
                    focusedNode = isFocused ? nil : node
                }
            }
        }
    }
    
    private var lockOverlay: some View {
        Image(systemName: "lock.fill")
            .foregroundStyle(.white)
            .padding()
            .background(Circle().fill(.black.opacity(0.7)))
    }
    
    private func levelButtons(_ node: PortalNode) -> some View {
        
        HStack(spacing: 16) {
            
            ForEach(node.levels) { level in
                
                let unlocked = isLevelUnlocked(level, in: node)
                
                Button {
                    guard unlocked else { return }
                    onSelectLevel(level.id)
                } label: {
                    
                    Circle()
                        .fill(
                            unlocked
                            ? LinearGradient(colors: [.cyan, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
                            : LinearGradient(colors: [.gray, .black], startPoint: .topLeading, endPoint: .bottomTrailing)
                        )
                        .frame(width: 34, height: 34)
                        .overlay(
                            Text(level.id.replacingOccurrences(of: "level_", with: ""))
                                .font(.caption.bold())
                                .foregroundStyle(.white)
                        )
                }
            }
        }
    }
    
    fileprivate func isNodeUnlocked(_ node: PortalNode) -> Bool {
        
        if node.id == world.worldNodes.first?.id {
            return true
        }
        
        let previous = world.worldNodes.filter {
            $0.connectsTo.contains(node.id)
        }
        
        return previous.contains {
            appModel.progress.clearedAllLevels(ofId: $0.id, in: appModel.worlds)
        }
    }
    
    private func isLevelUnlocked(_ level: Level, in node: PortalNode) -> Bool {
        
        guard let index = node.levels.firstIndex(where: { $0.id == level.id }) else {
            return false
        }
        
        if index == 0 { return true }
        
        let previous = node.levels[index - 1]
        
        return appModel.progress.clearedLevels.contains(previous.id)
    }
}
