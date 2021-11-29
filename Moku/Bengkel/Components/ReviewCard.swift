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
                Text(review.user)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "686868"))
                Spacer()
            }
            Text(review.comment ?? "")
                .padding(.bottom, 4)
            HStack {
                Text("\(review.timestamp.get(.day))/\(review.timestamp.get(.month))/\(review.timestamp.get(.year))")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "686868"))
                Spacer()
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(AppColor.primaryColor)
                    Text(String(review.rating))
                }
            }
        }
        .padding()
    }
}
