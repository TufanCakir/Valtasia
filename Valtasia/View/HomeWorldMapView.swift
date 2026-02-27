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

    var body: some View {
        GeometryReader { geo in
            ZStack {
                backgroundView
                connectionLines(in: geo)
                nodesView(in: geo)
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
                        node.id < target.id
                    {
                        Path { path in
                            path.move(to: point(for: node, in: geo))
                            path.addLine(to: point(for: target, in: geo))
                        }
                        .stroke(.white.opacity(0.6), lineWidth: 4)
                    }
                }
            }
        }
    }

    fileprivate func point(for node: WorldNode, in geo: GeometryProxy)
        -> CGPoint
    {
        CGPoint(
            x: geo.size.width * node.positionX,
            y: geo.size.height * node.positionY
        )
    }
}

extension HomeWorldMapView {

    fileprivate func nodesView(in geo: GeometryProxy) -> some View {
        ForEach(world.worldNodes) { node in
            WorldNodeView(
                node: node,
                geo: geo,
                isUnlocked: isNodeUnlocked(node),
                isFocused: focusedNode?.id == node.id,
                onTap: {
                    withAnimation(.spring()) {
                        focusedNode = focusedNode?.id == node.id ? nil : node
                    }
                },
                onSelectLevel: onSelectLevel
            )
            .position(point(for: node, in: geo))
        }
    }
}

extension HomeWorldMapView {

    fileprivate func isNodeUnlocked(_ node: WorldNode) -> Bool {
        if node.id == world.worldNodes.first?.id {
            return true
        }

        if let previous = world.worldNodes.first(where: {
            $0.connectsTo.contains(node.id)
        }) {
            return appModel.progress
                .clearedAllLevels(of: previous)
        }

        return false
    }
}
