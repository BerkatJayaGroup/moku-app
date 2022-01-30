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

        @ViewBuilder
        func showUlasan() -> some View {
            if let bengkelOrders = bengkelOrders {
                let orderSorted = bengkelOrders.sorted(by: { $0.schedule < $1.schedule })
                LazyVStack {
                    ForEach(orderSorted, id: \.id) { order in
                        if order.status == .scheduled && !(order.schedule.get(.day) == Date().get(.day)) {
                            NavigationLink(destination: {
                                DetailBooking(order: order)
                            }, label: {
                                ReviewCell(order: order)
                            })
                                .padding(10)
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.width * 0.25)
                                .background(AppColor.primaryBackground)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                        }
                    }
                }
                .padding(.vertical, 15)
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
