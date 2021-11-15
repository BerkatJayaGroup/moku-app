//
//  ImageFullComp.swift
//  Moku
//
//  Created by Dicky Buwono on 11/11/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageFullComp: View {
    let imageUrl: String
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationView {
            WebImage(url: URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .navigationBarItems(
                    trailing:
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            HStack(spacing: 3) {
                                Image(systemName: "xmark.circle")
                            }
                        }.foregroundColor(Color("PrimaryColor"))
                )
        }
    }
}
