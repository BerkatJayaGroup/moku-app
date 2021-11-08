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

        @ObservedObject private var orderRepository: OrderRepository = .shared

        private var subscription = Set<AnyCancellable>()

        var occupiedHours: [Int] {
            var hours: [Int] = []
            for number in orderRepository.filteredOrders {
                if Int(number.schedule.get(.day)) == Int(selectedDate.dayNumber) && Int(number.schedule.get(.month)) == Int(selectedDate.month) {
                    hours.append(number.schedule.get(.hour))
                }
            }
            return hours
        }

        init(bengkel: Bengkel, typeOfService: Order.Service) {
            self.bengkel = bengkel
            self.typeOfService = typeOfService
            if let uid = Auth.auth().currentUser?.uid {
                userId = uid
            }
            orderRepository.fetch(bengkel.id)

            $order.sink { order in
                self.isActive = order != nil
            }.store(in: &subscription)
        }

        func checkAvailability(index: Int) -> Bool {
            if occupiedHours.contains(index) {
                return true
            } else {
                return false
            }
        }
    }
}
