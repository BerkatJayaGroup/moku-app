//
//  BengkelDateViewModel.swift
//  Moku
//
//  Created by Mac-albert on 08/11/21.
//

import Foundation
import Combine
import SwiftUI
import FirebaseAuth

extension BengkelDate {
    class ViewModel: ObservableObject {
        @Published var isActive = false
        @Published var bengkel: Bengkel
        @Published var order: Order?
        @Published var typeOfService: Order.Service
        @Published var userId = ""
        @Published var text = ""
        @Published var hour = 0
        @Published var schedule = Date()
        @Published var selectedHourndex: Int = -1
        @Published var selectedDate: BookDate = BookDate.default
        @Published var availableMech: Int

        @ObservedObject private var orderRepository: OrderRepository = .shared

        private var subscription = Set<AnyCancellable>()

        var occupiedHours: [String: Int] {
            var hours: [String: Int] = [:]
            for number in orderRepository.filteredOrders {
                if Int(number.schedule.get(.day)) == Int(selectedDate.dayNumber) && Int(number.schedule.get(.month)) == Int(selectedDate.month) {
                    if hours.keys.contains(String(number.schedule.get(.hour))) {
                        hours[String(number.schedule.get(.hour))]! += 1
                    } else {
                        hours[String(number.schedule.get(.hour))] = 1
                    }
                }
            }
            return hours
        }

        init(bengkel: Bengkel, typeOfService: Order.Service) {
            self.bengkel = bengkel
            self.typeOfService = typeOfService
            self.availableMech = bengkel.mekaniks.count
            if let uid = Auth.auth().currentUser?.uid {
                userId = uid
            }
            orderRepository.fetch(bengkelId: bengkel.id)
            $order.sink { order in
                self.isActive = order != nil
            }.store(in: &subscription)
        }

        func checkAvailability(index: Int) -> Bool {
//        TODO: GET MEKANIK MOTOR.COUNT
            if occupiedHours.keys.contains(String(index)) && /* bengkel.mekaniks.count */ 4  <= occupiedHours[String(index)] ?? 0 {
                return true
            } else {
                return false
            }
        }
    }
}
