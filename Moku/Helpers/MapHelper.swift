//
//  MapHelper.swift
//  Moku
//
//  Created by Christianto Budisaputra on 25/10/21.
//

import Foundation
import CoreLocation

struct MapHelper {
    static func geocode(coordinate: CLLocationCoordinate2D, completionHandler: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            if let placemark = placemarks?.first,
               let city = placemark.locality,
               let state = placemark.administrativeArea {
                completionHandler("\(city), \(state)")
            } else {
                completionHandler("Location not found")
            }
        }
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
