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
    
    var location = [ locationItem(name: "AEON Mall BSD City, Jalan Bumi Serpong D"),
                             locationItem(name: "Jl. Kelengkong No.47, RT.3/RW.2, Sampora, Kec. Cisauk, Tangerang, Banten 15345"),
                             locationItem(name: "Green Office Park 9 Lantai 3. Wing B, Sampora, Cisauk, Tangerang, Banten 15345"),
                             locationItem(name: "Buy two bottles of wine"),
                             locationItem(name: "Prepare the presentation deck")
    ]
    
    var body: some View {
        VStack{
            HStack{
                Text("Pilih Lokasimu")
                    .font(.system(size: 17, weight: .bold))
                Spacer()
                HStack{
                    Image(systemName: "key")
                    Text("Pilih Lokasi")
                }
                .padding(.horizontal, 12.0)
                .padding(.vertical, 7.0)
                .foregroundColor(.white)
                .background(Color("PrimaryColor"))
                .cornerRadius(8)
            }
            SearchBarLocation(text: $searchText)
            List(location.filter({
                searchText.isEmpty ? true : $0.name.contains(searchText)
            })){ item in
                Text(item.name)
            }
        }
    }
}

struct modalSearchLocation_Previews: PreviewProvider {
    static var previews: some View {
        ModalSearchLocation(showModal: .constant(true))
    }
}

struct locationItem: Identifiable{
    var id = UUID()
    
    var name: String
}
