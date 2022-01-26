//
//  MechanicCard.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct MechanicCard: View {
    var mechanic: Mekanik
    var body: some View {
        HStack {
            if let image = mechanic.photo {
                if image != "" {
                    WebImage(url: URL(string: image ))
                        .resizable()
                        .frame(width: 66, height: 66, alignment: .center)
                        .clipShape(Circle())
                        .padding(.trailing, 20)
                } else {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 66, height: 66, alignment: .center)
                        .clipShape(Circle())
                        .padding(.trailing, 20)
                }
            } else {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .frame(width: 66, height: 66, alignment: .center)
                    .clipShape(Circle())
                    .padding(.trailing, 20)
            }
            Text(mechanic.name)
                .font(.system(size: 15))
                .fontWeight(.semibold)
            Spacer()
        }
        .padding()
        .border(Color(hex: "979797"), width: 1, cornerRadius: 6)
        .shadow(color: Color(hex: "979797"), radius: 1)
    }
}

struct MechanicCard_Previews: PreviewProvider {
    static var previews: some View {
        MechanicCard(mechanic: Mekanik(name: "Tono"))
            .previewLayout(.sizeThatFits)
    }
}
