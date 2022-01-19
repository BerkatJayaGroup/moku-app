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
    var id = UUID().uuidString
    let brand: Brand
    let model: String
    let cc: String
    var licensePlate: String?
    var year: String?

    init(brand: Brand, model: String, cc: String, licensePlate: String?, year: String?) {
        self.brand  = brand
        self.model  = model
        self.cc     = cc
        self.licensePlate = licensePlate
        self.year = year
    }

    private enum CodingKeys: String, CodingKey {
        case brand
        case cc
        case model
        case licensePlate
        case year
    }
}

enum Brand: String, Codable, CaseIterable, Identifiable {
    var id: RawValue { rawValue }
    case honda = "HONDA"
    case yamaha = "YAMAHA"
    case suzuki = "SUZUKI"
    case kawasaki = "KAWASAKI"
}
