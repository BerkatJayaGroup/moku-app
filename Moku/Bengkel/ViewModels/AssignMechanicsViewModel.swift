//
//  AssignMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import Foundation

class AssignMechanicsViewModel: ObservableObject {
    @ObservedObject var bengkelRepository: BengkelRepository = .shared
    @ObservedObject var orderRepository: OrderRepository = .shared
    @Published var order: Order

    @Published var orders = [Order]()
    @Published var bengkel: Bengkel?

    @Published var selectedMechanics = -1

    var unavailableMechs: [String] {
        var mechs: [String] = []
        let incomingOrder = order.schedule
        for existingOrder in orders {
            if Int(incomingOrder.get(.day)) == Int(existingOrder.schedule.get(.day)) &&
                Int(incomingOrder.get(.month)) == Int(existingOrder.schedule.get(.month)) &&
                Int(incomingOrder.get(.hour)) == Int(existingOrder.schedule.get(.hour)) {
                mechs.append(existingOrder.mechanicName ?? "")
            }
        }
        return mechs
    }

    init(order: Order) {
        self.order = order
        fetchBengkel()
        orderRepository.fetch(bengkelId: order.bengkelId) { orders in
            self.orders = orders
        }
    }

    private func fetchBengkel() {
        bengkelRepository.fetch(id: order.bengkelId) { bengkelData in
            self.bengkel = bengkelData
        }
    }
    func addMekanik() {
        if let bengkel = bengkel {
            OrderRepository.shared.addMekanik(orderId: self.order.id, mechanicsName: bengkel.mekaniks[selectedMechanics].name)
        }
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
            self.orderRepository.fetchBengkelOrder(bengkelId: self.order.bengkelId) { orders in
                self.orders = orders
            }
        }
    }
}
