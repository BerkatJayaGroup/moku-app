//
//  AssignMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 16/11/21.
//

import SwiftUI
import Foundation

extension AssignMechanics {
    class ViewModel: ObservableObject {
        @ObservedObject var bengkelRepository: BengkelRepository = .shared
        @Published var order: Order
        @Published var bengkel: Bengkel? 
        
        @Published var selectedMechanics = -1

        init(order: Order) {
            self.order = order
            fetchBengkel()
        }

        private func fetchBengkel() {
            print("Chris Test")
            bengkelRepository.fetch(id: order.bengkelId) { bengkelData in
                self.bengkel = bengkelData
            }
        }
        
        func addMekanik() {
            if let bengkel = bengkel {
                OrderRepository.shared.addMekanik(orderId: self.order.id, mechanicsName: bengkel.mekaniks[selectedMechanics].name)
            }
        }
    }
}
