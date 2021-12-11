//
//  CollectionInfoDetailBengkel.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet

class CollectionInfoDetailBengkelViewModel: ObservableObject {
    @Published var show = false
}

struct CollectionInfoDetailBengkel: View {
    var titleInfo: String
    var imageInfo = ""
    var isRatingEmpty = true
    var mainInfo: String
    var bengkel: Bengkel
    var cta: CallToAction

    var onTap: (() -> Void)?

    @StateObject private var viewModel = CollectionInfoDetailBengkelViewModel()

    var body: some View {
        VStack(spacing: 6) {
            Text(titleInfo)
                .font(.caption2)
                .foregroundColor(.secondaryLabel)

            HStack(spacing: 2) {
                if !imageInfo.isEmpty {
                    Image(systemName: imageInfo).foregroundColor(.yellow)
                }
                Text(mainInfo)
            }.font(.headline)

            if cta == .seeAll {
                NavigationLink(destination: UlasanPage(bengkel: bengkel)) {
                    Text(cta.rawValue)
                        .font(.caption2)
                        .semibold()
                }
            } else {
                Button {
                    onTap?()
                } label: {
                    Text(cta.rawValue)
                        .font(.caption2)
                        .semibold()
                }
            }
        }
    }
}

extension CollectionInfoDetailBengkel {
    enum CallToAction: String {
        case seeAll = "Lihat Semua"
        case seeDetail = "Lihat Detail"
        case seeMap = "Lihat Peta"
    }
}
