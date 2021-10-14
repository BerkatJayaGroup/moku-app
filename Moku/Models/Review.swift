//
//  Review.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation

struct Review: Codable {
    let user: String
    let rating: Int
    let comment: String?
    let timestamp: Date

    init(user: String, rating: Int, comment: String? = nil, timestamp: Date = Date()) {
        self.user       = user
        self.rating     = rating
        self.comment    = comment
        self.timestamp  = timestamp
    }
}
