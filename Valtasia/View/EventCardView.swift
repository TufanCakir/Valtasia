//
//  EventCardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import SwiftUI

struct EventCardView: View {

    @EnvironmentObject var appModel: AppModel

    let event: GameEvent
    var onTap: (() -> Void)?

    @State private var now = Date()

    private let timer =
        Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        Button {
            onTap?()
        } label: {
            ZStack(alignment: .bottomLeading) {
                // MARK: Background Image
                Image(event.icon ?? "water_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()

                // MARK: Gradient Overlay
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .allowsHitTesting(false)

                // MARK: Content
                VStack(alignment: .leading, spacing: 10) {
                    Text(event.title)
                        .font(.headline.bold())
                        .foregroundStyle(.white)

                    if let description = event.description {
                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                            .lineLimit(2)
                    }

                    countdownView
                }
                .padding()
            }
            .contentShape(RoundedRectangle(cornerRadius: 24))
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        // MARK: Border
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: theme.borderGradient,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
        )
        .buttonStyle(.plain)
        .onReceive(timer) { value in
            withAnimation(.linear(duration: 0.2)) {
                now = value
            }
        }
    }

    @ViewBuilder
    private var countdownView: some View {
        let key = "event_start_\(event.id)"

        let start = UserDefaults.standard.object(forKey: key) as? Date
        let end = start.flatMap {
            Calendar.current.date(
                byAdding: .day,
                value: event.durationDays ?? 7,
                to: $0
            )
        }

        if let end {
            let remaining = Int(end.timeIntervalSince(now))

            if remaining <= 0 {
                Text("Event Ended")
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black.opacity(0.6))
                    )

            } else {
                let days = remaining / 86400
                let hours = (remaining % 86400) / 3600
                let minutes = (remaining % 3600) / 60
                let seconds = remaining % 60

                HStack(spacing: 6) {
                    Image(systemName: "clock.fill")

                    Text("\(days)d \(hours)h \(minutes)m \(seconds)s")
                        .font(.caption.bold())
                }
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.5))
                )
                .overlay(
                    Capsule()
                        .stroke(
                            LinearGradient(
                                colors: theme.borderGradient,
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                            lineWidth: 1
                        )
                )
            }

        } else {
            Text("Starting...")
                .font(.caption.bold())
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(Color.black.opacity(0.4))
                )
        }
    }
}
