//
//  BookingsViewModel.swift
//  Moku
//
//  Created by Dicky Buwono on 08/11/21.
//

import FirebaseAuth
import SwiftUI
import Combine

final class BookingsTabItemViewModel: ObservableObject {
    @ObservedObject var orderRepo: OrderRepository = .shared

    @Published var segmentSelection: SegmentType = .inProgress {
        didSet {
            getSegmentedOrders(segment: segmentSelection)
        }
    }

    @Published var segmentedOrders: [Order] = []

    private var user: User? {
        Auth.auth().currentUser
    }

    func viewOnAppear() {
        getSegmentedOrders(segment: segmentSelection)
    }

    private func getSegmentedOrders(segment: SegmentType) {
//        guard let currentUserID = user?.uid else { return }
//        orderRepo.fetch(userID: currentUserID) { orders in
        orderRepo.fetch(userID: "MIuaoLvE2hftSjfv7h6YYg3NyPr2") { orders in
            self.segmentedOrders = orders.filter { order in
                switch self.segmentSelection {
                case .inProgress:
                    return order.status == .onProgress
                case .scheduled:
                    return order.status == .scheduled
                case .history:
                    return order.status == .done
                }
            }
        }
    }
}

extension BookingsTabItemViewModel {
    enum SegmentType: String, Identifiable, CaseIterable {
        case inProgress = "Dalam Progres"
        case scheduled = "Terjadwal"
        case history = "Riwayat"

        var id: String { rawValue }
    }

    var segments: [SegmentType] {
        SegmentType.allCases
    }
}
