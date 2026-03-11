//
//  EventView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventView: View {

    @EnvironmentObject var eventManager: EventManager

    // Existing category selection
    @State private var selectedCategory: EventCategory = .boss

    // State used by navigation in the lower snippet
    @State private var startBoss: Bool = false
    @State private var openSummon: Bool = false
    @State private var selectedEvent: GameEvent? = nil

    var body: some View {
        VStack(spacing: 18) {

            EventCategoryTabs(selected: $selectedCategory)

            // Content area: show empty state when there are no active events,
            // otherwise list events for the selected category.
            Group {
                let events = eventManager.events(for: selectedCategory)

                if events.isEmpty {
                    emptyCategoryState
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            ForEach(events) { event in
                                EventCardView(event: event) {
                                    selectedEvent = event
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        .background(
            LinearGradient(
                colors: [.black, .blue.opacity(0.25)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        // Navigation destinations consolidated here
        .navigationTitle("Events")
        .navigationDestination(isPresented: $startBoss) {
            Text("Boss Fight Scene")
        }
        .navigationDestination(isPresented: $openSummon) {
            Text("Summon Banner")
        }
        .navigationDestination(item: $selectedEvent) { event in
            EventDetailView(event: event)
        }
    }
}

private var emptyCategoryState: some View {
    VStack(spacing: 16) {
        Image(systemName: "calendar")
            .font(.system(size: 48))
            .foregroundStyle(.cyan.opacity(0.8))

        Text("Keine Events verfügbar")
            .font(.title3.bold())
            .foregroundStyle(.white)

        Text("Schau später wieder vorbei für neue Events und Belohnungen.")
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.7))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.top, 60)
}

extension EventView {

    fileprivate var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.purple)

            Text("No Active Events")
                .font(.title2.bold())
                .foregroundStyle(.white)

            Text("Check back later for limited events and rewards.")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.7))
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
