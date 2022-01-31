//
//  BengkelList.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct BengkelList: View {

    let bengkel: Bengkel

    init(bengkel: Bengkel) {
        self.bengkel = bengkel
    }

    var body: some View {
        HStack {
            if bengkel.photos.count > 0 {
                if let photo = bengkel.photos[0] {
                    WebImage(url: URL(string: photo))
                        .resizable()
                        .background(Color.gray)
                        .frame(width: 85, height: 85, alignment: .center)
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(8)
                }
            } else {
            Image(systemName: "number")
                .resizable()
                .background(Color.gray)
                .frame(width: 85, height: 85, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(bengkel.name)
                    .font(.system(size: 15))
                    .fontWeight(.semibold)

                Text("Senin - Jumat, \(operationalHours)")
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)

                Text(distance)
                    .font(.system(size: 11))
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 0.05)

                HStack {
                    if Int(bengkel.minPrice) ?? 0 < 50000 {
                        HStack(spacing: 0) {
                            Text("$")
                                .font(.system(size: 11))
                                .foregroundColor(AppColor.primaryColor)
                            Text("$$")
                                .font(.system(size: 11))
                                .foregroundColor(AppColor.darkGray)
                        }
                    } else if Int(bengkel.minPrice) ?? 0 < 100000 && Int(bengkel.minPrice) ?? 0 >= 50000 {
                        HStack(spacing: 0) {
                            Text("$$")
                                .font(.system(size: 11))
                                .foregroundColor(AppColor.primaryColor)
                            Text("$")
                                .font(.system(size: 11))
                                .foregroundColor(AppColor.lightGray)
                        }
                    } else {
                        Text("$$$")
                            .font(.system(size: 11))
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    Spacer()

                    HStack(alignment: .center) {
                        Image(systemName: "star.fill")
                            .offset(x: 10, y: -0.5)
                            .font(.system(size: 13))
                            .foregroundColor(Color("PrimaryColor"))
                        Text(bengkel.averageRating)
                            .font(.system(size: 15))
                            .fontWeight(.heavy)
                            .padding(.leading, 4)
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
}
