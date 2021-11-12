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
//    TODO: Nunggu Bengkel Side ngetrigger Order
//    OrdersToRate bakal keisi kalo di triger bengkel
    var ordersToRate = [Order]()
}

extension Customer {
    static let preview = Customer(
        id: "L34zGzxCO6XpMOkpqR9sBYa1Rse2",
        name: "John Doe",
        phoneNumber: "082280806969",
        motors: [
            Motor(brand: .yamaha, model: "Motor Yamaha", cc: 155),
            Motor(brand: .suzuki, model: "Motor Suzuki", cc: 110),
            Motor(brand: .honda, model: "Motor Honda", cc: 110),
            Motor(brand: .kawasaki, model: "Motor Kawasaki", cc: 120)
        ],
        ordersToRate: [
            Order(id: "1GYgKE6tXGRS3icCtVxI",
                  bengkelId: "yn2iMDl1Kc0Orv6tb3vx",
                  customerId: "mRJRlGEwQ7sSOsY2xjSf",
                  motor: Motor(brand: .honda,
                               model: "Beat",
                               cc: 110),
                  typeOfService: .perbaikan,
                  schedule: Date())
        ]
    )
}
