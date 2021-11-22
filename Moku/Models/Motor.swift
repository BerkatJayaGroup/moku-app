//
//  Motor.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class Motor: Codable, Identifiable {
    let id = UUID().uuidString
    let brand: Brand
    let model: String
    let cc: Int
    var licensePlate: String?
    var year: String?

    init(brand: Brand, model: String, cc: Int, licensePlate: String? = "", year: String? = "") {
        self.brand  = brand
        self.model  = model
        self.cc     = cc
        self.licensePlate = licensePlate
        self.year = year
    }
}

enum Brand: String, Codable, CaseIterable, Identifiable {
    var id: RawValue { rawValue }
    case honda = "Honda"
    case yamaha = "Yamaha"
    case suzuki = "Suzuki"
    case kawasaki = "Kawasaki"
}
