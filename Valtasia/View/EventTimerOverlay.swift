//
//  EventTimerOverlay.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import SwiftUI

struct EventTimerOverlay: View {

    @EnvironmentObject var appModel: AppModel

    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {

        if let remaining = remainingTime {

            HStack(spacing: 6) {

                Image(systemName: "clock.fill")

                Text(timeString(remaining))
                    .monospacedDigit()
                    .font(.caption.bold())
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Color.black.opacity(0.7))
            .clipShape(Capsule())
            .foregroundStyle(textColor(for: remaining))
            .onReceive(timer) { now = $0 }
        }
    }
}

extension EventTimerOverlay {

    private var remainingTime: Int? {

        guard let event = EventRuntime.shared.activeEvent else { return nil }

        let key = "event_start_\(event.id)"

        guard let start = UserDefaults.standard.object(forKey: key) as? Date
        else {
            return nil
        }

        let duration = event.durationDays ?? 7

        guard
            let end = Calendar.current.date(
                byAdding: .day,
                value: duration,
                to: start
            )
        else { return nil }

        let remaining = Int(end.timeIntervalSince(now))

        return remaining > 0 ? remaining : nil
    }
}

extension EventTimerOverlay {

    private func textColor(for remaining: Int) -> Color {

        // < 24h → warning
        if remaining < 86400 {
            return theme.borderGradient.last ?? .white
        }

        return .white
    }
}

extension EventTimerOverlay {

    private func timeString(_ seconds: Int) -> String {

        let d = seconds / 86400
        let h = (seconds % 86400) / 3600
        let m = (seconds % 3600) / 60

        if d > 0 {
            return "\(d)d \(h)h \(m)m"
        } else {
            return "\(h)h \(m)m"
        }
    }
}
