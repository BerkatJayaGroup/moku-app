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
        owner: Bengkel.Owner(name: "John Doe", phoneNumber: "082280698758", email: "johndoe@example.com"),
        name: "Berkat Jaya Motor",
        phoneNumber: "082280698758",
        location: Location(
            address: "Sampora Kecamatan Cisauk Kawasan Taman Kota Barat, Gg. Kavling 2 No.3, Bumi, Serpong Damai, Tangerang, Banten 15345",
            longitude: 106.65203368260228, latitude: -6.305695785964465),
        operationalHours: Bengkel.OperationalHours(open: 7, close: 14),
        operationalDays: [false, true, true, true, false, false, false],
        photos: [
            "https://firebasestorage.googleapis.com:443/v0/b/moku-9c45f.appspot.com/o/images%2FpbTlMRVXTBYoRe3DaolDP0cfYQh2%2Fphotos%2FB0BF9A8D-B5F7-49D5-B46A-D2AFB9BCC761.jpg?alt=media&token=919c9b4b-aa46-4f07-80b0-3ab01c8efa16",
            "https://firebasestorage.googleapis.com:443/v0/b/moku-9c45f.appspot.com/o/images%2FpbTlMRVXTBYoRe3DaolDP0cfYQh2%2Fphotos%2F3162626A-CF7F-4676-B51E-FDCC73897B03.jpg?alt=media&token=8173ca44-3e12-4990-aef4-e3f5bf204e2e",
            "https://firebasestorage.googleapis.com:443/v0/b/moku-9c45f.appspot.com/o/images%2Ful69NWc2qyTuutFHIwGOex37rir2%2Fphotos%2F4D13E6DE-E1FD-43E7-9CAA-967438201C5F.jpg?alt=media&token=3a8db4b7-ef74-4114-a425-9bfd87adc4ca",
            "https://firebasestorage.googleapis.com:443/v0/b/moku-9c45f.appspot.com/o/images%2Ful69NWc2qyTuutFHIwGOex37rir2%2Fmechanics%2F34AA3F56-BCFE-4878-B0D3-D02F7117D47C.jpg?alt=media&token=41098f7a-63b5-4316-a3a1-615714a3c718"
        ],
        brands: [.honda, .yamaha, .kawasaki],
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
