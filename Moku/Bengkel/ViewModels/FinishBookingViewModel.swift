//
//  ServiceInformationViewModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 26/11/21.
//

import SwiftUI
import Combine
import SwiftUIX

class FinishBookingViewModel: ObservableObject {
    @ObservedObject var orderRepository: OrderRepository = .shared
    @Published var spareParts: [String] = []
    @Published var notes = ""
    @Published var billPhotos: [String] = []
    @Published var isSubmitting = false
    @Published var customer: Customer?

    @Published var order: Order

    init(order: Order) {
        self.order = order
        getCustomerFromOrders(customerId: order.customerId)
    }

    var motorName: String {
        return order.motor.model
    }

    var isFormValid: Bool {
        !spareParts.isEmpty && !notes.isEmpty && !notes.isEmpty
    }

    func updateOrder(order: Order) {
        orderRepository.updateStatus(order: order) { _ in
            CustomerRepository.shared.fetch(id: self.order.customerId ) { customer in
                guard let fcmToken = customer.fcmToken else { return }
                NotificationService.shared.send(to: [fcmToken], notification: .updateOrderStatus(order.status))
            }
            self.orderRepository.fetchBengkelOrder(bengkelId: self.order.bengkelId)
        }
    }

    func getCustomerFromOrders(customerId: String) {
        CustomerRepository.shared.fetch(id: customerId) { customer in
            self.customer = customer
        }
    }

}
