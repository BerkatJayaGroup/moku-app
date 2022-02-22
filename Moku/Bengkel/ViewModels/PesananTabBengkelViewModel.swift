//
//  PesananTabBengkelViewModel.swift
//  Moku
//
//  Created by Mac-albert on 22/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Introspect

extension PesananTabBengkelView {
    class ViewModel: ObservableObject {
        @Published var bengkelOrders: [Order] = []
        @Published var customer: Customer?
        @Published var isHistoryShow: Bool = false
        @Published var isBengkelEmpty = false

        func viewOnAppear() {
            if let id = Auth.auth().currentUser?.uid {
                getBengkelOrders(bengkelId: id)
            }
        }

        func getBengkelOrders(bengkelId: String) {
            OrderRepository.shared.fetch(bengkelID: "MIuaoLvE2hftSjfv7h6YYg3NyPr2") { orders in
                self.bengkelOrders = orders
                    .filter { order in
                        //                    (order.status == .scheduled) && !(order.schedule.get(.day) == Date().get(.day))
                        true
                    }
                    .sorted { $0.schedule < $1.schedule }
            }
        }
    }
}
