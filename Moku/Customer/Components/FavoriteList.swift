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
        VStack(alignment: .leading) {
            if !bengkel.photos.isEmpty {
                if let photo = bengkel.photos[0] {
                    WebImage(url: URL(string: photo))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 180, height: 140)
                        .cornerRadius(8)
                        .padding(.small)
                }
            } else {
                Image(systemName: "number")
                    .resizable()
                    .scaledToFit()
                    .height(120)
                    .padding(.small)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(bengkel.name)
                    .font(.subheadline)
                    .semibold()
                Text(MapHelper.stringify(distance: bengkel.distance))
                    .font(.caption)
                    .foregroundColor(.secondaryLabel)
            }.padding(.horizontal)

            HStack(spacing: 2) {
                Spacer()
                Image(systemName: "star.fill")
                    .font(.subheadline)
                    .foregroundColor(.yellow)
                Text(bengkel.averageRating)
                    .font(.subheadline)
                    .semibold()
            }.padding([.trailing, .bottom], .small)
        }
        .foregroundColor(.primary)
        .background(AppColor.primaryBackground)
        .cornerRadius(10)
        .applyShadow()
        .padding(.small)
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList(bengkel: .preview).previewLayout(.sizeThatFits)
    }
}
