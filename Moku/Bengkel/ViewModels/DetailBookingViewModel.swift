//
//  DetailBookingViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import Foundation
import SwiftUI

extension DetailBooking {
    class ViewModel: ObservableObject {
        @Published var customer: Customer?
        @Published var order: Order
        @Published var showModal: Bool
        init(order: Order, showModal: Bool) {
            self.order = order
            self.showModal = showModal
            CustomerRepository.shared.fetch(id: order.customerId) { customer in
                self.customer = customer
            }
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
        
        func updateStatusOrder() {
            self.order.status = .done

            //            TODO: PushNotif
            orderRepository.updateStatus(order: order) { _ in
                CustomerRepository.shared.fetch(id: self.order.customerId ) { customer in
                    guard let fcmToken = customer.fcmToken else { return }
                    NotificationService.shared.send(to: [fcmToken], notification: .done)
                }
            }
        }
    }
}
