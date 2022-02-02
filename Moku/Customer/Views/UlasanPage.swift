//
//  UlasanPage.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

struct UlasanPage: View {
    let bengkel: Bengkel

    var body: some View {
            if bengkel.reviews.isEmpty {
                VStack(alignment: .center) {
                    Image("UlasanPageEmpty")
                        .font(.system(size: 100))
                        .padding()
                    Text("Bengkel ini belum pernah menerima ulasan dari pelanggan")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

                }
                .padding()
                .foregroundColor(Color.gray)
                .navigationBarTitle("Ulasan", displayMode: .inline)
                .navigationBarHidden(true)
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(bengkel.reviews, id: \.user) { item in
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
