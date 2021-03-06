//
//  CustomerViewModel.swift
//  Moku
//
//  Created by Mac-albert on 28/10/21.
//

import Combine
import SwiftUI
import Firebase

extension DaftarCustomer {
    class ViewModel: ObservableObject {

        @Published var motor: Motor?
        @Published var name         = ""
        @Published var nomorTelepon = ""
        @Published var query        = ""
        @Published var licensePlate = ""
        @Published var year         = ""

        @Published var nameCheck            = true
        @Published var nomorCheck           = true
        @Published var motorCheck           = true
        @Published var showModal            = false

        private let repository: CustomerRepository = .shared

        init() {
            let user = Auth.auth().currentUser
            if let user = user {
                name = user.displayName ?? ""
            }
        }

        func create(_ customer: Customer, completionHandler: ((Customer) -> Void)? = nil) {
            repository.add(customer: customer) { docRef in
                docRef.getDocument { snapshot, _ in
                    if let customer = try? snapshot?.data(as: Customer.self) {
                        SessionService.shared.user = .customer(customer)
                        completionHandler?(customer)
                    }
                }
            }
        }
        var isFormInvalid: Bool {
            motor == nil || nomorTelepon.isEmpty
        }

        func isPhoneNumberEmpty() {
            if nomorTelepon.isEmpty {
                nomorCheck = false
            } else {
                nomorCheck = true
            }
        }

        func isMotorEmpty() {
            if motor == nil {
                motorCheck = false
            } else {
                motorCheck = true
            }
        }
    }
}
