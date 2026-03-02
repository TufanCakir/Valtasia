//
//  HomeWorldMapView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 27.02.26.
//

import SwiftUI

struct HomeWorldMapView: View {

    @EnvironmentObject var appModel: AppModel

    let world: World
    let onSelectLevel: (String) -> Void

    @State private var focusedNode: WorldNode?
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

extension HomeWorldMapView {

    fileprivate var backgroundView: some View {

        Image(world.background)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
    }
}

extension HomeWorldMapView {

    fileprivate func connectionLines(in geo: GeometryProxy) -> some View {
        ZStack {
            ForEach(world.worldNodes) { node in
                ForEach(node.connectsTo, id: \.self) { targetId in
                    if let target = world.worldNodes.first(where: {
                        $0.id == targetId
                    }),
                        node.id != target.id
                    {
                        Path { path in
                            path.move(to: point(for: node, in: geo))
                            path.addLine(to: point(for: target, in: geo))
                        }
                        .stroke(
                            LinearGradient(
                                colors: [
                                    .cyan.opacity(0.8),
                                    .purple.opacity(0.7),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            style: StrokeStyle(
                                lineWidth: 4,
                                lineCap: .round
                            )
                        )
                        .shadow(color: .cyan.opacity(0.6), radius: 6)
                    }
                }
            }
        }
    }

    fileprivate func point(
        for node: WorldNode,
        in geo: GeometryProxy
    ) -> CGPoint {

        let horizontalPadding: CGFloat = 60  // ← hier justieren
        let usableWidth = geo.size.width - (horizontalPadding * 2)

        return CGPoint(
            x: horizontalPadding + (usableWidth * node.positionX),
            y: geo.size.height * node.positionY
        )
    }
}

extension HomeWorldMapView {

    fileprivate func nodesView(in geo: GeometryProxy) -> some View {
        ForEach(world.worldNodes) { node in
            let isUnlocked = isNodeUnlocked(node)
            let isFocused = (focusedNode?.id == node.id)

            let scale: CGFloat = {
                if isFocused {
                    return pulse ? 1.25 : 1.15
                } else {
                    return 1.0
                }
            }()

            let shadowColor: Color = isFocused ? .cyan.opacity(0.7) : .clear

            WorldNodeView(
                node: node,
                geo: geo,
                isUnlocked: isUnlocked,
                isFocused: isFocused,
                onTap: {
                    withAnimation(.spring()) {
                        focusedNode = isFocused ? nil : node
                    }
                },
                onSelectLevel: onSelectLevel
            )
            .opacity(isUnlocked ? 1 : 0.4)
            .position(point(for: node, in: geo))
            .scaleEffect(scale)
            .shadow(color: shadowColor, radius: 15)
        }
    }
}

extension HomeWorldMapView {

    fileprivate func isNodeUnlocked(
        _ node: WorldNode
    ) -> Bool {

        // ⭐ erstes Node immer frei
        if node.id == world.worldNodes.first?.id {
            return true
        }

        // ⭐ alle vorherigen Nodes die dahin connecten
        let previousNodes =
            world.worldNodes.filter {
                $0.connectsTo.contains(node.id)
            }

        // ⭐ mindestens EINER fertig reicht
        return previousNodes.contains {

            appModel.progress
                .clearedAllLevels(of: $0)
        }
    }
}
