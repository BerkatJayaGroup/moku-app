//
//  BengkelDetail.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI

struct BengkelDetail: View {
    var body: some View {
        GeometryReader{ proxy in
            VStack(alignment: .leading, spacing: 8){
                Image(systemName: "number")
                    .resizable()
                    .frame(width: proxy.size.width, height: proxy.size.height * 0.33)
                    .scaledToFit()
                
                HStack{
                    Text("Berkat Jaya Motor")
                    Spacer()
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                }
                .font(Font.system(size: 22))
                Text("Jl. Sudirman 2 no 5, Jakarta Selatan, Kemang ")
                    .fontWeight(.light)
                HStack{
                    VStack(spacing: 6){
                        Text("Rating")
                            .font(Font.system(size: 11))
                            .foregroundColor(.gray)
                        HStack{
                            Image(systemName: "star.fill")
                                .foregroundColor(Color("PrimaryColor"))
                            Text("5.0")
                                .fontWeight(.bold)
                        }
                        Text("Lihat Semua")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.all, 4)
                    .frame(width: proxy.size.width * 0.3, alignment: .center)
                    .background(Color(hex: "F3F3F3"))
                    .cornerRadius(8)
                    VStack(spacing: 6){
                        Text("Jarak dari Anda")
                            .font(Font.system(size: 11))
                            .foregroundColor(.gray)
                        HStack{
                            Text("0,5 KM")
                                .fontWeight(.bold)
                        }
                        Text("Lihat Peta")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.all, 4)
                    .frame(width: proxy.size.width * 0.3, alignment: .center)
                    .background(Color(hex: "F3F3F3"))
                    .cornerRadius(8)
                    VStack(spacing: 6){
                        Text("Jam Buka")
                            .font(Font.system(size: 11))
                            .foregroundColor(.gray)
                        HStack{
                            Text("11:00 - 17:00")
                                .fontWeight(.bold)
                        }
                        Text("Lihat Detail")
                            .foregroundColor(Color("PrimaryColor"))
                    }
                    .padding(.all, 4)
                    .frame(width: proxy.size.width * 0.3, alignment: .center)
                    .background(Color(hex: "F3F3F3"))
                    .cornerRadius(8)
                }
                .frame(width: proxy.size.width)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct BengkelDetail_Previews: PreviewProvider {
    static var previews: some View {
        BengkelDetail()
    }
}
