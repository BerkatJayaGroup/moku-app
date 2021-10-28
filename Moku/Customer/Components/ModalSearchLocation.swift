//
//  modalSearchLocation.swift
//  Moku
//
//  Created by Mac-albert on 22/10/21.
//

import SwiftUI

struct ModalSearchLocation: View {
    @Binding var showModal: Bool
    @State private var searchText = ""

    var location = [ LocationItem(name: "AEON Mall BSD City, Jalan Bumi Serpong D"),
                     LocationItem(name: "Jl. Kelengkong No.47, RT.3/RW.2, Sampora, Kec. Cisauk, Tangerang, Banten 15345"),
                     LocationItem(name: "Green Office Park 9 Lantai 3. Wing B, Sampora, Cisauk, Tangerang, Banten 15345"),
                     LocationItem(name: "Buy two bottles of wine"),
                     LocationItem(name: "Prepare the presentation deck")
    ]

    var body: some View {
        NavigationView {
            VStack {
                SearchBarLocation(text: $searchText)
                List(location.filter({
                    searchText.isEmpty ? true : $0.name.contains(searchText)
                })) { item in
                    Text(item.name)
                }
            }
            .padding(.vertical, 8)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading:
                                    Button {

            } label: {
                Text("Pilih Lokasimu")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.black)
            }, trailing: Button {

            } label: {
                HStack {
                    Image(systemName: "mappin.circle.fill")
                    Text("Pilih Lokasi")
                }
                .font(Font.system(size: 13))
                .padding(.horizontal, 12.0)
                .padding(.vertical, 7.0)
                .foregroundColor(.white)
                .background(Color("PrimaryColor"))
                .cornerRadius(8)
            })
        }
    }
}

struct ModalSearchLocation_Previews: PreviewProvider {
    static var previews: some View {
        ModalSearchLocation(showModal: .constant(true))
    }
}

struct LocationItem: Identifiable {
    var id = UUID()
    var name: String
}
