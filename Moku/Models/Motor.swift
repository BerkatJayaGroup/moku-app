//
//  Motor.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation

struct Motor: Codable, Identifiable {
    var id = UUID()
    let merk: Merk
    let model: String
    let cc: Int
    var year: Int?

    init(merk: Merk, model: String, cc: Int) {
        self.merk   = merk
        self.model  = model
        self.cc     = cc
    }
}

extension Motor {
    enum Merk: String, Codable {
        case honda, yamaha, suzuki, kawasaki
    }
}
