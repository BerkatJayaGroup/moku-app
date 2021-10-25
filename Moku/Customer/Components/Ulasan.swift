//
//  Ulasan.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

struct Ulasan: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Devin Winardi")
                .font(.caption)
                .foregroundColor(Color.gray)
            Text("Servisnya memuaskan banget, motor langsung kenceng")
                .font(.body)
                .padding(.vertical, 5)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text("07/10/2021")
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Spacer()
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
}

struct Ulasan_Previews: PreviewProvider {
    static var previews: some View {
        Ulasan()
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
