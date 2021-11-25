//
//  MokuApp.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Firebase
import PartialSheet
import FirebaseDynamicLinks

@main
struct MokuApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @ObservedObject var session = SessionService.shared
    @ObservedObject var dynamicLinksService = DynamicLinksService.shared

    @StateObject var appState = AppState()

    @State var order: Order?

    var onboardingData = OnboardingDataModel.data
    @StateObject var sheetManager = PartialSheetManager()

    var body: some Scene {
        WindowGroup {
            if case .bookingDetail(let orderID) = dynamicLinksService.dynamicLinkTarget {
                NavigationView {
                    bookingDetail().onAppear {
                        OrderRepository.shared.fetch(orderID: orderID) { order in
                            self.order = order
                        }
                    }
                    .navigationBarTitle("Booking Detail", displayMode: .inline)
                    .navigationBarItems(leading: dismissButton())
                }
            } else {
                contentView()
                    .environmentObject(sheetManager)
                    .onOpenURL { url in
                        DynamicLinks.dynamicLinks().handleUniversalLink(url) { dynamicLink, _ in
                            guard let dynamicLink = dynamicLink else { return }
                            DynamicLinksService.shared.handleDynamicLink(dynamicLink: dynamicLink)
                        }
                    }
            }
        }
    }

    @ViewBuilder
    private func bookingDetail() -> some View {
        if let order = order {
            BookingDetail(order: order).padding(.top, .large)
        } else {
            VStack(spacing: 24) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text("Loading...")
            }
        }
    }

    @ViewBuilder
    private func dismissButton() -> some View {
        Button {
            dynamicLinksService.dynamicLinkTarget = nil
        } label: {
            Image(systemName: "chevron.backward")
        }
    }

    @ViewBuilder
    private func contentView() -> some View {
        if let user = session.user {
            switch user {
            case .bengkel(_):
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
