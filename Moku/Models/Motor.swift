//
//  Motor.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation

struct Motor: Codable, Identifiable {
    var id = UUID()
    let brand: Brand
    let model: String
    let cc: Int
    var year: Int?

    init(brand: Brand, model: String, cc: Int) {
        self.brand  = brand
        self.model  = model
        self.cc     = cc
    }
}

extension Motor {
    enum Brand: String, Codable {
        case honda, yamaha, suzuki, kawasaki
    }
}
