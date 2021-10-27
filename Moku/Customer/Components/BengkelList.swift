//
//  BengkelList.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct BengkelList: View {
    let bengkel: Bengkel

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
    }

    var body: some View {
        HStack {
            Image(systemName: "number")
                .resizable()
                .background(Color.gray)
                .frame(width: 85, height: 85, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text(bengkel.name)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .padding(.bottom, 0.5)

                Text("Senin - Jumat, \(operationalHours)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 0.5)

                Text(distance)
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 0.5)

                HStack {
                    Text("$$$")
                        .font(.system(size: 11))
                        .foregroundColor(Color("PrimaryColor"))

                    Spacer()

                    HStack(alignment: .center) {
                        Image(systemName: "star.fill")
                            .offset(x: 10, y: -0.5)
                            .font(.system(size: 13))
                            .foregroundColor(Color("PrimaryColor"))
                        Text(averageRating)
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                    }
                }
            }
        }.foregroundColor(.black)
    }
}

struct BengkelList_Previews: PreviewProvider {
    static var previews: some View {
        BengkelList(bengkel: .preview)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

extension BengkelList {
    var operationalHours: String {
        "\(bengkel.operationalHours.open).00 - \(bengkel.operationalHours.close).00"
    }

    var distance: String {
        MapHelper.stringify(distance: bengkel.distance)
    }

    var averageRating: String {
        let totalRating = bengkel.reviews.reduce(Float(0)) { partialResult, review in
            partialResult + Float(review.rating)
        }
        let average = Float(totalRating / Float(bengkel.reviews.count))

        return String(format: "%.1f", average)
    }
}
