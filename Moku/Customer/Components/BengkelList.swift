//
//  BengkelList.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct BengkelList: View {
    var body: some View {
        HStack {
            Image(systemName: "number")
                .resizable()
                .background(Color.gray)
                .frame(width: 80, height: 80, alignment: .center)
                .aspectRatio(contentMode: .fill)
                .cornerRadius(8)

            VStack(alignment: .leading) {
                Text("Berkat Jaya")
                    .font(.headline)
                    .fontWeight(.medium)

                Text("Senin - Jumat, 10.00 - 17.00")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                  

                Text("0.5KM")
                    .font(.system(size: 14))
                    .foregroundColor(Color.gray)
                    .padding(.bottom, 1)

                HStack {
                    Text("$$$")
                        .font(.system(size: 14))
                        .foregroundColor(Color("PrimaryColor"))

                    Spacer()

                    HStack(alignment: .center) {
                        Image(systemName: "star.fill")
                            .offset(x: 10, y: -0.5)
                            .font(.system(size: 13))
                            .foregroundColor(Color("PrimaryColor"))
                        Text("5")
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
        BengkelList()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
