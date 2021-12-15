//
//  CustomerViewModel.swift
//  Moku
//
//  Created by Mac-albert on 28/10/21.
//

import Combine
import SwiftUI
import FirebaseFirestore

extension DaftarCustomer {
    class ViewModel: ObservableObject {

        @Published var motor: Motor?
        @Published var name         = ""
        @Published var nomorTelepon = ""
        @Published var email        = ""
        @Published var query        = ""
        @Published var licensePlate = ""
        @Published var year         = ""

        @Published var isEmailValid         = true
        @Published var emailCheck           = true
        @Published var nameCheck            = true
        @Published var nomorCheck           = true
        @Published var motorCheck           = true
        @Published var showModal            = false

        private let repository: CustomerRepository = .shared

        init() {}

        func create(_ customer: Customer, completionHandler: ((Customer) -> Void)? = nil) {
            repository.add(customer: customer) { docRef in
                docRef.getDocument { snapshot, _ in
                    if let snapshot = snapshot {
                        do {
                            if let customer = try snapshot.data(as: Customer.self) {
                                SessionService.shared.user = .customer(customer)
                                completionHandler?(customer)
                            }
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            }
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

        func isMotorEmpty() {
            if motor == nil {
                motorCheck = false
            } else {
                motorCheck = true
            }
        }

        func isEmailEmpty() {
            if email.isEmpty {
                emailCheck = false
            } else {
                emailCheck = true
            }
        }
    }
}
