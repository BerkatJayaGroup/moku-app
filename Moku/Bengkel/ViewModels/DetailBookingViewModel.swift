//
//  DetailBookingViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import Foundation
import SwiftUI

extension DetailBookingView {
    class ViewModel: ObservableObject {
        @ObservedObject var orderRepository: OrderRepository = .shared

        @Published var customer: Customer?
        @Published var order: Order
        @Published var showModal: Bool

        init(order: Order, showModal: Bool) {
            self.order = order
            self.showModal = showModal
        }

        var motorModel: String {
            order.motor.model
        }

        var customerName: String {
            customer?.name ?? ""
        }

        var customerNumber: String {
            customer?.phoneNumber ?? "-"
        }

        var orderDate: String {
            Date.convertDateFormat(date: order.schedule, format: "EEE, MMM d, yyyy")
        }

        var orderHour: String {
            "\(order.schedule.get(.hour)):00"
        }

        var typeOfService: String {
            order.typeOfService.rawValue
        }

        var notes: String {
            order.notes ?? ""
        }

        func updateStatusOrder(status: Order.Status, reason: Order.CancelingReason? = nil) {
            self.order.status = status
            if let reason = reason {
                self.order.cancelingReason = reason
            }
            orderRepository.updateStatus(order: order) { _ in
                CustomerRepository.shared.fetch(id: self.order.customerId ) { customer in
                    guard let fcmToken = customer.fcmToken else { return }
                    NotificationService.shared.send(to: [fcmToken], notification: .updateOrderStatus(status))
                }
                self.orderRepository.fetchBengkelOrder(bengkelId: self.order.bengkelId)
            }
        }

        func viewOnAppear() {
            CustomerRepository.shared.fetch(id: order.customerId) { customer in
                self.customer = customer
            }
        }
    }
}
