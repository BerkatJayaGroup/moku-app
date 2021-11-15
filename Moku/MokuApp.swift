//
//  MokuApp.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Firebase

@main
struct MokuApp: App {
    @ObservedObject var session: SessionService

    @StateObject var appState = AppState()

    var onboardingData = OnboardingDataModel.data

    init() {
        FirebaseApp.configure()
        session = .shared
        LocationService.shared.requestUserAuthorization()

        GooglePlacesService.register()
        GoogleMapsService.register()

        CustomerRepository.shared.add(customer: .preview)
//        BengkelRepository.shared.add(bengkel: .preview)
    }

    var body: some Scene {
        WindowGroup {
            if let user = session.user {
                switch user {
                case let .bengkel(bengkel):
                    BengkelView()
                case let .customer(customer):
                    CustomerView(for: customer)
                }
            } else {
                if appState.hasOnboarded {
                    BengkelTabItem()
                } else {
                    OnboardingView(data: onboardingData).environmentObject(appState)
                }
            }
        }
    }
}
