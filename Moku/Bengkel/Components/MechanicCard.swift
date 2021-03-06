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
                        .aspectRatio(contentMode: .fill)
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
                .foregroundColor(.black)
            Spacer()
        }
    }
}

struct MechanicCard_Previews: PreviewProvider {
    static var previews: some View {
        MechanicCard(mechanic: Mekanik(name: "Tono"))
            .previewLayout(.sizeThatFits)
    }
}
