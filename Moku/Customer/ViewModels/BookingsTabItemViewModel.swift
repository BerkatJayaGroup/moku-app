//
//  BookingsViewModel.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import FirebaseAuth
import SwiftUI
import Combine

extension BookingsTabItem {
    class ViewModel: ObservableObject {
        @ObservedObject var orderRepo: OrderRepository = .shared
        @Published var segmentType = 0
        @Published var filteredOrders = [Order]()
        private var subscriptions = Set<AnyCancellable>()
        init() {
            if let uid = Auth.auth().currentUser?.uid {
                orderRepo.fetch(uid)
            }
            orderRepo.$filteredOrdersStatus.sink { [self] orders in
                filteredOrders = orders.filter { order in
                    if segmentType == 0 { return order.status == .onProgress }
                    else if segmentType == 1 { return order.status == .scheduled }
                    else { return order.status == .done }
                }
            }.store(in: &subscriptions)
            $segmentType.sink { [self] segment in
                filteredOrders = orderRepo.filteredOrdersStatus.filter { order in
                    if segment == 0 { return order.status == .onProgress }
                    else if segment == 1 { return order.status == .scheduled }
                    else { return order.status == .done }
                }
            }.store(in: &subscriptions)
        }
    }
}
