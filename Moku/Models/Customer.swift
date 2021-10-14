//
//  User.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import FirebaseFirestoreSwift

struct Customer: Codable {
    @DocumentID var id: String!
    var name: String
    var phoneNumber: String
    var motors: [Motor]?
}
