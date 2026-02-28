//
//  EventView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 28.02.26.
//

import SwiftUI

struct EventView: View {

    @EnvironmentObject var eventManager: EventManager
    @State private var selectedEvent: GameEvent?
    
    @State private var startBoss = false
    @State private var openSummon = false

    var body: some View {

        NavigationStack {

            ZStack {

                LinearGradient(
                    colors: [.black, .purple.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if eventManager.activeEvents().isEmpty {

                    emptyState

                } else {

                    ScrollView {

                        VStack(spacing: 20) {

                            ForEach(eventManager.activeEvents()) { event in
                                
                                EventCardView(event: event) {
                                    selectedEvent = event   // ⭐ NAVIGATION TRIGGER
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Events")
            .navigationDestination(isPresented: $startBoss) {

                Text("Boss Fight Scene") // später GameContainerView
            }

            .navigationDestination(isPresented: $openSummon) {

                Text("Summon Banner")
            }

            // ⭐ HIER passiert die Navigation
            .navigationDestination(item: $selectedEvent) { event in
                EventDetailView(event: event)
            }
        }
    }
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
