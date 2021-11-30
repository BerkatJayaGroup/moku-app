//
//  ManageMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import Foundation
import SwiftUI
import FirebaseAuth

class ManageMechanicsViewModel: ObservableObject {
    @ObservedObject var bengkelRepository: BengkelRepository = .shared
    @Published var bengkel: Bengkel
    @Published var mechanics: [Mekanik]?
    @Published var bengkelId: String?

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
        fetchMechanics()
    }

    func fetchMechanics() {
        if let id = Auth.auth().currentUser?.uid {
            bengkelRepository.fetch(id: id) { bengkel in
                self.bengkel = bengkel
            }
            self.bengkelId = id
        }
        mechanics = bengkel.mekaniks
    }
}
