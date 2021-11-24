//
//  SelectServices.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import SwiftUIX

struct SelectServices: View {
    var serviceTitle: String
    var serviceIcon: String
    var servicePrice: String
    var isTap: Bool
    var body: some View {
        GeometryReader { geo in
            VStack(alignment: .center, spacing: 8) {
                Text("\(serviceTitle)")
                    .fontWeight(.semibold)
                    .foregroundColor(self.isTap == true ? Color("PrimaryColor"): Color(hex: "999999"))
                Image(systemName: "\(serviceIcon)")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width * 0.5, height: geo.size.width * 0.5, alignment: .center)
                    .font(.system(size: 16, weight: .ultraLight))
                    .foregroundColor(self.isTap == true ? Color("PrimaryColor"): Color(hex: "999999"))
                    .padding()
                Text("\(servicePrice)")
                    .font(Font.system(size: 11))
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(self.isTap == true ? Color("PrimaryColor"): Color(hex: "E7E7E7"))
                    .foregroundColor(self.isTap == true ? .white : .gray)
                    .cornerRadius(8)
            }
            .padding(.top, 24)
            .padding(.bottom, 8)
            .frame(width: geo.size.width, height: .infinity)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(self.isTap == true ? Color("PrimaryColor"): Color(hex: "999999"), lineWidth: 1)
                    .padding(.horizontal, 5)
            )
        }
    }
}
