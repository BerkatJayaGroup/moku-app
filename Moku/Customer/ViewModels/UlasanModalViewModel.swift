//
//  UlasanModalViewModel.swift
//  Moku
//
//  Created by Mac-albert on 11/11/21.
//

import Foundation
import SwiftUI

extension UlasanModal {
    class ViewModel: ObservableObject {
        @Published var selected: Int
        @Published var text = ""
        @Published var isCheck: Bool = false
        @Published var bengkel: Bengkel
        @Published var isDoneReview: Bool = false
        @Published var order: Order
        var bengkelRepository: BengkelRepository = .shared
        var customerRepository: CustomerRepository = .shared
        @ObservedObject var bengkelViewModel = BengkelTabItem.ViewModel.shared

        init(bengkel: Bengkel, selected: Int, order: Order) {
            self.bengkel = bengkel
            self.selected = selected
            self.order = order
        }

        func sendReview() {
            switch SessionService.shared.user {
            case .customer(let customer):
                bengkelRepository.addRating(bengkelId: bengkel.id,
                                            review: Review(user: customer.name,
                                                           rating: selected,
                                                           comment: text))
               removeFromToRate(order: order, customer: customer)
            default: return
            }
        }
        func removeFromToRate(order: Order, customer: Customer) {
            DispatchQueue.main.async { [customer] in
                var customer = customer
                if let index = customer.ordersToRate?.firstIndex(of: order.id) {
                    customer.ordersToRate?.remove(at: index)
                }

                self.customerRepository.update(customer: customer) { newCustomer in
                    self.bengkelViewModel.getOrdersToRate(from: newCustomer.ordersToRate)
                }
            }
        }
    }
}
