//
//  CustomerViewModel.swift
//  Moku
//
//  Created by Mac-albert on 28/10/21.
//

import Combine
import SwiftUI

final class CustomerViewModel: ObservableObject{
    private let repository: CustomerRepository = .shared
    
    static let shared = CustomerViewModel()
    
    private init() {}
    
    func create (_ customer: Customer){
        repository.add(customer: customer)
    }
}
