//
//  DynamicLinksService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 16/11/21.
//

import Foundation
import FirebaseDynamicLinks

final class DynamicLinksService: ObservableObject {
    static let shared = DynamicLinksService()

    private let linkBuilder: DynamicLinkComponents? = {
        let urlComponent: URLComponents = {
            var component = URLComponents()
            component.scheme    = "https"
            component.host      = "moku.page.link"
            return component
        }()

        guard let link = urlComponent.url,
              var builder = DynamicLinkComponents(link: link, domainURIPrefix: "https://moku.page.link") else { return nil }

        if let mokuBundleId = Bundle.main.bundleIdentifier {
            builder.iOSParameters = DynamicLinkIOSParameters(bundleID: mokuBundleId)
        }

        builder.iOSParameters?.appStoreID                   = "1595792854"
        builder.socialMetaTagParameters                     = DynamicLinkSocialMetaTagParameters()
        builder.socialMetaTagParameters?.title              = "Lorem Ipsum"
        builder.socialMetaTagParameters?.descriptionText    = "Lorem ipsum dolor sit amet."
        builder.socialMetaTagParameters?.imageURL           = URL(string: "https://via.placeholder.com/300")!

        return builder
    }()

    private init() {
        if let url = linkBuilder?.url {
            print(url)
        }
    }

    func shortenURL() {
        linkBuilder?.shorten { url, _, _ in
            guard let url = url else { return }
            print(url.absoluteString)
        }
    }
}
