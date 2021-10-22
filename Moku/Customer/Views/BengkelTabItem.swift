//
//  BengkelTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct BengkelTabItem: View {
    @State private var searchText = ""
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    ShapeBg()
                        .frame(height: 150)
                        .foregroundColor(Color("PrimaryColor"))
                    VStack(alignment: .leading) {
                        Spacer(minLength: 40)
                        Button(action: {}) {
                            Image(systemName: "mappin")
                                .padding(.vertical, 7)
                                .padding(.leading, 10)
                                .font(.system(size: 25))
                            Text("Tanggerang, Banten")
                                .font(.headline)
                                .padding(.vertical, 7)
                                .padding(.trailing, 15)
                        }
                        .foregroundColor(Color.white)
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(20)
                        .padding(.horizontal, 10)
                        HStack {
                            Text("Ingin Memperbaiki")
                                .foregroundColor(Color.white)
                                .padding(.leading)
                                .font(.system(size: 17))
                            Button(action: {}) {
                                Text("Motor")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 18, weight: .bold))
                                    .offset(x: -5)
                            }
                            .foregroundColor(Color.white)
                        }
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.systemGray3))
                            TextField("Cari Bengkel", text: $searchText)
                        }
                        .padding(10)
                        .padding(.leading, 5)
                        .background(Color.white, alignment: .center)
                        .cornerRadius(7)
                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                        .padding(.horizontal, 8)
                        VStack(alignment: .leading) {
                            Text("Kasih rating dulu yuk!")
                            Rating()
                                .padding(10)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                            Divider()
                                .padding(.top)
                        }.padding(10)
                        LazyVStack {
                            ForEach(0..<5) { _ in
                                BengkelList()
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(10)
                                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                            }
                        }.padding(10)
                    }.padding(7)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
}

struct BengkelTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BengkelTabItem()
    }
}
