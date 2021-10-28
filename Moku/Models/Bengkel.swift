//
//  Bengkel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation
import FirebaseFirestoreSwift

struct Bengkel: Codable {
    @DocumentID var id: String!
    var name: String
    var phoneNumber: String
    var photoReference: String?

//    var operationalHours: [Date]

    var reviews = [Review]()
    var components = [String]()
}

extension Bengkel {
    static let preview = Bengkel(id: UUID().uuidString, name: "Berkat Jaya Motor", phoneNumber: "081280806969")
}
