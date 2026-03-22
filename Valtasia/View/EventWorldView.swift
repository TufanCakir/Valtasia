//
//  EventWorldView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventWorldView: View {

    @EnvironmentObject var appModel: AppModel

    private var runtime = EventRuntime.shared

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        ZStack {

            background

            VStack(spacing: 24) {

                header

                bossPreview

                Spacer()

                actionButton

                Spacer()
            }
            .padding()
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension EventWorldView {

    private var background: some View {

        let bg = runtime.activeEventWorld?.background ?? "water_bg"

        return ZStack {
            Image(bg)
                .resizable()
                .scaledToFill()

            LinearGradient(
                colors: [
                    .black.opacity(0.3),
                    .black.opacity(0.85),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
        .ignoresSafeArea()
    }
}

extension EventWorldView {

    private var header: some View {

        let event = runtime.activeEvent

        return VStack(spacing: 6) {

            Text(event?.title ?? "Boss Raid")
                .font(.title.bold())
                .foregroundStyle(.white)

            Text(event?.description ?? "")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
    }
}

extension EventWorldView {

    private var bossPreview: some View {

        let bossId = runtime.activeEvent?.bossEnemy ?? "unknown"

        return VStack(spacing: 12) {

            Image(bossId)  // 👈 DAS IST DER KEY!
                .resizable()
                .scaledToFit()
                .frame(height: 160)

            Text(bossId.replacingOccurrences(of: "_", with: " ").capitalized)
                .font(.headline)
                .foregroundStyle(.white)
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension EventWorldView {

    private var actionButton: some View {

        NavigationLink {

            if let levelId = runtime.activeEventWorld?.bossLevelId {
                GameContainerView(
                    teamManager: appModel.teamManager,
                    levelId: levelId
                )
                .environmentObject(appModel)
            }

        } label: {

            Text("Enter Raid")
                .font(.headline.bold())
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundStyle(.white)
                .clipShape(Capsule())
        }
        .padding(.horizontal, 40)
    }
}
