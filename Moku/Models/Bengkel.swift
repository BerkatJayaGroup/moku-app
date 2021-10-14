//
//  Bengkel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation

struct Bengkel: Codable{
    var name: String
    var phoneNumber: String
    var photoReference: String?

//    var operationalHours: [Date]

    var reviews = [Review]()
    var components = [String]()
}
