//
//  LocationService.swift
//  Moku
//
//  Created by Christianto Budisaputra on 26/10/21.
//

import CoreLocation

final class LocationService: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()

    static let shared = LocationService()

    @Published var userCoordinate = CLLocationCoordinate2D(latitude: 0, longitude: 0)

    private override init() {
        super.init()
        configureLocationManager()
    }

    private func configureLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func requestUserAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let recentLocation = locations.last {
            userCoordinate = recentLocation.coordinate
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
