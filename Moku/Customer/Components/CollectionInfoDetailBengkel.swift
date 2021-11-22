//
//  CollectionInfoDetailBengkel.swift
//  Moku
//
//  Created by Mac-albert on 25/10/21.
//

import SwiftUI
import PartialSheet

struct CollectionInfoDetailBengkel: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    var titleInfo: String
    var imageInfo: String
    var mainInfo: String
    var cta: CallToAction

    var onTap: (() -> Void)?

    var body: some View {
        VStack(spacing: 6) {
            Text("\(titleInfo)")
                .font(.caption2)
                .foregroundColor(.secondaryLabel)
            HStack {
                Image(systemName: "\(imageInfo)")
                    .foregroundColor(AppColor.primaryColor)
                Text("\(mainInfo)").font(.headline)
            }

            Button {
                onTap?()
            } label: {
                Text(cta.rawValue).font(.caption2.bold())
            }

            if cta == .seeDetail {
                Button {
                    partialSheetManager.showPartialSheet {
                        print("normal sheet dismissed")
                    } content: {
                        SheetView(mainInfo: mainInfo)
                    }
                } label: {
                    Text("\(cta.rawValue)").foregroundColor(AppColor.primaryColor)
                }
            } else {
                Text("\(cta.rawValue)").foregroundColor(AppColor.primaryColor)
            }
        }
    }

    func style(proxy: GeometryProxy) -> some View {
        body
            .padding(.all, 4)
            .frame(width: proxy.size.width * 0.3, alignment: .center)
            .background(AppColor.lightGray)
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
        case seeDetail = "Lihat Detail"
    }
}
