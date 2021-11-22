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
    @Published var orderConfirmation: Order?

    private var cancellables = Set<AnyCancellable>()

    static let shared = OrderCustomerViewModel()

    init() {
        repository.$orders
            .assign(to: \.orders, on: self)
            .store(in: &cancellables)
    }

    func getCustomerOrder(docRef: DocumentReference) {
        repository.fetch(docRef: docRef) { order in
            self.orderConfirmation = order
        }
    }

    func cancelBooking(order: Order, reason: Order.CancelingReason) {

        DispatchQueue.main.async {[order] in
            var order = order
            order.cancelingReason = reason
            order.status = .canceled

            self.repository.updateStatus(order: order) { _ in
                BengkelRepository.shared.fetch(id: order.bengkelId) { bengkel in
                    NotificationService.shared.send(to: [bengkel.fcmToken], notification: .orderCanceled(reason))
                }
            }
        }
    }
}
