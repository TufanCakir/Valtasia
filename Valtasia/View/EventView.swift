//
//  EventView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventView: View {

    @EnvironmentObject var appModel: AppModel
    @EnvironmentObject var eventManager: EventManager

    @State private var selectedCategory: EventCategory = .boss
    @State private var selectedEvent: GameEvent?

    var theme: UITheme {
        appModel.homeMode == .corrupted ? .corrupted : .island
    }

    var body: some View {
        VStack(spacing: 16) {

            EventCategoryTabs(selected: $selectedCategory)

            content
        }
        .background(background)
        .navigationTitle("Events")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
    }
}

extension EventView {

    private var content: some View {

        let events = eventManager.events(for: selectedCategory)

        return Group {
            if events.isEmpty {
                emptyState
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(events) { event in
                            EventCardView(event: event) {
                                selectedEvent = event
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
                .scrollIndicators(.hidden)
            }
        }
    }
}

extension EventView {

    private var emptyState: some View {
        VStack(spacing: 14) {

            Image(systemName: "calendar")
                .font(.system(size: 40))
                .foregroundStyle(.white.opacity(0.5))

            Text("No Events Available")
                .font(.headline.bold())
                .foregroundStyle(.white)

            Text("Come back later for new challenges and rewards.")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

extension EventView {

    private var background: some View {
        LinearGradient(
            colors: theme.headerGradient,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}
