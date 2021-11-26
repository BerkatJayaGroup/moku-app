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
        @Published var isHistoryShow: Bool = false
        
        init() {
            if let id = Auth.auth().currentUser?.uid {
                getBengkelOrders(bengkelId: id)
            }
        }

        @ViewBuilder func showUlasan() -> some View {
            if let bengkelOrders = bengkelOrders {
                LazyVStack {
                    ForEach(bengkelOrders, id: \.id) { order in
                        if order.status == .scheduled && !(order.schedule.get(.day) == Date().get(.day)) {
                            NavigationLink(destination: {
                                DetailBooking(order: order)
                            }, label: {
                                ReviewCell(order: order)
                            })
                        }
                    }
                }
                .padding()
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
