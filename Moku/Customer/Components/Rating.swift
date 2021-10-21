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

                Image(systemName: "xmark")
                    .foregroundColor(.black)
            }
            .padding(.top, -10)
            .offset(x: 0, y: 10)

            HStack {
                Image(systemName: "number")
                    .resizable()
                    .frame(width: 80, height: 80, alignment: .center)
                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(8)

                VStack(alignment: .leading) {
                    Text("Berkat Jaya")
                        .font(.headline)
                        .fontWeight(.medium)

                    Text("ganti oli, ganti ban")
                        .font(.system(size: 14))
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
