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
            VStack(alignment: .leading, spacing: 5) {
                if !bengkel.photos.isEmpty {
                    if let photo = bengkel.photos[0] {
                        WebImage(url: URL(string: photo))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 175, height: 110)
                            .cornerRadius(10)
                            .aspectRatio(contentMode: .fill)
                    }
                } else {
                    Image(systemName: "number")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 175, height: 110)
                        .cornerRadius(10)
                        .aspectRatio(contentMode: .fill)
                }
                Text(bengkel.name)
                    .font(.system(size: 15, weight: .semibold))
                Text(distanceBengkel(bengkel: bengkel))
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color.gray)
            }
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .offset(x: 5, y: -0.5)
                    .font(.system(size: 13))
                    .foregroundColor(Color("PrimaryColor"))
                Text(bengkel.averageRating)
                    .font(.system(size: 13))
                    .fontWeight(.heavy)
            }.padding(.top, 5)
        }
    }

    func rateBengkel(bengkel: Bengkel) -> String {
        if !bengkel.reviews.isEmpty {
            var rating: Double = 0.0
            for review in bengkel.reviews {
                rating += Double(review.rating)
            }
            rating /= Double((bengkel.reviews.count))
            rating = roundToPlaces(rating, places: 1)
            return "\(rating)"
        } else {
            return "Baru"
        }
    }

    func distanceBengkel(bengkel: Bengkel) -> String {
        return MapHelper.stringify(distance: bengkel.distance)
    }

    func roundToPlaces(_ value: Double, places: Int, rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Double {
        let divisor = pow(10.0, Double(places))
        return (value * divisor).rounded(rule) / divisor
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList(bengkel: .preview)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
