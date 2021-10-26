//
//  Rating.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct Rating: View {

    @State var selected = -1

    var body: some View {
        VStack(alignment: .trailing) {

            Button(action: { print("Button Tap") }) {

                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color("PrimaryColor"))
            }
            .padding(.top, -10)
            .offset(x: 0, y: 10)

            HStack {
                Image(systemName: "number")
                    .resizable()
                    .frame(width: 85, height: 85, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text("Berkat Jaya")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .padding(.bottom, 0.5)

                    Text("ganti oli, ganti ban, 22 Oktober 2021")
                        .font(.system(size: 11))
                        .foregroundColor(Color.gray)

                    HStack(spacing: 10) {
                        ForEach(0..<5) { item in

                            Image(systemName: "star.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(self.selected >= item ? .yellow : .gray).onTapGesture {

                                self.selected = item
                            }

                        }

                        Spacer()
                    }

                }
            }
        }
    }
}

struct Rating_Previews: PreviewProvider {
    static var previews: some View {
        Rating()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
