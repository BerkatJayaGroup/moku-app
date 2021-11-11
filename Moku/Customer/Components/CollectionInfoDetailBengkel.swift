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
            if cta == "Lihat Detail"{
                Button(action: {
                    self.partialSheetManager.showPartialSheet({
                        print("normal sheet dismissed")
                    }) {
                        SheetView(mainInfo: mainInfo)
                    }
                }) {
                    Text("\(cta)")
                        .foregroundColor(Color("PrimaryColor"))
                }
            } else {
                Text("\(cta)")
                    .foregroundColor(Color("PrimaryColor"))
            }
            if cta == "Lihat Detail"{
                Button {
                    partialSheetManager.showPartialSheet {
                        print("normal sheet dismissed")
                    } content: {
                        SheetView(mainInfo: mainInfo)
                    }
                } label: {
                    Text("\(cta)")
                        .foregroundColor(Color("PrimaryColor"))
                }
            } else {
                Text("\(cta)")
                    .foregroundColor(Color("PrimaryColor"))
            }
        }
    }
}

struct CollectionInfoDetailBengkel_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CollectionInfoDetailBengkel(titleInfo: "Rating", imageInfo: "star", mainInfo: "5.0", cta: "Lihat Detail")
                .previewLayout(.sizeThatFits)
        }
        .addPartialSheet()
        .navigationViewStyle(StackNavigationViewStyle())
        .environmentObject(PartialSheetManager())
    }
}

extension CollectionInfoDetailBengkel {

}
