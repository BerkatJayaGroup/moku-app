//
//  LocationSearchViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 31/10/21.
//

import SwiftUI
import Combine

extension LocationSearchView {
    class ViewModel: ObservableObject {
        @ObservedObject private var googlePlaces = GooglePlacesService.shared

        @Published var userLocation: Location?

        @Published var searchQuery = ""

        var searchResults: [Place] {
            googlePlaces.results
        }

        @Published var isMapOpen = false

        private var subscriptions = Set<AnyCancellable>()

        init() {
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocodeAddress(coordinate: coordinate) { result in
                    if let address = result?.address, let coordinate = result?.coordinate {
                        self.userLocation = Location(
                            address: address,
                            longitude: coordinate.longitude,
                            latitude: coordinate.latitude
                        )
                    }
                }
            }.store(in: &subscriptions)

            $searchQuery.sink { query in
                self.googlePlaces.runQuery(query)
            }.store(in: &subscriptions)
        }

        func getLocation(from place: Place, completionHandler: ((Location) -> Void)? = nil) {
            googlePlaces.getDetail(for: place.id) { place in
                let location = Location(
                    name: place.name,
                    address: place.formattedAddress ?? "Unnamed Road",
                    longitude: place.coordinate.longitude,
                    latitude: place.coordinate.latitude
                )

                completionHandler?(location)
            }
        }
    }
}
