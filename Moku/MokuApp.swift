//
//  MokuApp.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Firebase
import PartialSheet

@main
struct MokuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject var session = SessionService.shared

    @StateObject var appState = AppState()

    var onboardingData = OnboardingDataModel.data
    @StateObject var sheetManager = PartialSheetManager()

    var body: some Scene {
        WindowGroup {
//            contentView()
            DetailBooking(order: .preview)
                .environmentObject(sheetManager)
        }
    }
    @ViewBuilder func contentView() -> some View {
        if let user = session.user {
            switch user {
            case .bengkel(_):
                BengkelView()
            case let .customer(customer):
//                CustomerView(for: customer)
                AssignMechanicsView().environmentObject(sheetManager)
            }
        } else {
            if appState.hasOnboarded {
//                AssignMechanicsView().environmentObject(sheetManager)
                PickRoleView()
            } else {
                OnboardingView(data: onboardingData).environmentObject(appState)
            }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()

        SessionService.shared.setup()

        LocationService.shared.requestUserAuthorization()

        GooglePlacesService.register()
        GoogleMapsService.register()

        NotificationService.register(application: application)

        //        BengkelRepository.shared.add(bengkel: .preview)

        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
}
