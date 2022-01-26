//
//  ManageMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Combine

class ManageMechanicsViewModel: ObservableObject {
    @ObservedObject var bengkelRepository: BengkelRepository = .shared
    @ObservedObject var sessionService = SessionService.shared
    @Published var bengkel: Bengkel
    @Published var mechanics: [Mekanik]?
    @Published var isLoading: Bool = false
    private var subscriptions = Set<AnyCancellable>()

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
        fetchMechanics()
    }

    func fetchMechanics() {
        if let id = Auth.auth().currentUser?.uid {
            self.bengkelRepository.fetch(id: id) { bengkel in
                self.bengkel = bengkel
                self.mechanics = self.bengkel.mekaniks
                self.isLoading = false
            }
        }
    }
}
