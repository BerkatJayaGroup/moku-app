//
//  SessionService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 18/10/21.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

final class SessionService: ObservableObject {
    // Shared Instance
    static let shared = SessionService()
    @Published var user: User?

    @Published var selectedMotor: Motor?

    private init() {
        if let userId = Auth.auth().currentUser?.uid {

            BengkelRepository.shared.fetch(id: userId) { bengkel in
                self.user = .bengkel(bengkel)
            }

            CustomerRepository.shared.fetch(id: userId) { customer in
                self.user = .customer(customer)
            }

//            CustomerRepository.shared.customer.forEach { customer in
//                if customer.id == userId {
//                    user = .customer(customer)
//                }
//            }
        }
    }

    static var apiKey: String {
        guard let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'GoogleService-Info.plist'.")
        }

        let plist = NSDictionary(contentsOfFile: filePath)

        guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'GoogleService-Info.plist'.")
        }

        return value
    }
}

extension SessionService {
    enum User {
        case customer(_ customer: Customer)
        case bengkel(_ bengkel: Bengkel)
    }
}
