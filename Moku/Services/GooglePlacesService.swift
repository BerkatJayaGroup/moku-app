//
//  GooglePlacesService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import Foundation
import GooglePlaces
import SwiftUI

final class GooglePlacesService: ObservableObject {
    static let shared = GooglePlacesService()

    private let client = GMSPlacesClient.shared()

    @Published var results = [Place]()

    private let searchFilter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .establishment
        filter.country = "ID"
        return filter
    }()

    private init() {}

    static func register() {
        GMSPlacesClient.provideAPIKey(SessionService.apiKey)
    }

    func runQuery(_ query: String) {
        let sanitizedQuery = query.trimmingCharacters(in: .whitespaces).lowercased()

        client.findAutocompletePredictions(
            fromQuery: sanitizedQuery,
            filter: searchFilter,
            sessionToken: nil
        ) { results, _ in
            if let results = results {
                self.results = results.map { Place(id: $0.placeID, name: $0.attributedFullText.string) }
            }
        }
    }
}
