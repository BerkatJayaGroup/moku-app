//
//  BengkelDetailViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Foundation
import Firebase

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

        var isLogin: Bool {
            if Auth.auth().currentUser == nil {
                return false
            } else {
                return true
            }
        }

        var operationalHours: String {
            var opHours: String
            var opHourOpen: String
            var opHourClose: String
            let open = bengkel.operationalHours.open
            let close = bengkel.operationalHours.close
            if open == 1 || open == 2 || open == 3 || open == 4 || open == 5 || open == 6 || open == 7 || open ==  8 || open == 9 {
                opHourOpen = "0\(open).00"
            } else {
                opHourOpen = "\(open).00"
            }
            if close == 1 || close == 2 || close == 3 || close == 4 || close == 5 || close == 6 || close == 7 || close == 8 || close == 9 {
                opHourClose = "0\(close).00"
            } else {
                opHourClose = "\(close).00"
            }
            opHours = "\(opHourOpen)-\(opHourClose)"
            return opHours
        }
    }
}
