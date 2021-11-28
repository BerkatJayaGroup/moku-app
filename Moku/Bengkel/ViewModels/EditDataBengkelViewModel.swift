//
//  SuntingDataBengkelViewModel.swift
//  Moku
//
//  Created by Mac-albert on 26/11/21.
//

import Foundation

extension EditDataBengkelView {
    final class ViewModel: ObservableObject {
        @Published var bengkel: Bengkel
        @Published var minPrice = ""
        @Published var maxPrice = ""
        @Published var selectedBrand = Set<Brand>()
        @Published var selectedCC = Set<Motorcc>()
        @Published var daySelected: [Bool]
        
        init(bengkel: Bengkel) {
            self.bengkel = bengkel
            self.selectedBrand = bengkel.brands
            self.daySelected = bengkel.operationalDays
            self.minPrice = bengkel.minPrice
            self.maxPrice = bengkel.maxPrice
        }
        
        func updateBengkel(){
            BengkelRepository.shared.update(bengkel: bengkel)
        }
        
    }
}

