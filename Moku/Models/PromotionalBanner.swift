//
//  PromotionalBanner.swift
//  Moku
//
//  Created by Christianto Budisaputra on 10/12/21.
//

import Foundation

struct PromotionalBanner: Codable, Identifiable {
    let id: String
    let imageUrlString: String
    let deeplinkUrl: String?

    var imageUrl: URL? {
        URL(string: imageUrlString)
    }

    init(id: String = UUID().uuidString, imageUrl: String, deeplinkUrl: String? = nil) {
        self.id = id
        self.deeplinkUrl = deeplinkUrl
        imageUrlString = imageUrl
    }
}
