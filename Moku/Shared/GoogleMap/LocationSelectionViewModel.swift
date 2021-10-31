//
//  LocationSelectionViewModel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 31/10/21.
//

import CoreLocation
import GoogleMaps

extension LocationSelectionView {
    private struct LocationDefault {
        static let locationName = "Unknown Location"
        static let locationAddress = "An error occured while getting the address, please try again."
    }

    class ViewModel: ObservableObject {
        @Published var selectedCoordinate: CLLocationCoordinate2D = LocationService.shared.userCoordinate

        @Published var selectedLocationName: String = LocationDefault.locationName
        @Published var selectedLocationAddress: String = LocationDefault.locationAddress

        @Published var mapView: GMSMapView?

        var isLocationValid: Bool {
            selectedLocationName != LocationDefault.locationName && selectedLocationAddress != LocationDefault.locationAddress
        }

        init() {
            geocodeAddress(coordinate: selectedCoordinate)
        }

        func assignMapView(_ mapView: GMSMapView) {
            self.mapView = mapView
        }

        func centerMapView() {
            let center = GMSCameraUpdate.setTarget(selectedCoordinate)
            mapView?.moveCamera(center)
        }

        func updateCoordinate(_ coordinate: CLLocationCoordinate2D) {
            geocodeAddress(coordinate: coordinate)
            selectedCoordinate = coordinate
        }

        private func geocodeAddress(coordinate: CLLocationCoordinate2D) {
            MapHelper.geocodeAddress(coordinate: coordinate) { [self] location in
                if let location = location,
                   let name = location.name,
                   let address = location.address {
                    selectedLocationName = name
                    selectedLocationAddress = address
                } else {
                    selectedLocationName = LocationDefault.locationName
                    selectedLocationAddress = LocationDefault.locationAddress
                }
            }
        }
    }
}
