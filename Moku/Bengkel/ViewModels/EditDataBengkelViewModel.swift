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
        @Published var showSheetClose = false
        @Published var openHours: Int = 0
        @Published var closeHours: Int = 0

        init(bengkel: Bengkel) {
            self.bengkel = bengkel
            self.selectedBrand = bengkel.brands
            self.daySelected = bengkel.operationalDays
            self.minPrice = bengkel.minPrice
            self.maxPrice = bengkel.maxPrice
            self.openHours = bengkel.operationalHours.open
            self.closeHours = bengkel.operationalHours.close
        }

        func updateBengkel() {
            let newBengkel = Bengkel(id: bengkel.id,
                                     owner: bengkel.owner,
                                     name: bengkel.name,
                                     phoneNumber: bengkel.phoneNumber,
                                     location: bengkel.location,
                                     operationalHours: Bengkel.OperationalHours(open: openHours, close: closeHours),
                                     operationalDays: daySelected,
                                     photos: bengkel.photos,
                                     brands: selectedBrand,
                                     mekaniks: bengkel.mekaniks,
                                     minPrice: minPrice,
                                     maxPrice: maxPrice,
                                     fcmToken: bengkel.fcmToken
            )
            BengkelRepository.shared.update(bengkel: newBengkel)
        }
    }
}
