//
//  DynamicLinksService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 16/11/21.
//

import Foundation
import FirebaseDynamicLinks

extension DynamicLinksService {
    enum DynamicLinkTarget {
        case bookingDetail(id: String)
    }

    struct SocialMetaTag {
        let title       = "Moku"
        let description = "Teman Servis Motorku"
        let imageURL    = URL(string: "https://via.placeholder.com/300")!
    }
}

final class DynamicLinksService: ObservableObject {
    @Published var dynamicLinkTarget: DynamicLinkTarget?

    static let shared = DynamicLinksService()

    private init() {}

    private func shortenURL(linkBuilder: DynamicLinkComponents, completionHandler: ((URL) -> Void)? = nil) {
        linkBuilder.shorten { url, _, _ in
            guard let url = url else { return }
            completionHandler?(url)
        }
    }

    func generateDynamicLink(
        order: Order,
        metaTag: SocialMetaTag = SocialMetaTag(),
        completionHandler: ((String) -> Void)? = nil
    ) {
        guard let linkBuilder = createLinkBuilder(order: order, metaTag: metaTag) else { return }
        shortenURL(linkBuilder: linkBuilder) { url in
            completionHandler?(url.absoluteString)
        }
    }

    func handleDynamicLink(_ dynamicLink: DynamicLink) {
        guard let url = dynamicLink.url,
              url.scheme == "https",
              let query = url.query
        else { return }

        print("Your incoming link parameter is \(url.absoluteString)")
        print("Your query is \(query)")

        let components = query.split(separator: ",").flatMap { substring in
            substring.split(separator: "=")
        }

        guard let bookingIDKeyIndex = components.firstIndex(of: Substring("bookingID")),
              bookingIDKeyIndex + 1 < components.count
        else { return }

        let bookingID = String(components[bookingIDKeyIndex + 1])

        dynamicLinkTarget = .bookingDetail(id: bookingID)
    }

    private func createQueryItems(for target: DynamicLinkTarget) -> URLQueryItem? {
        if case .bookingDetail(let bookingID) = target {
            return URLQueryItem(name: "bookingID", value: bookingID)
        }

        return nil
    }

    private func createURLComponents(for target: DynamicLinkTarget) -> URLComponents? {
        var component = URLComponents()
        guard let queryItem = createQueryItems(for: target) else { return nil }

        component.scheme        = "https"
        component.host          = "moku.page.link"
        component.queryItems    = [queryItem]

        return component

    }

    private func createLinkBuilder(order: Order, metaTag: SocialMetaTag) -> DynamicLinkComponents? {
        let urlComponent = createURLComponents(for: .bookingDetail(id: order.id))

        guard let link = urlComponent?.url,
              let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: "https://moku.page.link") else { return nil }

        if let mokuBundleId = Bundle.main.bundleIdentifier {
            linkBuilder.iOSParameters = DynamicLinkIOSParameters(bundleID: mokuBundleId)
        }

        linkBuilder.iOSParameters?.appStoreID                   = "1595792854"
        linkBuilder.socialMetaTagParameters                     = DynamicLinkSocialMetaTagParameters()
        linkBuilder.socialMetaTagParameters?.title              = metaTag.title
        linkBuilder.socialMetaTagParameters?.descriptionText    = metaTag.description
        linkBuilder.socialMetaTagParameters?.imageURL           = metaTag.imageURL

        return linkBuilder
    }
}
