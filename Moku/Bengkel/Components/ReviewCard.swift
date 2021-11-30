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
            Text(review.user)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            if let comment = review.comment {
                Text(comment)
                    .padding(.bottom, 4)
                    .multilineTextAlignment(.leading)
            }
            HStack {
                Text(Date.convertDateFormat(date: review.timestamp, format: "EEE, d MMM y"))
                    .font(.subheadline)
                    .foregroundColor(.secondaryLabel)
                Spacer()
                HStack(spacing: 4) {
                    Image(systemName: "star.fill").foregroundColor(.yellow)
                    Text("\(review.rating).0")
                }.font(.subheadline.bold())
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
    }
}
