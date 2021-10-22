//
//  User.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

struct Customer: Codable {
    var name: String
    var phoneNumber: String
    var motors: [Motor]?
}
