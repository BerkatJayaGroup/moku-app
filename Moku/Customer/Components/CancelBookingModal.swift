//
//  CancelBookingModal.swift
//  Moku
//
//  Created by Devin Winardi on 09/11/21.
//

import SwiftUI

struct CancelBookingModal: View {
    @Environment(\.presentationMode) var presentationMode
    
    var alasans: [String] = ["Ingin memilih bengkel lain", "Bengkel tutup", "Tidak ingin melakukan perbaikan / servis", "Ingin merubah detail / tanggal booking"]

    @State private var selection: String?
    
    var body: some View{
        NavigationView{
            List(alasans, id: \.self, selection: $selection){ alasan in
                Button {
                } label: {
                    HStack {
                        Text(alasan).foregroundColor(.black)
                        Spacer()
                        if alasan == selection {
                            Image(systemName: "checkmark").foregroundColor(.accentColor)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Pilih alasan membatalkan booking").font(.headline), displayMode: .inline)
            .listStyle(.grouped)
        }
    }
}

struct CancelBookingModal_Previews: PreviewProvider {
    static var previews: some View {
        CancelBookingModal()
    }
}

