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

    // SwiftUI-native Timer (viel besser als Timer())
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {

        Button {
            onTap?()
        } label: {

            VStack(alignment: .leading, spacing: 12) {

                Text(event.title)
                    .font(.title2.bold())
                    .foregroundStyle(.white)

                if let description = event.description {
                    Text(description)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.8))
                }

                countdownView
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.purple.opacity(0.5), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onReceive(timer) { value in
            now = value
        }
    }

    private var countdownView: some View {

        let key = "event_start_\(event.id)"

        guard let start = UserDefaults.standard.object(forKey: key) as? Date,
            let end = Calendar.current.date(byAdding: .day, value: 7, to: start)
        else {
            return Text("Starting...")
                .font(.caption.bold())
                .foregroundStyle(.gray)
        }

        let remaining = Int(end.timeIntervalSince(now))

        if remaining <= 0 {
            return Text("Event Ended")
                .font(.caption.bold())
                .foregroundStyle(.red)
        }

        let days = remaining / 86400
        let hours = (remaining % 86400) / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60

        return Text("Ends in: \(days)d \(hours)h \(minutes)m \(seconds)s")
            .font(.caption.bold())
            .foregroundStyle(.cyan)
    }
}
