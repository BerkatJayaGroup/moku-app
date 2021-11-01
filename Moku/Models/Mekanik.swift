//
//  Mekanik.swift
//  Moku
//
//  Created by Christianto Budisaputra on 13/10/21.
//

import Foundation

struct Mekanik: Codable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var photo: String?
}
