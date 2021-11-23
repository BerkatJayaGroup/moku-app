//
//  ReviewCellViewModel.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import Foundation

extension ReviewCell{
    class ViewModel: ObservableObject{
        @Published var order: Order?
        @Published var customer: Customer?
        
        init(order: Order){
            self.order = order
            getCustomerFromOrders(customerId: order.id)
        }
        
        func getCustomerFromOrders(customerId: String) {
            CustomerRepository.shared.fetch(id: customerId) { customer in
                self.customer = customer
            }
        }
    }
}
