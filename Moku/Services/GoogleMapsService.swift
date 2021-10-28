//
//  GoogleMapsService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import Foundation
import GoogleMaps

final class GoogleMapsService: ObservableObject {
    static let shared = GoogleMapsService()

    private init() {}

    static func register() {
        GMSServices.provideAPIKey(SessionService.apiKey)
    }
}
