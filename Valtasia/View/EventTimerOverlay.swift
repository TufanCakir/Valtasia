//
//  EventTimerOverlay.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import Combine
import SwiftUI

struct EventTimerOverlay: View {

    @State private var now = Date()

    // SwiftUI-native Timer
    private let timer = Timer.publish(every: 1, on: .main, in: .common)
        .autoconnect()

    var body: some View {

        if let event = EventRuntime.shared.activeEvent {

            let key = "event_start_\(event.id)"

            if let start = UserDefaults.standard.object(forKey: key) as? Date,
                let end = Calendar.current.date(
                    byAdding: .day,
                    value: 7,
                    to: start
                )
            {

                let remaining = max(0, Int(end.timeIntervalSince(now)))

                HStack(spacing: 6) {

                    Image(systemName: "clock.fill")

                    Text(timeString(remaining))
                        .monospacedDigit()
                        .font(.caption.bold())
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(.black.opacity(0.75))
                .clipShape(Capsule())
                .foregroundStyle(remaining < 86400 ? .red : .cyan)
                .onReceive(timer) { value in
                    now = value
                }
            }
        }
    }

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
