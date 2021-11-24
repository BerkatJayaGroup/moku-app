//
//  BengkelDetailViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Foundation

extension BengkelDetail {
    class ViewModel: ObservableObject {
        @Published var bengkel: Bengkel
        @Published var typeOfService: Order.Service = .servisRutin

        @Published var address: String
        @Published var isOperatinalHoursSheetShowing = false

        init(bengkel: Bengkel) {
            self.bengkel = bengkel

            // Address Related
            // Temporary address, will resolve this in the future
            address = bengkel.address

            MapHelper.geocodeCity(coordinate: bengkel.coordinate) { address in
                self.address = address
            }
        }

        var distance: String {
            MapHelper.stringify(distance: bengkel.distance)
        }

        var operationalHours: String {
            "\(bengkel.operationalHours.open).00 - \(bengkel.operationalHours.close).00"
        }
    }
}
