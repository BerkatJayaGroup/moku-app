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
    var fcmToken: String?
//    TODO: Nunggu Bengkel Side ngetrigger Order
//    OrdersToRate bakal keisi kalo di triger bengkel
    var ordersToRate: [String]?
}

extension Customer {
    static let preview = Customer(
        id: "L34zGzxCO6XpMOkpqR9sBYa1Rse2",
        name: "John Doe",
        phoneNumber: "082280806969",
        motors: [
            Motor(brand: .yamaha, model: "Motor Yamaha", cc: 155, licensePlate: "B 7261 SRS", year: "2012"),
            Motor(brand: .suzuki, model: "Motor Suzuki", cc: 110, licensePlate: "BG 2190 UIT", year: "2020"),
            Motor(brand: .honda, model: "Motor Honda", cc: 110, licensePlate: "BG 8212 UI", year: "1920"),
            Motor(brand: .kawasaki, model: "Motor Kawasaki", cc: 120, licensePlate: "B 7821 UT", year: "2015")
        ],
        fcmToken: "cp_FfaoY1UoPmCEKVaO6GA:APA91bGf4BFHWUgYAORP9QVrVYILftl2znuEnGDi-nfzunC8UybNeRJIftjEOwd79tdOjRZzsPYQmBMloJzsVx-94J0kUqj_eFScUd3P5w_ePCy3qHXqkQ5Jje_XsZY6Gk-npDz_w9qP",
        ordersToRate: ["NqrRsFb6xJbM7LOO6vVW"]
    )
}
