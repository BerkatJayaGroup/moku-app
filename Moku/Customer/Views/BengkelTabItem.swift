//
//  BengkelTabItem.swift
//  Moku
//
//  Created by Dicky Buwono on 21/10/21.
//

import SwiftUI

struct BengkelTabItem: View {
    @State private var searchText = ""
    @State private var selectedMotor: String = motors[0].model
    @State private var showingSheet = false
    @State private var select = 0
    @State private var isOpenBengkel = false

    var lastOrder = true

    var body: some View {
        NavigationView {
            ScrollView {
                ZStack(alignment: .top) {
                    ShapeBg()
                        .frame(height: 140)
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
                        .padding(.horizontal, 20)
                        HStack {
                            Text("Ingin Memperbaiki")
                                .foregroundColor(Color.white)
                                .padding(.leading, 20)
                                .font(.system(size: 17))
                            Button(action: {
                                showingSheet = true
                            }) {
                                Text("\(selectedMotor)")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 18, weight: .bold))
                                    .offset(x: -5)
                            }
                            .foregroundColor(Color.white)
                            .sheet(isPresented: $showingSheet) {
                                MotorModal(data: self.$selectedMotor, showingSheet: self.$showingSheet)
                            }
                        }
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.systemGray3))
                            TextField("Cari Bengkel", text: $searchText)
                        }
                        .padding(8)
                        .padding(.leading, 5)
                        .background(Color.white, alignment: .center)
                        .cornerRadius(7)
                        .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                        .padding(.horizontal, 20)
                        bengkelFavoriteView()
                        Rectangle()
                            .fill(Color(.systemGray6))
                            .frame(height: 5)
                            .edgesIgnoringSafeArea(.horizontal)

                        if lastOrder == true {
                            rantingView()
                            Rectangle()
                                .fill(Color(.systemGray6))
                                .frame(height: 5)
                                .edgesIgnoringSafeArea(.horizontal)
                        }

                        LazyVStack {
                            ForEach(0..<5) { _ in
                                NavigationLink(destination: BengkelDetail()) {
                                    BengkelList()
                                        .padding(5)
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 0)
                                }
                            }
                        }
                        .padding(10)
                        .padding(.horizontal, 10)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
    }
    fileprivate func bengkelFavoriteView() -> some View {
        VStack(alignment: .leading) {
            Text("Bengkel Favorit")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(0..<5) { _ in
                        FavoriteList()
                            .padding(10)
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
                    }
                }
                .padding(5)
            }

        }
        .padding(10)
        .padding(.horizontal, 10)
    }
    fileprivate func rantingView() -> some View {
        VStack(alignment: .leading) {
            Text("Kasih rating dulu yuk!")
                .font(.headline)
            Rating()
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.2), radius: 3, x: 2, y: 2)
        }
        .padding(10)
        .padding(.horizontal, 10)

    }
}

struct BengkelTabItem_Previews: PreviewProvider {
    static var previews: some View {
        BengkelTabItem()
    }
}
