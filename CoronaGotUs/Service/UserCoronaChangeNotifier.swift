//
//  UserCoronaChangeNotifier.swift
//  CoronaGotUs
//
//  Created by Karim Alweheshy on 11/25/20.
//

import Foundation
import Combine
import UserNotificationsUI

final class UserCoronaChangeNotifier: NSObject {
    private let signalStorage: CurrentCoronaSignalStorage
    private var disposables = Set<AnyCancellable>()

    init(signalStorage: CurrentCoronaSignalStorage) {
        self.signalStorage = signalStorage
        super.init()

        let cancellable = self.signalStorage
            .$currentCoronaSignal
            .dropFirst()
            .sink(receiveValue: notifyCoronaSignalChange)
        disposables.insert(cancellable)
        UNUserNotificationCenter.current().delegate = self
    }
}

// MARK: - UNUserNotificationCenterDelegate

extension UserCoronaChangeNotifier: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }
}

// MARK: - Private Methods

extension UserCoronaChangeNotifier {
    private func notifyCoronaSignalChange(_ coronaSignal: CoronaSignal?) {
        UNUserNotificationCenter
            .current()
            .requestAuthorization(options: [.alert, .announcement, .badge, .sound]) { [weak self] authorized, error in
                guard authorized else { return }
                self?.displayLocalNotification(coronaSignal)
            }

    }

    private func displayLocalNotification(_ coronaSignal: CoronaSignal?) {
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.defaultCritical

        if let coronaSignal = coronaSignal {
            content.title = NSLocalizedString(coronaSignal.localizedLabelKey, comment: "")
            content.body = NSLocalizedString("notification_infection_change_body", comment: "")
            content.subtitle = NSLocalizedString("notification_infection_change_subtitle", comment: "")
        } else {
            content.title = NSLocalizedString("notification_unknown_infection_title", comment: "")
            content.body = NSLocalizedString("notification_unknown_infection_body", comment: "")
        }

        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )

        UNUserNotificationCenter
            .current()
            .add(request, withCompletionHandler: nil)
    }
}
