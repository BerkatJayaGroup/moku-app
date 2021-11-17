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
    @ObservedObject var dynamicLinkService = DynamicLinksService.shared

    @StateObject var appState = AppState()

    var onboardingData = OnboardingDataModel.data

    var body: some Scene {
        WindowGroup {
            if case .bookingDetail(_) = dynamicLinkService.dynamicLinkTarget {
                BookingDetail(order: .preview, bengkel: .preview)
            } else if let user = session.user {
                switch user {
                case .bengkel(_):
                    BengkelView()
                case let .customer(customer):
                    CustomerView(for: customer)
                }
            } else {
                if appState.hasOnboarded {
                    PickRoleView()
                        .onAppear {
                            dynamicLinkService.generateDynamicLink(order: .preview) { url in
                                print("Your short link is", url)
                            }
                        }
                        .onOpenURL { url in
                            print("Incoming URL parameter is: \(url)")
                            let linkHandled = DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, _ in
                                guard let dynamicLink = dynamicLink else { return }
                                self.dynamicLinkService.handleDynamicLink(dynamicLink)
                            }

                            if linkHandled {
                                print("Link Handled")
                            } else {
                                print("No Link Handled")
                            }
                        }
                } else {
                    OnboardingView(data: onboardingData).environmentObject(appState)
                }
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

        return true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {

    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

    }
}
