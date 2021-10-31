//
//  MapHelper.swift
//  Moku
//
//  Created by Christianto Budisaputra on 25/10/21.
//

import Foundation
import CoreLocation
import GoogleMaps
import SDWebImageSwiftUI

struct MapHelper {
    struct GeocodeResult {
        let name: String?
        let address: String?
    }

    static let googleGeocoder = GMSGeocoder()
    static let clGeocoder = CLGeocoder()

    // Kalo absolute: lengkap -> Jl. Jalan, Gg. Gang, Kota, ...
    // Kalo ga: cuma kota ama propinsi -> Serpong, Tangerang
    static func geocodeAddress(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (GeocodeResult?) -> Void) {
        googleGeocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
            if let address = response?.firstResult() {
                completionHandler(
                    GeocodeResult(
                        name: address.thoroughfare,
                        address: address.lines?.joined(separator: ", ")
                    )
                )
            } else {
                completionHandler(nil)
            }
        }
    }

    static func geocodeCity(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        clGeocoder.reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                completionHandler("\(city), \(state)")
            } else {
                completionHandler("Location not found")
            }
        }
    }

    // Max Distance tuh in meters, jd kalo 100 km = 100.000
    static func findNearbyBengkel(
        maxCount: Int = 20,
        maxDistance: Double = 30_000,
        data: [Bengkel] = BengkelRepository.shared.bengkel,
        from coordinate: CLLocationCoordinate2D,
        filter: Brand?
    ) -> [Bengkel] {
        let customerLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        var nearbyBengkel = [Bengkel]()

        var currentCount = 0

        for bengkel in data {
            // Base Cases
            if currentCount >= maxCount { return nearbyBengkel }
            if let brand = filter, !bengkel.brands.contains(brand) { continue }

            // Determine the distance
            let distance = customerLocation.distance(from: bengkel.clLocation)

            if distance.isLessThanOrEqualTo(maxDistance), distance.isNormal {
                currentCount += 1
                nearbyBengkel.append(bengkel)
                nearbyBengkel[nearbyBengkel.count-1].distance = distance.nextUp
            }
        }

        return nearbyBengkel.sorted { first, second in
            (first.distance ?? 0) < (second.distance ?? 0)
        }
    }

    static func stringify(distance: Double? = nil) -> String {
        if let distance = distance {
            return String(format: "%.1f KM", distance / 1000)
        }

        return "N/A"
    }
}

//    /// street name, eg. Infinite Loop
//    var streetName: String? { thoroughfare }
//    /// // eg. 1
//    var streetNumber: String? { subThoroughfare }
//    /// city, eg. Cupertino
//    var city: String? { locality }
//    /// neighborhood, common name, eg. Mission District
//    var neighborhood: String? { subLocality }
//    /// state, eg. CA
//    var state: String? { administrativeArea }
//    /// county, eg. Santa Clara
//    var county: String? { subAdministrativeArea }
//    /// zip code, eg. 95014
//    var zipCode: String? { postalCode }
