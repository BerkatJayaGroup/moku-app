//
//  CollectionInfoDetailBengkel.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI

struct CollectionInfoDetailBengkel: View {
    var titleInfo: String
    var imageInfo: String
    var mainInfo: String
    var cta: String

    var onTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 6) {
            Text("\(titleInfo)")
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            HStack {
                Image(systemName: "\(imageInfo)")
                    .foregroundColor(Color("PrimaryColor"))
                Text("\(mainInfo)").font(.headline)
            }
            Button {
                onTap?()
            } label: {
                Text(cta).font(.caption2.bold())
            }
        }
    }
}

struct CollectionInfoDetailBengkel_Previews: PreviewProvider {
    static var previews: some View {
        CollectionInfoDetailBengkel(titleInfo: "Rating", imageInfo: "star", mainInfo: "5.0", cta: "Lihat Semua")
            .previewLayout(.sizeThatFits)
    }
}
