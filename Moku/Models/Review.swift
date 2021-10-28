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
    var timestamp = Date()
}
