//
//  ReviewCard.swift
//  Moku
//
//  Created by Mac-albert on 29/11/21.
//

import SwiftUI

struct ReviewCard: View {
    var review: Review
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Devin Winardi")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "686868"))
                Spacer()
            }
            Text("Servisnya memuaskan banget, motor langsung kenceng")
                .padding(.bottom, 4)
            HStack {
                Text("07/10/21")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "686868"))
                Spacer()
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColor.primaryColor)
                    Text("4.5")
                }
            }
        }
        .padding()
    }
}
