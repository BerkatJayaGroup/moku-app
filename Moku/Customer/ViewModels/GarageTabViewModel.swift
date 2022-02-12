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
    @Published var customerOrders = [Order]()
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
    
    func getMotors(completionHandler: ((Customer) -> Void)? = nil) {
        if let userId = Auth.auth().currentUser?.uid {
            CustomerRepository.shared.fetch(id: userId) { [weak self] customer in
                self?.customerMotors = customer.motors ?? []
                completionHandler?(customer)
            }
        }
    }

    func removeMotor(motorID: String, motors: [Motor]?) {
        getMotors { cst in
            var newMotors = (motors ?? []) as [Motor]
            var newCustomer = cst
            guard let index = newMotors.firstIndex(where: { $0.id == motorID }) else { return }
            newMotors.remove(at: index)
            newCustomer.motors?.removeAll()
            for motor in newMotors {
                newCustomer.motors?.append(motor)
            }
            self.customerRepository.update(customer: newCustomer) { cust in
                self.customer = cust
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
        getMotors { cst in
            var newCustomer = cst
            newCustomer.motors?.append(motor)
            self.customerRepository.update(customer: newCustomer) { customer in
                self.customer = customer
            }
        }
    }
    func updateMotor(motorID: String, updatedMotor: Motor, motors: [Motor]?) {
        getMotors { cst in
            var newMotors = (motors ?? []) as [Motor]
            var newCustomer = cst
            guard let index = newMotors.firstIndex(where: { $0.id == motorID }) else { return }
            newMotors[index] = updatedMotor
            newCustomer.motors?.removeAll()
            for motor in newMotors {
                newCustomer.motors?.append(motor)
            }
            self.customerRepository.update(customer: newCustomer) { cust in
                self.customer = cust
            }
        }
    }
}
