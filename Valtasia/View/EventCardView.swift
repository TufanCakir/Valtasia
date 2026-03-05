//
//  EventCardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import SwiftUI

struct EventCardView: View {

    let event: GameEvent
    var onTap: (() -> Void)?

    @State private var now = Date()

    private let timer =
        Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

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
                    colors: [.clear, .black.opacity(0.9)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                // MARK: Content

                VStack(alignment: .leading, spacing: 10) {

                    Text(event.title)
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    if let description = event.description {

                        Text(description)
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.8))
                    }

                    countdownView
                }
                .padding()
            }
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 24))

        // MARK: Border

        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(
                    LinearGradient(
                        colors: [
                            .cyan.opacity(0.7),
                            .purple.opacity(0.6)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )

        // MARK: Glow

        .shadow(color: .cyan.opacity(0.35), radius: 14)

        .buttonStyle(.plain)

        .onReceive(timer) { value in
            now = value
        }
    }

    @ViewBuilder
    private var countdownView: some View {
        let key = "event_start_\(event.id)"

        let start = UserDefaults.standard.object(forKey: key) as? Date
        let end = start.flatMap { Calendar.current.date(
            byAdding: .day,
            value: event.durationDays ?? 7,
            to: $0
        ) }

        if let end {
            let remaining = Int(end.timeIntervalSince(now))

            if remaining <= 0 {
                Text("Event Ended")
                    .font(.caption.bold())
                    .padding(.horizontal,10)
                    .padding(.vertical,6)
                    .background(.red.opacity(0.7))
                    .clipShape(Capsule())
            } else {
                let days = remaining / 86400
                let hours = (remaining % 86400) / 3600
                let minutes = (remaining % 3600) / 60
                let seconds = remaining % 60

                HStack(spacing:6) {
                    Image(systemName: "clock.fill")
                    Text("\(days)d \(hours)h \(minutes)m \(seconds)s")
                        .font(.caption.bold())
                }
                .foregroundStyle(.white)
                .padding(.horizontal,12)
                .padding(.vertical,6)
                .background(
                    LinearGradient(
                        colors:[.cyan,.purple],
                        startPoint:.leading,
                        endPoint:.trailing
                    )
                )
                .clipShape(Capsule())
            }
        } else {
            Text("Starting...")
                .font(.caption.bold())
                .padding(.horizontal,10)
                .padding(.vertical,6)
                .background(.gray.opacity(0.4))
                .clipShape(Capsule())
        }
    }
}

