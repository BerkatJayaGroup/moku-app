//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI
import Contacts

struct BengkelOwnerOnboardingView: View {
    @State var ownerName: String = ""
    @State var bengkelName: String = ""
    @State var bengkelAddress: Location = Location(address: "", longitude: 0, latitude: 0)
    @State var bengkelPhoneNumber: String = ""
    @State var isNavigateActive = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("NAMA PEMILIK")) {
                    TextField("Tulis namamu disini", text: $ownerName)
                }
                Section(header: Text("NAMA BENGKEL")) {
                    TextField("Tulis nama bengkelmu disini", text: $bengkelName)
                }
                Section(header: Text("ALAMAT")) {
                    TextField("Cari alamat bengkelmu disini", text:
                                $bengkelAddress.address)
                }
                Section(header: Text("NOMOR TELEPON BENGKEL")) {
                    TextField("08xx-xxxx-xxxx", text: $bengkelPhoneNumber).keyboardType(.numberPad)
                }
                Section(header: Text("FOTO BENGKEL")) {
                    // UI IMAGE PICKER
                }
            }
            NavigationLink(destination: PengaturanBengkel(bengkelOwnerForm: self), isActive: $isNavigateActive) {
                Button("Lanjutkan") { self.isNavigateActive = true }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryColor"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5.0))
                .padding(.horizontal)
            }
        }
        .navigationBarTitle("Profil Bengkel", displayMode: .inline)
    }
}

//struct BengkelOwnerOnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        BengkelOwnerOnboardingView()
//    }
//}
