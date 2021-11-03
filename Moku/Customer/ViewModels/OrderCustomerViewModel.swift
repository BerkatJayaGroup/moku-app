//
//  OrderCustomerViewModel.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 02/11/21.
//

import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class OrderCustomerViewModel: ObservableObject {
    @ObservedObject private var repository: OrderRepository = .shared
    @Published var orders = [Order]()
    @Published var customerOrders = [Order]()
    
    private var cancellables = Set<AnyCancellable>()
    
    static let shared = OrderCustomerViewModel()
    
    init() {
        repository.$orders
            .assign(to: \.orders, on: self)
            .store(in: &cancellables)
        repository.$customerOrders
            .assign(to: \.customerOrders, on: self)
            .store(in: &cancellables)
    }
    
    func getCustomerOrder() {
        repository.fetchOrderForCustomer()
    }
}

