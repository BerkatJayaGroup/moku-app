//
//  PengaturanHargaBengkel.swift
//  Moku
//
//  Created by Dicky Buwono on 27/10/21.
//

import SwiftUI

struct PengaturanHargaBengkel: View {
    var bengkelOwnerForm: BengkelOwnerOnboardingView.ViewModel
    var pengaturanBengkelForm: PengaturanBengkel
    @ObservedObject var bengkelViewModel: BengkelViewModel = .shared
    @State private var min: String = ""
    @State private var max: String = ""
    @ObservedObject var storageService: StorageService = .shared

    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Masukkan harga jasa service rutin, umumnya service rutin mencakup jasa pengecekan mesin, busa filter, pengecekan komponen ban, lampu, rantai, dan lainnya.")
                    .font(.system(size: 13))
                    .padding(.bottom)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                HStack {
                    TextField("Rp minimum", text: $min)
                        .font(.system(size: 15))
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(9)
                        .keyboardType(.numberPad)
                    Text("-")
                    TextField("Rp maksimum", text: $max)
                        .font(.system(size: 15))
                        .padding(10)
                        .background(Color(.systemGray5))
                        .cornerRadius(9)
                        .keyboardType(.numberPad)
                }.padding()
                Spacer()
                Text("Harga yang Anda masukkan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding()
                NavigationLink(destination: BengkelView()) {
                    Button("Lanjutkan") { print("testing") }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryColor"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5.0))
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationBarTitle("Pengaturan Harga", displayMode: .inline)
        }
    }

    func createBengkel(bengkelOwnerForm: BengkelOwnerOnboardingView.ViewModel, pengaturanBengkelForm: PengaturanBengkel) {
        let calendar = Calendar.current
        let openTime = calendar.component(.hour, from: pengaturanBengkelForm.openTime)
        let closeTime = calendar.component(.hour, from: pengaturanBengkelForm.closeTime)
        guard let location = bengkelOwnerForm.location else {return}
        var bengkelBaru = Bengkel(
            owner: Bengkel.Owner(name: bengkelOwnerForm.ownerName, phoneNumber: bengkelOwnerForm.phoneNumber, email: ""),
            name: bengkelOwnerForm.bengkelName,
            phoneNumber: bengkelOwnerForm.phoneNumber,
            location: location,
            operationalHours: Bengkel.OperationalHours(open: openTime, close: closeTime),
            operationalDays: [.senin, .selasa, .rabu],
            minPrice: min,
            maxPrice: max
        )

        for mech in pengaturanBengkelForm.mechanics {
            let mekBaru = Mekanik(name: mech.name)
            if let photo = mech.photo {
                storageService.upload(image: photo, path: mekBaru.id)
            }
            bengkelBaru.mekaniks.append(mekBaru)
        }

        bengkelViewModel.create(bengkelBaru)
    }
}
