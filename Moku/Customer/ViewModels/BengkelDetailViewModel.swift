//
//  BengkelDetailViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 27/10/21.
//

import Foundation

extension BengkelDetail {
    class ViewModel: ObservableObject {
        let bengkel: Bengkel

        @Published var address: String

        init(bengkel: Bengkel) {
            self.bengkel = bengkel

            address = bengkel.address

            MapHelper.geocode(absolute: true, coordinate: bengkel.coordinate) { address in
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
