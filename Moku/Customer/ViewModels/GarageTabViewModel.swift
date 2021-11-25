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
    @ObservedObject private var customerRepository: CustomerRepository = .shared

    static let shared = GarageTabViewModel()

    @Published var customerMotors = [Motor]()
    @Published var customerOrders = [Order]() {
        didSet {
            customerOrders.forEach { order in
                print(order.id)
            }
        }
    }
    @Published var bengkel: Bengkel?

    private var subscriptions = Set<AnyCancellable>()

    @Published var customer: Customer?

    init() {
        if let id = Auth.auth().currentUser?.uid {
            getOrders(customerId: id)
        }
        sessionService.$user.sink { user in
            if case .customer(let customer) = user {
                self.customer = customer
                self.customerMotors = customer.motors ?? []
            }
        }.store(in: &subscriptions)
    }

    func removeMotor(motorID: String) {
        if case .customer(var customer) = sessionService.user {
            guard let index = customerMotors.firstIndex(where: { $0.id == motorID }) else { return }
            customer.motors?.remove(at: index)
            customerRepository.update(customer: customer) { customer in
                self.customer = customer
            }
        }
    }
    func update(_ customer: Customer) {
        customerRepository.update(customer: customer) { updatedCustomer in
            self.customer = updatedCustomer
        }
    }

    private func getOrders(customerId: String) {
        orderRepository.fetchOrderHistory(customerId: customerId) { order in
            self.customerOrders = order
        }
    }

    func getBengkelFromOrder(bengkelId: String) {
        bengkelRepository.fetch(id: bengkelId) { bengkel in
            self.bengkel = bengkel
        }
    }

    func addNew(motor: Motor) {
        if case .customer(var customer) = sessionService.user {
            customer.motors?.append(motor)
            customerRepository.update(customer: customer) { customer in
                self.customer = customer
            }
        }
    }
    func updateMotor(motorID: String, updatedMotor: Motor) {
        if case .customer(var customer) = sessionService.user {
            guard let index = customerMotors.firstIndex(where: { $0.id == motorID }) else { return }
            customer.motors?[index] = updatedMotor
            customerRepository.update(customer: customer) { customer in
                self.customer = customer
            }
        }
    }
}
