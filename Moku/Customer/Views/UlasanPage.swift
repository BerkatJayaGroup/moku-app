//
//  UlasanPage.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

let review: [Review] = [
    Review(user: "Devin Winardi", rating: 5, comment: "Servisnya memuaskan banget, motor langsung kenceng", timestamp: Date())
]

struct UlasanPage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack{
                    ForEach(0..<5) { item in
                        Ulasan()
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(6)
                            .shadow(color: .black.opacity(0.25), radius: 2, x: 2, y: 2)
                    }.padding(.vertical, 2)
                }.padding(20)
            }
            .navigationBarTitle("Ulasan", displayMode: .inline)
        }
    }
}

struct UlasanPage_Previews: PreviewProvider {
    static var previews: some View {
        UlasanPage()
    }
}
