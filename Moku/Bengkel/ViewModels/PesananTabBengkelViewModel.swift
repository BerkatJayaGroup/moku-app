//
//  PesananTabBengkelViewModel.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth

extension PesananTabBengkelView {
    class ViewModel: ObservableObject {
        @ObservedObject var orderRepository: OrderRepository = .shared
        @ObservedObject var customerRepository: CustomerRepository = .shared
        
        @Published var bengkelOrders: [Order]?
        @Published var customer: Customer?
        
        init() {
            if let id = Auth.auth().currentUser?.uid {
                getBengkelOrders(bengkelId: id)
            }
        }

        @ViewBuilder func showUlasan() -> some View {
            if let bengkelOrders = bengkelOrders {
                LazyVStack {
                    ForEach(bengkelOrders, id: \.id) { order in
                        ReviewCell(order: order)
                    }
                }
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
}
