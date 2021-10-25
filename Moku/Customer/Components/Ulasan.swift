//
//  Ulasan.swift
//  Moku
//
//  Created by Dicky Buwono on 25/10/21.
//

import SwiftUI

struct Ulasan: View {
    var review: Review
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(review.user)")
                .font(.caption)
                .foregroundColor(Color.gray)
            Text("\(review.comment ?? "no comment")")
                .font(.body)
                .padding(.vertical, 5)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text(Date.convertDateFormater(date: review.timestamp))
                    .font(.caption)
                    .foregroundColor(Color.gray)
                Spacer()
                HStack(alignment: .center) {
                    Image(systemName: "star.fill")
                        .offset(x: 10, y: -0.5)
                        .font(.system(size: 14))
                        .foregroundColor(Color("PrimaryColor"))
                    Text("\(review.rating)")
                        .font(.system(size: 17))
                        .fontWeight(.heavy)
                }
            }
        }
        
    }
    
   
}

struct Ulasan_Previews: PreviewProvider {
    static var previews: some View {
        Ulasan(review: bengkels[0].reviews[0])
            .previewLayout(.sizeThatFits)
            .padding(10)
    }
}
