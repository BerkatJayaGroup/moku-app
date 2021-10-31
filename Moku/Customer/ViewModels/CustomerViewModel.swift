//
//  CustomerViewModel.swift
//  Moku
//
//  Created by Mac-albert on 28/10/21.
//

import Combine
import SwiftUI

extension DaftarCustomer {
    class CustomerViewModel: ObservableObject {

        @Published var name: String = ""
        @Published var nomorTelepon: String = ""
        @Published var email: String = ""
        @Published var motor: Motor?
        @Published var query: String = ""
        @Published var isEmailValid: Bool = true
        @Published var nameCheck: Bool = true
        @Published var nomorCheck: Bool = true
        @Published var motorCheck: Bool = true
        @Published var showModal = false

        private let repository: CustomerRepository = .shared

        static let shared = CustomerViewModel()

        init() {}

        func create (_ customer: Customer) {
            repository.add(customer: customer)
        }

        var isFormInvalid: Bool {
            motor == nil || name.isEmpty || nomorTelepon.isEmpty || email.isEmpty
        }

        func textFieldValidatorEmail() -> Bool {
            if email.count > 100 {
                return false
            }
            let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
            return emailPredicate.evaluate(with: email)
        }

        func validateEmptyName () {
            print("name check view model")
            if name.isEmpty {
                nameCheck = false
            } else {
                nameCheck = true
            }
        }

        func isPhoneNumberEmpty() {
            if nomorTelepon.isEmpty {
                nomorCheck = false
            } else {
                nomorCheck = true
            }
        }
    }
}
