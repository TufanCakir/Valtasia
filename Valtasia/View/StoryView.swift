//
//  StoryView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 20.03.26.
//

import SwiftUI

struct StoryView: View {

    @EnvironmentObject var appModel: AppModel
    @State private var currentPage = 0
    
    func isUnlocked(_ chapter: StoryChapter) -> Bool {
        guard let world = appModel.worlds.first(where: {
            $0.id == chapter.worldId
        }) else { return false }

        return appModel.progress.isWorldUnlocked(world)
    }
    
    func storyPage(_ chapter: StoryChapter) -> some View {
        
        let unlocked = isUnlocked(chapter)
        
        return ZStack {
            
            // 👇 DAS sorgt für echtes Zentrieren
            VStack {
                Spacer()
                
                cardContent(chapter, unlocked: unlocked)
                
                Spacer()
            }
        }
        
        func cardContent(_ chapter: StoryChapter, unlocked: Bool) -> some View {
            
            VStack(spacing: 0) {
                
                Image(chapter.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 250, height: 300)
                    .clipped()
                
                VStack(spacing: 12) {
                    
                    Text(chapter.title)
                        .font(.title2.bold())
                        .foregroundStyle(.white)
                    
                    Text(chapter.description)
                        .font(.caption)
                        .foregroundStyle(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button {
                        if unlocked {
                            openChapter(chapter)
                        }
                    } label: {
                        Text(unlocked ? "Start" : "🔒 Locked")
                            .font(.headline.bold())
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(
                                LinearGradient(
                                    colors: unlocked
                                        ? theme.borderGradient
                                        : [Color.gray, Color.black],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                    }
                }
                .padding(16)
                .frame(width: 260)
                .background(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.8),
                            (theme.headerGradient.last ?? .black).opacity(0.4)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 26))
            
            .overlay(
                RoundedRectangle(cornerRadius: 26)
                    .stroke(
                        LinearGradient(
                            colors: theme.borderGradient,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 3
                    )
            )
            
            .overlay {
                if !unlocked {
                    Image(systemName: "lock.fill")
                        .font(.title)
                        .foregroundStyle(.white)
                        .padding()
                        .background(
                            (theme.borderGradient.last ?? .black).opacity(0.6)
                        )
                        .clipShape(Circle())
                        .offset(y: -150)
                }
            }
            
            .shadow(
                color: (theme.borderGradient.last ?? .white).opacity(0.4),
                radius: 25
            )
            .opacity(unlocked ? 1 : 0.55)
            .saturation(unlocked ? 1 : 0)
            .blur(radius: unlocked ? 0 : 2)
        }
    }
    
    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    private var modeSwitch: some View {
        HStack {
            modeButton("Island", .island)
            modeButton("Corrupted", .corrupted)
        }
        .padding()
        .background(
            LinearGradient(
                colors: theme.headerGradient.map { $0.opacity(0.9) },
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 2
                )
        )
    }

    func modeButton(_ title: String, _ mode: HomeMode) -> some View {
        let active = appModel.homeMode == mode

        return Button {
            withAnimation(.spring()) {
                appModel.homeMode = mode
            }
        } label: {
            Text(title)
                .font(.caption.bold())
                .foregroundStyle(active ? .white : .white.opacity(0.6))
                .padding(.horizontal, 14)
                .padding(.vertical, 6)
                .background(
                    active
                    ? LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    : nil
                )
                .clipShape(Capsule())
        }
    }
    
    var visibleChapters: [StoryChapter] {

        let validWorldIds: Set<String> = {
            if appModel.homeMode == .corrupted {
                return Set(appModel.corruptedWorlds.map { $0.id })
            } else {
                return Set(appModel.worlds.map { $0.id })
            }
        }()

        return appModel.storyChapters.filter { chapter in

            let correctType =
                appModel.homeMode == .corrupted
                ? chapter.type == .corrupted
                : chapter.type == .island

            return correctType && validWorldIds.contains(chapter.worldId)
        }
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .leading,
                endPoint: .trailing
            )
            .ignoresSafeArea()
            
            VStack {
                
                GameHeaderView()
                                
                modeSwitch   // 💥 HIER IST DER SWITCH
                
                TabView(selection: $currentPage) {
                    ForEach(Array(visibleChapters.enumerated()), id: \.element.id) { index, chapter in
                        storyPage(chapter)
                            .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .always))
            }
        }
        .onChange(of: appModel.homeMode) { _, _ in
            currentPage = 0
        }
    }


    // MARK: - Action
    func openChapter(_ chapter: StoryChapter) {

        let isCorrupted = chapter.type == .corrupted

        print("👉 openChapter tapped")
        print("👉 chapter.type:", chapter.type)
        print("👉 BEFORE homeMode:", appModel.homeMode)

        withAnimation(.spring()) {
            appModel.homeMode = isCorrupted ? .corrupted : .island
        }

        print("👉 AFTER homeMode:", appModel.homeMode)

        if let world = appModel.worlds.first(where: {
            $0.id == chapter.worldId
        }) {
            appModel.selectedWorld = world
            print("👉 selectedWorld set:", world.id)
        }

        print("👉 switching to HOME")

        appModel.appState = .home
    }
    
    // MARK: - UI

    func storyCard(_ chapter: StoryChapter) -> some View {
        ZStack(alignment: .bottomLeading) {

            Image(chapter.image)
                .resizable()
                .scaledToFill()
                .clipped()

            LinearGradient(
                colors: theme.headerGradient,
                startPoint: .leading,
                endPoint: .trailing
            )

            VStack(alignment: .leading) {
                Text(chapter.title)
                    .font(.headline)
                    .foregroundStyle(.white)

                Text(chapter.description)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.7))
            }
            .padding()
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(
                    LinearGradient(
                        colors: theme.headerGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    lineWidth: 3
                )
        )
        .shadow(color: .cyan.opacity(0.4), radius: 10)
    }
}

#Preview {
    StoryView()
        .environmentObject(AppModel())
}
