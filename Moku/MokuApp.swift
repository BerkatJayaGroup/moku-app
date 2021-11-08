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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject var session = SessionService.shared

    @StateObject var appState = AppState()

    var onboardingData = OnboardingDataModel.data

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
                    PickRoleView()
                } else {
                    OnboardingView(data: onboardingData).environmentObject(appState)
                }
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        LocationService.shared.requestUserAuthorization()

        GooglePlacesService.register()
        GoogleMapsService.register()

        BengkelRepository.shared.add(bengkel: .preview)

        NotificationService.register(application: application)

        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
}
