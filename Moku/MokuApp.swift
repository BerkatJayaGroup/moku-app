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
    @ObservedObject var session = SessionService.shared

    @StateObject var appState = AppState()

    var onboardingData = OnboardingDataModel.data

    init() {
        FirebaseApp.configure()

        LocationService.shared.requestUserAuthorization()

        GooglePlacesService.register()
        GoogleMapsService.register()
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
//                    PickRoleView()
                    BookingConfirmationView()
                } else {
                    OnboardingView(data: onboardingData).environmentObject(appState)
//                    BookingConfirmationView()
                }
            }
        }
    }
}
