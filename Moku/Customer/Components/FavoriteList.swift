//
//  FavoriteList.swift
//  Moku
//
//  Created by Dicky Buwono on 22/10/21.
//

import SwiftUI

struct FavoriteList: View {
    var body: some View {
        VStack(alignment: .trailing) {
            VStack(alignment: .leading) {
                Image(systemName: "number")
                    .resizable()
                    .frame(width: 175, height: 110)
                    .aspectRatio(contentMode: .fill)
                Text("Berkat Jaya Baru")
                    .font(.headline)
                Text("0.5KM")
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .offset(x: 10, y: -0.5)
                    .font(.system(size: 14))
                    .foregroundColor(Color("PrimaryColor"))
                Text("5")
                    .font(.system(size: 17))
                    .fontWeight(.heavy)
            }
        }
    }
}

struct FavoriteList_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteList()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
