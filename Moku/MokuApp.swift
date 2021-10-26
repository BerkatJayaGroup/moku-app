//
//  MokuApp.swift
//  Moku
//
//  Created by Christianto Budisaputra on 11/10/21.
//

import SwiftUI
import Firebase
import GoogleMaps

struct BengkelView: View {
    @State var bengkel: Bengkel

    init(from bengkel: Bengkel) {
        _bengkel = State(wrappedValue: bengkel)
    }

    var body: some View {
        Text("Bengkel View")
    }
}

struct CustomerView: View {
    @State var customer: Customer

    init(from customer: Customer) {
        _customer = State(wrappedValue: customer)
    }

    var body: some View {
        Text("\(customer.name) - \(customer.phoneNumber)")
    }
}

@main
struct MokuApp: App {
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = LocationManager.shared
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    @ObservedObject var userLocation = LocationManager.shared
    @ObservedObject var session = SessionService.shared
    
    @StateObject var appState = AppState(hasOnboarded: false)
    
    var onboardingData = OnboardingDataModel.data

    init() {
        FirebaseApp.configure()
        GMSServices.provideAPIKey("AIzaSyDs--hrfb86N3WtmfbMXMoah4MiZcfzLF4")

        locationManager.requestWhenInUseAuthorization()
    }

    var body: some Scene {
        
        WindowGroup {
            //            ContentView()
            if let user = session.user {
                switch user {
                case let .bengkel(bengkel):
                    BengkelView(from: bengkel)
                case let .customer(customer):
                    CustomerView(from: customer)
                }
            } else {
                // Suruh Login...
                // Chris nitip
                if appState.hasOnboarded {
                    BengkelTabItem()
                } else {
                    OnboardingView(data: onboardingData).environmentObject(appState)
                }
            }
        }
    }
}

final class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    @Published var coordinate = CLLocationCoordinate2D(latitude: 5, longitude: 105)

    static let shared = LocationManager()

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Mashoook!")
        guard let recentLocation = locations.last else { return }
        coordinate = recentLocation.coordinate
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}

struct GoogleMapView: UIViewRepresentable {
    @Binding var coordinate: CLLocationCoordinate2D

    private let mapView = GMSMapView(frame: .zero)
    private let zoomLevel: Float = 18

    let onAnimationEnded: () -> Void

    func makeUIView(context: Context) -> GMSMapView {
        mapView.camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: zoomLevel)
        mapView.delegate = context.coordinator
        mapView.isUserInteractionEnabled = true

        marker.map = mapView

        return mapView
    }

    func updateUIView(_ uiView: GMSMapView, context: Context) {

    }

    func makeCoordinator() -> GoogleMapViewCoordinator {
        GoogleMapViewCoordinator(self)
    }

    final class GoogleMapViewCoordinator: NSObject, GMSMapViewDelegate {
        var mapView: GoogleMapView

        init(_ mapView: GoogleMapView) {
            self.mapView = mapView
        }

        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            self.mapView.onAnimationEnded()
        }

        func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
            print("Kelar drag:", marker.position)
        }
    }
}

extension GoogleMapView {
    private var marker: GMSMarker {
        let marker = GMSMarker(position: coordinate)
        marker.isDraggable = true
        marker.appearAnimation = .pop
        return marker
    }
}
