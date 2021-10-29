//
//  BengkelOwnerOnboardingViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 29/10/21.
//

import SwiftUI
import Combine
import GoogleMaps
import CoreLocation

extension BengkelOwnerOnboardingView {
    final class ViewModel: ObservableObject {
        @Published var location: Location?

        @Published var name: String = ""

        @Published var phoneNumber: String = ""

        @Published var selectedCoordinate: CLLocationCoordinate2D = LocationService.shared.userCoordinate

        @Published var query = ""

        var results: [Place] {
            googlePlaces.results
        }

        @ObservedObject var googlePlaces = GooglePlacesService.shared

        @Published var isMapOpen = false

        func openMap() {
            isMapOpen = true
        }

        func closeMap() {
            isMapOpen = false
        }

        var mapView: GMSMapView?

        private var subscriptions = Set<AnyCancellable>()

        init() {
            $query.sink { [self] query in
                googlePlaces.runQuery(query)
            }.store(in: &subscriptions)
        }

        func setBengkelLocation(as location: Place) {
            googlePlaces.getDetail(for: location.id) { place in
                if let address = place.formattedAddress {
                    let newLocation = Location(
                        address: address,
                        longitude: place.coordinate.longitude,
                        latitude: place.coordinate.latitude
                    )

                    self.name = place.name ?? ""
                    self.location = newLocation
                    self.selectedCoordinate = CLLocationCoordinate2D(
                        latitude: place.coordinate.latitude,
                        longitude: place.coordinate.longitude
                    )
                }
            }
        }

        func assignMapView(_ mapView: GMSMapView) {
            self.mapView = mapView
        }

        func centerLocation() {
            let center = GMSCameraUpdate.setTarget(selectedCoordinate)
            mapView?.moveCamera(center)
        }

        var address: String? {
            location?.address
        }
    }
}
