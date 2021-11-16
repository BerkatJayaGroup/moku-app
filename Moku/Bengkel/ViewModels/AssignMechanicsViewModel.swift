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
        @Published var bengkel: Bengkel? {
            didSet {
                print("bengkel cok: \(bengkel)")
            }
        }
        
        @Published var selectedMechanics = -1

        @Published var showMechs: Bool = true
        @Published var showDetailBook: Bool = false

        @Published var title: String

        init(order: Order, showMechs: Bool, title: String) {
            self.order = order
            self.showMechs = showMechs
            self.title = title
            fetchBengkel()
        }

        private func fetchBengkel() {
            print("Chris Test")
            bengkelRepository.fetch(id: order.bengkelId) { bengkelData in
                self.bengkel = bengkelData
            }
        }
    }
}
