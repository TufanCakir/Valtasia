//
//  EventCardView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventCardView: View {
    
    let event: GameEvent
    var onTap: (() -> Void)?   // ⭐ optional Callback
    
    @State private var now = Date()
    @State private var timer: Timer?
    
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
        .onAppear { startTimer() }
        .onDisappear { timer?.invalidate() }
    }
    private var countdownView: some View {
        
        guard let startDate = event.start.date,
              let endDate = Calendar.current.date(
                byAdding: .day,
                value: 7,
                to: startDate
              )
        else {
            return AnyView(EmptyView())
        }
        
        let remaining = Int(endDate.timeIntervalSince(now))
        
        if remaining <= 0 {
            return AnyView(
                Text("Event Ended")
                    .font(.caption.bold())
                    .foregroundStyle(.red)
            )
        }
        
        let days = remaining / 86400
        let hours = (remaining % 86400) / 3600
        let minutes = (remaining % 3600) / 60
        let seconds = remaining % 60
        
        return AnyView(
            Text("Ends in: \(days)d \(hours)h \(minutes)m \(seconds)s")
                .font(.caption.bold())
                .foregroundStyle(.cyan)
        )
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            now = Date()
        }
        RunLoop.current.add(timer!, forMode: .common)
    }
}
