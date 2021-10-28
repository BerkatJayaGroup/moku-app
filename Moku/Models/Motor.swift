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
    @DocumentID var id: String!
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

enum Brand: String, Codable, CaseIterable {
    case honda = "honda"
    case yamaha = "yamaha"
    case suzuki = "suzuki"
    case kawasaki = "kawasaki"
}
