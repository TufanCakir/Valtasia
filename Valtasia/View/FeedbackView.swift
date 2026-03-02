//
//  FeedbackView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

//
//  FeedbackView.swift
//  Valtasia
//

import SwiftUI

struct FeedbackView: View {

    @State private var showMail = false

    var body: some View {

        VStack {

            // MARK: HEADER

            GameHeaderView()
                .padding()

            Divider()
                .background(.white.opacity(0.15))

            // MARK: SCROLL

            ScrollView {

                VStack(spacing: 22) {

                    feedbackCard(
                        title: "Send Email Feedback",
                        subtitle: "Directly contact the developer.",
                        systemIcon: "envelope.fill",
                        colors: [.blue, .purple]
                    ) {
                        showMail = true
                    }

                    feedbackCard(
                        title: "TestFlight Feedback",
                        subtitle: "Send screenshots and reports.",
                        systemIcon: "airplane",
                        colors: [.cyan, .purple]
                    ) {
                        openTestFlightFeedback()
                    }
                }
                .padding(.horizontal)
            }
            .scrollIndicators(.hidden)
        }
        .background(

            LinearGradient(
                colors: [
                    .black,
                    .blue.opacity(0.25),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showMail) {

            MailView(
                recipient: "support@tufancakir.com",
                subject: "Valtasia Beta Feedback"
            )
        }
    }
}

extension FeedbackView {

    func feedbackCard(
        title: String,
        subtitle: String,
        systemIcon: String,
        colors: [Color],
        action: @escaping () -> Void
    ) -> some View {

        Button {

            action()

        } label: {

            ZStack {

                // Background
                LinearGradient(
                    colors: [
                        .black,
                        colors.first?.opacity(0.35) ?? .blue.opacity(0.35),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                VStack(spacing: 16) {

                    Image(systemName: systemIcon)
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: colors,
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    VStack(spacing: 6) {

                        Text(title)
                            .font(.title.bold())
                            .foregroundStyle(.white)

                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                            .multilineTextAlignment(.center)
                    }
                }
                .padding()
            }
            .frame(height: 200)
            .clipShape(
                RoundedRectangle(cornerRadius: 24)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: colors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 2
                    )
            )
            .shadow(
                color: colors.first?.opacity(0.4) ?? .cyan.opacity(0.4),
                radius: 14
            )
        }
        .buttonStyle(.plain)
    }
}

extension FeedbackView {

    func openTestFlightFeedback() {

        if let url =
            URL(string: "itms-beta://")
        {

            UIApplication.shared.open(url)
        }
    }
}
