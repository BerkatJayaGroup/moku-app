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
    var imageInfo: String
    var isRatingEmpty: Bool = true
    var mainInfo: String
    var bengkel: Bengkel
    var cta: CallToAction

    var onTap: (() -> Void)?

    @StateObject private var viewModel = CollectionInfoDetailBengkelViewModel()

    var body: some View {
        VStack(spacing: 6) {
            Text(titleInfo)
                .font(.system(size: 11, weight: .regular))
                .fixedSize(horizontal: true, vertical: false)
                .foregroundColor(.secondaryLabel)

            HStack(spacing: 0) {
                if !imageInfo.isEmpty && mainInfo == "Baru" {
                    Image(systemName: "\(imageInfo)")
                        .foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 17, weight: .semibold))
                }
                Text(mainInfo)
                    .font(.system(size: 17, weight: .semibold))
                    .fixedSize(horizontal: true, vertical: false)
            }
            if cta == .seeAll {
                NavigationLink(destination: UlasanPage(bengkel: bengkel)) {
                    Text(cta.rawValue).foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 11, weight: .semibold))
                }
            } else {
                Button {
                    onTap?()
                } label: {
                    Text(cta.rawValue).foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 11, weight: .semibold))
                }
            }
        }
    }

    func style() -> some View {
        body
            .padding(.all, 2)
            .frame(width: UIScreen.main.bounds.width * 0.2, alignment: .center)
            .padding(.horizontal)
            .cornerRadius(8)
    }
}

extension CollectionInfoDetailBengkel {
    enum CallToAction: String {
        case seeAll = "Lihat Semua"
        case seeDetail = "Lihat Detail"
        case seeMap = "Lihat Peta"
    }
}
