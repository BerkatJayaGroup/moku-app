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
        var bengkelRepository: BengkelRepository = .shared
        var customerRepository: CustomerRepository = .shared
        

        init(bengkel: Bengkel, selected: Int) {
            self.bengkel = bengkel
            self.selected = selected
        }

        func sendReview() {
            switch SessionService.shared.user {
            case .customer(let customer):
                bengkelRepository.addRating(bengkelId: bengkel.id,
                                            review: Review(user: customer.name,
                                                           rating: selected,
                                                           comment: text,
                                                           timestamp: Date()))
                print("udah kekirim")
            default: return
            }
        }
    }
}
