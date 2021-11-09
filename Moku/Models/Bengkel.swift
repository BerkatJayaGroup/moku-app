//
//  Bengkel.swift
//  Moku
//
//  Created by Christianto Budisaputra on 12/10/21.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import MapKit

struct Bengkel: Codable {
    // MARK: - Registration Related
    @DocumentID var id: String!
    var owner: Owner
    var name: String
    var phoneNumber: String
    var location: Location
    var operationalHours: OperationalHours
    var operationalDays = [Bool]()
    var photos          = [String]()
    var brands          = Set<Brand>()
    var mekaniks        = [Mekanik]()
    var minPrice: String
    var maxPrice: String
    var fcmToken: String

    var distance: Double?

    // MARK: Order Related
    var reviews         = [Review]()
    var orders          = [Order]()
}

extension Bengkel {
    var averageRating: String {
        let totalRating = reviews.reduce(Float(0)) { partialResult, review in
            partialResult + Float(review.rating)
        }
        let average = Float(totalRating / Float(reviews.count))

        return String(format: "%.1f", average)
    }

    var address: String {
        location.address
    }

    var clLocation: CLLocation {
        CLLocation(latitude: location.latitude, longitude: location.longitude)
    }

    var coordinate: CLLocationCoordinate2D {
        clLocation.coordinate
    }

    struct OperationalHours: Codable {
        var open: Int
        var close: Int
    }

    struct Owner: Codable {
        let name: String
        let phoneNumber: String
        let email: String?
    }
}

extension Bengkel {
    static let preview = Bengkel(
        owner: Bengkel.Owner(name: "John Doe", phoneNumber: "1234", email: "johndoe@example.com"),
        name: "Dsdsda",
        phoneNumber: "Berkat Jaya",
        location: Location(address: "x", longitude: 1, latitude: 1),
        operationalHours: Bengkel.OperationalHours(open: 7, close: 14),
        operationalDays: [false, true, true, true, false, false, false],
        minPrice: "20000",
        maxPrice: "100000",
        fcmToken: "cp_FfaoY1UoPmCEKVaO6GA:APA91bGf4BFHWUgYAORP9QVrVYILftl2znuEnGDi-nfzunC8UybNeRJIftjEOwd79tdOjRZzsPYQmBMloJzsVx-94J0kUqj_eFScUd3P5w_ePCy3qHXqkQ5Jje_XsZY6Gk-npDz_w9qP",
        reviews: [
            Review(
                user: "Devin Winardi",
                rating: 5,
                comment: "Servisnya memuaskan banget, motor langsung kenceng",
                timestamp: Date()
            ),
            Review(
                user: "Dicky Rangga Buwono",
                rating: 5,
                comment: "Servisnya memuaskan banget, motor langsung kenceng",
                timestamp: Date()
            )
        ]
    )
}
