//
//  MailView.swift
//  Valtasia
//
//  Created by Tufan Cakir on 02.03.26.
//

import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {

    var recipient: String
    var subject: String

    @Environment(\.dismiss) var dismiss

    func makeCoordinator() -> Coordinator {

        Coordinator(self)
    }

    func makeUIViewController(
        context: Context
    ) -> MFMailComposeViewController {

        let vc = MFMailComposeViewController()

        vc.setToRecipients([recipient])
        vc.setSubject(subject)

        vc.mailComposeDelegate =
            context.coordinator

        return vc
    }

    func updateUIViewController(
        _ uiViewController: MFMailComposeViewController,
        context: Context
    ) {}

    class Coordinator:
        NSObject,
        MFMailComposeViewControllerDelegate
    {

        var parent: MailView

        init(_ parent: MailView) {

            self.parent = parent
        }

        func mailComposeController(
            _ controller: MFMailComposeViewController,
            didFinishWith result:
                MFMailComposeResult,
            error: Error?
        ) {

            controller.dismiss(animated: true)
        }
    }
}
