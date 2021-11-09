//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Christianto Budisaputra on 09/11/21.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        if let bestAttemptContent = bestAttemptContent {
            guard let body = bestAttemptContent.userInfo["data"] as? [String: Any],
                  let imageUrl = body["imageUrl"] as? String else { fatalError("Image URL not found.") }

            downloadImageFrom(url: imageUrl) { attachment in
                if let attachment = attachment {
                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                }
            }
        }
    }

    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

    private func downloadImageFrom(url: String, handler: @escaping (UNNotificationAttachment?) -> Void) {
        let task = URLSession.shared.downloadTask(with: URL(string: url)!) { downloadedUrl, _, _ in
            guard let downloadedUrl = downloadedUrl else { handler(nil) ; return } // RETURNING NIL IF IMAGE NOT FOUND
            var urlPath = URL(fileURLWithPath: NSTemporaryDirectory())
            let uniqueUrlEnding = ProcessInfo.processInfo.globallyUniqueString + ".jpg"
            urlPath = urlPath.appendingPathComponent(uniqueUrlEnding)
            try? FileManager.default.moveItem(at: downloadedUrl, to: urlPath)
            do {
                let attachment = try UNNotificationAttachment(identifier: "picture", url: urlPath, options: nil)
                handler(attachment) // RETURNING ATTACHEMENT HAVING THE IMAGE URL SUCCESSFULLY
            } catch {
                print("attachment error")
                    handler(nil)
                }
            }
            task.resume()
    }

}
