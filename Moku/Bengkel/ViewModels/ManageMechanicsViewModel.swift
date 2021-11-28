//
//  ManageMechanicsViewModel.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import Foundation
import SwiftUI

class ManageMechanicsViewModel: ObservableObject {
    @ObservedObject var bengkelRepository: BengkelRepository = .shared
    @Published var bengkel: Bengkel
    @Published var mechanics: [Mekanik]?
    
    init(bengkel: Bengkel){
        self.bengkel = bengkel
        fetchMechanics()
    }
    
    func fetchMechanics(){
        bengkelRepository.fetch(id: bengkel.id) { bengkel in
            self.bengkel = bengkel
        }
        mechanics = bengkel.mekaniks
    }
    
    
}
