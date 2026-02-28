//
//  EventTimerOverlay.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventTimerOverlay: View {

    @State private var now = Date()

    var body: some View {

        if let event = EventRuntime.shared.activeEvent,
           let start = event.start.date,
           let end = Calendar.current.date(
                byAdding: .day,
                value: 7,
                to: start
           ) {

            let remaining = Int(end.timeIntervalSince(now))

            HStack {

                Image(systemName: "clock.fill")

                Text(timeString(remaining))
                    .font(.caption.bold())
            }
            .padding(8)
            .background(.black.opacity(0.7))
            .clipShape(Capsule())
            .foregroundStyle(.cyan)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                    now = Date()
                }
            }
        }
    }

    func timeString(_ seconds:Int)->String{
        let d = seconds / 86400
        let h = (seconds % 86400) / 3600
        let m = (seconds % 3600) / 60
        return "\(d)d \(h)h \(m)m"
    }
}
