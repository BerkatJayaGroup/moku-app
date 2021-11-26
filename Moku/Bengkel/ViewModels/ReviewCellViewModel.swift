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
        
        var schedule: String{
            var scheduleTime: String
            if let schedule = order?.schedule{
                scheduleTime = Date.convertDateFormat(date: schedule, format: "EEEE, MMM d, yyyy")
            }
            return schedule
        }
        
        init(order: Order){
            self.order = order
            getCustomerFromOrders(customerId: order.customerId)
        }
        
        func getCustomerFromOrders(customerId: String) {
            CustomerRepository.shared.fetch(id: customerId) { customer in
                self.customer = customer
            }
        }
    }
}
