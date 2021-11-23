//
//  FavoriteList.swift
//  Moku
//
//  Created by Dicky Buwono on 22/10/21.
//

import FirebaseAuth
import FirebaseFirestoreSwift
import FirebaseStorage
import SwiftUI
import SDWebImageSwiftUI

struct FavoriteList: View {
    var bengkel: Bengkel
    
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(alignment: .leading) {
                if let photo = bengkel.photos[0] {
                    WebImage(url: URL(string: photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 175, height: 110)
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "number")
                        .resizable()
                        .frame(width: 175, height: 110)
                        .aspectRatio(contentMode: .fill)
                }
                Text(bengkel.name)
                    .font(.headline)
                Text(distanceBengkel(bengkel: bengkel))
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .offset(x: 10, y: -0.5)
                    .font(.system(size: 14))
                    .foregroundColor(Color("PrimaryColor"))
                Text(rateBengkel(bengkel: bengkel))
                    .font(.system(size: 17))
                    .fontWeight(.heavy)
            }
        }
    }
    
    func rateBengkel(bengkel: Bengkel) -> String{
        if !bengkel.reviews.isEmpty{
            var rating: Double = 0.0
            for review in bengkel.reviews{
                rating += Double(review.rating)
            }
            rating = rating/Double((bengkel.reviews.count))
            rating = roundToPlaces(rating, places: 1)
            return "\(rating)"
        }
        else{
            return "Baru"
        }
    }
    
    func distanceBengkel(bengkel: Bengkel) -> String{
        return MapHelper.stringify(distance: bengkel.distance)
    }
    
    func roundToPlaces(_ value: Double, places: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded(rule) / divisor
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        var bengkel = Bengkel(owner: Bengkel.Owner(name: "Devin", phoneNumber: "08", email: "test@gmail.com"), name: "Berkat Jaya Motor", phoneNumber: "00", location: Location(address: "Test", longitude: 00, latitude: 00), operationalHours: Bengkel.OperationalHours(open: 8, close: 10), minPrice: "10000", maxPrice: "100000", fcmToken: "ajdja", reviews: [Review(user: "test", rating: 4, comment: ""), Review(user: "test", rating: 5, comment: "")])
        FavoriteList(bengkel: bengkel)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
