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
    struct Content: Codable {
        var title: String
        var body: String
    }

    static let shared = NotificationService()

    private override init() {}

    static func register(application: UIApplication) {
        Messaging.messaging().delegate = shared
        UNUserNotificationCenter.current().delegate = shared

        let authOptions: UNAuthorizationOptions = [.badge, .sound, .alert, .provisional]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }

        application.registerForRemoteNotifications()
    }

    func getToken(completionHandler: ((String) -> Void)? = nil) {
        Messaging.messaging().token { token, _ in
            if let token = token { completionHandler?(token) }
        }
    }

    func send(to identifiers: [String], content: Content, imageUrl: String? = nil) {
        // JSON Data
        var json: [String: Any] = [
            "content_available": true,
            "mutable_content": true,
            "registration_ids": identifiers,
            "priority": "high",
            "notification": [
                "title": content.title,
                "body": content.body
            ]
        ]

        if let imageUrl = imageUrl {
            json["data"] = [ "imageUrl": imageUrl ]
        }

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(
            "key=AAAAML2qg7E:APA91bEDzQ9H8u0NJn6g-cZFfYi5hsTpB67qJNKCPSKmgRXKl20EvpBLA92GeJz4Ta-iey8-1jcIDDhUZ8Yqt4UvlmsHww2VdeMqhYcqrGEmWUpWirGJ9EUgEUbOGH9G0TU32AhNOzqI",
            forHTTPHeaderField: "Authorization"
        )
        request.httpMethod = "POST"
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { _, _, _  in }.resume()
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
        if let fcmToken = fcmToken {
            print(fcmToken)
            switch SessionService.shared.user {
            case .bengkel(var bengkel):
                bengkel.fcmToken = fcmToken
                BengkelRepository.shared.update(bengkel: bengkel)
            case .customer(var customer):
                customer.fcmToken = fcmToken
                CustomerRepository.shared.update(customer: customer)
            case .none:
                break
            }
        }
    }
}
