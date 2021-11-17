//
//  AssignMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import Foundation

extension AssignMechanics {
    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared
        @ObservedObject var orderRepository: OrderRepository = .shared
        @Published var order: Order
        @Published var bengkel: Bengkel?
        
        @Published var selectedMechanics = -1
        
        var availableMechs: [String]{
            var mechs: [String] = []
            var incomingOrder = order.schedule
            for existingOrder in orderRepository.filteredOrders {
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
            orderRepository.fetch(bengkelId: bengkel?.id ?? "")
        }
        
        private func fetchBengkel() {
            print("Chris Test")
            bengkelRepository.fetch(id: order.bengkelId) { bengkelData in
                self.bengkel = bengkelData
            }
        }
        
        func addMekanik() {
            if let bengkel = bengkel {
                OrderRepository.shared.addMekanik(orderId: self.order.id, mechanicsName: bengkel.mekaniks[selectedMechanics].name)
            }
        }
        
        func updateStatusOrder(){
            self.order.status = .onProgress
            
            //            TODO: PushNotif Chris
            orderRepository.update(order: order)
//            { _ in
//                BengkelRepository.shared.fetch(id: order.bengkelId) { bengkel in
//                    NotificationService.shared.send(to: [bengkel.fcmToken], notification: .orderCanceled(reason))
//                }
//            }
        }
    }
}
