//
//  Bengkel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Bengkel: Codable {
    // MARK: - Registration Related
    @DocumentID var id: String!
    var owner: Owner
    var name: String
    var phoneNumber: String
    var location: Location
    var operationalHours: OperationalHours
    var operationalDays = Set<Day>()
    var photos          = [String]()
    var brands          = Set<Brand>()
    var mekaniks        = [Mekanik]()

    // MARK: Order Related
    var reviews         = [Review]()
    var orders          = [Order]()
}

extension Bengkel {
    struct OperationalHours: Codable {
        var open: Int
        var close: Int
    }

    struct Owner: Codable {
        let name: String
        let phoneNumber: String
        let email: String
    }
}

extension Bengkel {
    static let preview = Bengkel(id: UUID().uuidString, name: "Berkat Jaya Motor", phoneNumber: "081280806969")
}
