//
//  BengkelTabItemViewModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 16/11/21.
//

import Combine
import SwiftUI
import FirebaseAuth

class BookingTabItemViewModel: ObservableObject {
    @ObservedObject private var orderRepository: OrderRepository = .shared
    @ObservedObject private var customerRepository: CustomerRepository = .shared

    static let shared = BookingTabItemViewModel()

    @Published var bengkelOrders: [Order]?
    @Published var customer: Customer?

    init() {
        if let id = Auth.auth().currentUser?.uid {
            getBengkelOrders(bengkelId: id)
        }
    }

    func getBengkelOrders(bengkelId: String) {
        orderRepository.fetchBengkelOrder(bengkelId: bengkelId) { order in
            self.bengkelOrders = order
        }
    }

    func getCustomerFromOrders(customerId: String) {
        customerRepository.fetch(id: customerId) { customer in
            self.customer = customer
        }
    }
}
