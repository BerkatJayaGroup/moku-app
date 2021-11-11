//
//  CustomerTabViewModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 10/11/21.
//

import Combine
import SwiftUI
import FirebaseAuth

class GarageTabViewModel: ObservableObject {
    @ObservedObject var sessionService = SessionService.shared
    @Published var currentLocation = "Loading..."
    @Published var isCustomer = false
    @ObservedObject private var orderRepository: OrderRepository = .shared
    @ObservedObject private var bengkelRepository: BengkelRepository = .shared

    static let shared = GarageTabViewModel()

    var customerMotors = [Motor]()
    var customerOrders = [Order]()
    var bengkel: Bengkel?

    private var subscriptions = Set<AnyCancellable>()

    @Published var customer: Customer?

    init() {
        if let id = Auth.auth().currentUser?.uid {
            getOrders(customerId: id)
        }
        getMotors()

    }

    private func getMotors() {
        SessionService.shared.$user.sink { [self] user in
            switch user {
            case .customer(let customer):
                isCustomer = true
                self.customer = customer
                if let motors = customer.motors {
                    customerMotors = motors
                }
                sessionService.selectedMotor = customerMotors.first
            default:
                isCustomer = false
            }
        }.store(in: &subscriptions)
    }

    private func getOrders(customerId: String) {
        orderRepository.fetch(customerId: customerId)
    }

    private func getBengkelFromOrder(bengkelId: String) {
        bengkelRepository.fetch(id: bengkelId) { bengkel in
            self.bengkel = bengkel
        }
    }
}
