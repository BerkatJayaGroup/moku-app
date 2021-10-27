//
//  UlasanPage.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

struct UlasanPage: View {
    var review: [Review] = Bengkel.preview.reviews
    
    var body: some View {
        NavigationView {
            if review.isEmpty {
                VStack(alignment: .center) {
                    Image(systemName: "person.3.fill")
                        .font(.system(size: 100))
                        .padding()
                    Text("Bengkel ini belum pernah menerima ulasan dari pelanggan")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

                }
                .padding()
                .foregroundColor(Color.gray)
                .navigationBarTitle("Ulasan", displayMode: .inline)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(review, id: \.user) { item in
                            Ulasan(review: item)
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
}

struct UlasanPage_Previews: PreviewProvider {
    static var previews: some View {
        UlasanPage()
    }
}
