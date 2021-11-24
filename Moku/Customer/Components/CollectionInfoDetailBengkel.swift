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
    var mainInfo: String
    var cta: CallToAction
    
    var onTap: (() -> Void)?
    
    @StateObject private var viewModel = CollectionInfoDetailBengkelViewModel()
    
    var body: some View {
        VStack(spacing: 6) {
            Text(titleInfo)
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.secondaryLabel)
            
            HStack(spacing: 0) {
                if imageInfo.isEmpty {
                    Image(systemName: imageInfo)
                        .foregroundColor(AppColor.primaryColor)
                        .font(.system(size: 17, weight: .semibold))
                }
                Text(mainInfo)
                    .font(.system(size: 17, weight: .semibold))
            }
            
            Button {
                onTap?()
            } label: {
                Text(cta.rawValue).foregroundColor(AppColor.primaryColor)
                    .font(.system(size: 11, weight: .semibold))
            }
        }
    }

    func style(proxy: GeometryProxy) -> some View {
        body
            .padding(.all, 2)
            .frame(width: proxy.size.width * 0.2, alignment: .center)
            .padding(.horizontal)
            .cornerRadius(8)
    }
}

struct CollectionInfoDetailBengkel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionInfoDetailBengkel(
                titleInfo: "Rating",
                imageInfo: "star",
                mainInfo: "5.0",
                cta: .seeDetail
            ).previewLayout(.sizeThatFits)
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

extension CollectionInfoDetailBengkel {
    enum CallToAction: String {
        case seeAll = "Lihat Semua"
        case seeDetail = "Lihat Detail"
        case seeMap = "Lihat Peta"
    }
}
