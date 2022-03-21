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
        VStack(alignment: .center) {
            Text("\(serviceTitle)")
                .fontWeight(.semibold)
            Image(serviceIcon)
                .font(.system(size: 70, weight: .ultraLight))
                .scaledToFill()
            Text("\(servicePrice)")
                .font(Font.system(size: 11))
                .foregroundColor(.black)
                .fontWeight(.semibold)
        }.padding(.vertical, 8)
            .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(self.isTap == true ? Color("PrimaryColor"): Color(hex: "999999"), lineWidth: 1)
                .padding(.horizontal, 5)
        )
    }
}
