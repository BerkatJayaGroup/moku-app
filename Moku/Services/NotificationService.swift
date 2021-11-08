//
//  NotificationService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 08/11/21.
//

import FirebaseMessaging
import UserNotifications
import UIKit

final class NotificationService: NSObject, ObservableObject {
    static let shared = NotificationService()

    private override init() {}

    static func register(application: UIApplication) {
        Messaging.messaging().delegate = shared
        UNUserNotificationCenter.current().delegate = shared

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }

        application.registerForRemoteNotifications()
    }

    func send() {

    }

    func schedule() {

    }
}

extension NotificationService: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo

        print("userInfo", userInfo)

        completionHandler([[.badge, .banner, .sound]])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        print("userInfo", userInfo)

        completionHandler()
    }
}

extension NotificationService: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("fcmToken:", fcmToken)
    }
}
