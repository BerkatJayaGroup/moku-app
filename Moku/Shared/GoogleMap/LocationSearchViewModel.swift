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

        @Published var selectedCoordinate = LocationService.shared.userCoordinate

        @Published var userAddress: String?

        @Published var searchQuery = ""

        var searchResults: [Place] {
            googlePlaces.results
        }

        @Published var isMapOpen = false

        private var subscriptions = Set<AnyCancellable>()

        init() {
            LocationService.shared.$userCoordinate.sink { coordinate in
                MapHelper.geocodeAddress(coordinate: coordinate) { result in
                    self.userAddress = result?.address
                }
            }.store(in: &subscriptions)

            $searchQuery.sink { query in
                self.googlePlaces.runQuery(query)
            }.store(in: &subscriptions)
        }
    }
}
