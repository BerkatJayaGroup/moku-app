//
//  User.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import FirebaseFirestoreSwift
import Foundation

struct Customer: Codable {
    @DocumentID var id: String!
    var name: String
    var phoneNumber: String
    var motors: [Motor]?
}

extension Customer {
    static let preview = Customer(
        id: UUID().uuidString,
        name: "John Doe",
        phoneNumber: "082280806969",
        motors: [
            Motor(brand: .yamaha, model: "NMAX", cc: 155),
            Motor(brand: .yamaha, model: "Scoopy", cc: 110),
            Motor(brand: .yamaha, model: "Mio", cc: 110),
            Motor(brand: .yamaha, model: "Jupiter", cc: 120)
        ]
    )
}
