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

        @Published var address: String?
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
            var opHours: String
            var opHourOpen: String
            var opHourClose: String
            let open = bengkel.operationalHours.open
            let close = bengkel.operationalHours.close
            if (1...9).contains(open) {
                opHourOpen = "0\(open).00"
            } else {
                opHourOpen = "\(open).00"
            }
            if (1...9).contains(close) {
                opHourClose = "0\(close).00"
            } else {
                opHourClose = "\(close).00"
            }
            opHours = "\(opHourOpen)-\(opHourClose)"
            return opHours
        }
    }
}
