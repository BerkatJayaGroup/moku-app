//
//  AssignMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import Foundation

class AssignMechanicsViewModel: ObservableObject {
    @Published var order: Order

    @Published var orders = [Order]()
    @Published var bengkel: Bengkel?

    @Published var selectedMechanics = -1

    var unavailableMechs: [String] {
        var mechs: [String] = []
        let incomingOrder = order.schedule
        for existingOrder in orders {
            if isToday(incomingOrder: incomingOrder, existingOrder: existingOrder.schedule) {
                mechs.append(existingOrder.mechanicName ?? "")
            }
        }
        return mechs
    }

    private func isToday(incomingOrder: Date, existingOrder: Date) -> Bool {
        if Int(incomingOrder.get(.day)) == Int(existingOrder.get(.day)) &&
            Int(incomingOrder.get(.month)) == Int(existingOrder.get(.month)) &&
            Int(incomingOrder.get(.hour)) == Int(existingOrder.get(.hour)) {
            return true
        } else {
            return false
        }
    }

    init(order: Order) {
        self.order = order
    }

    func viewOnAppear() {
        BengkelRepository.shared.fetch(id: "DuyvQ9BX8dfF7HS5KhxOZm4KivE3") { workshop in
            self.bengkel = workshop
        }
        OrderRepository.shared.fetch(bengkelId: order.bengkelId) { orders in
            DispatchQueue.main.async {
                self.orders = orders
            }
        }
    }

    func addMekanik() {
        if let bengkel = bengkel {
            OrderRepository.shared.addMekanik(orderId: self.order.id, mechanic: bengkel.mekaniks[selectedMechanics])
        }
    }

    func updateStatusOrder(status: Order.Status, reason: Order.CancelingReason? = nil) {
        self.order.status = status
        if let reason = reason {
            self.order.cancelingReason = reason
        }
        OrderRepository.shared.updateStatus(order: order) { _ in
            CustomerRepository.shared.fetch(id: self.order.customerId ) { customer in
                guard let fcmToken = customer.fcmToken else { return }
                NotificationService.shared.send(to: [fcmToken], notification: .updateOrderStatus(status))
            }
            OrderRepository.shared.fetchBengkelOrder(bengkelId: self.order.bengkelId) { orders in
                self.orders = orders
            }
        }
    }
}
