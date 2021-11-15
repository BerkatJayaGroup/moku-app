//
//  PengaturanHargaBengkel.swift
//  Moku
//
//  Created by Dicky Buwono on 27/10/21.
//

import SwiftUI
import Firebase
import Foundation

struct PengaturanHargaBengkel: View {
    var bengkelOwnerFormViewModel: BengkelOwnerOnboardingView.ViewModel
    var bengkelOwnerForm: BengkelOwnerOnboardingView
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
        .padding()
        .navigationBarTitle("Pengaturan Harga", displayMode: .inline)
    }

    func createBengkel(bengkelOwnerFormViewModel: BengkelOwnerOnboardingView.ViewModel, bengkelOwnerForm: BengkelOwnerOnboardingView, pengaturanBengkelForm: PengaturanBengkel) {
        let calendar = Calendar.current
        let openTime = calendar.component(.hour, from: pengaturanBengkelForm.openTime)
        let closeTime = calendar.component(.hour, from: pengaturanBengkelForm.closeTime)
        guard let location = bengkelOwnerFormViewModel.location else {return}
        var bengkelBaru = Bengkel(
            owner: Bengkel.Owner(name: bengkelOwnerFormViewModel.ownerName, phoneNumber: bengkelOwnerFormViewModel.phoneNumber, email: ""),
            name: bengkelOwnerFormViewModel.bengkelName,
            phoneNumber: bengkelOwnerFormViewModel.phoneNumber,
            location: location,
            operationalHours: Bengkel.OperationalHours(open: openTime, close: closeTime),
            operationalDays: pengaturanBengkelForm.daySelected,
            minPrice: min,
            maxPrice: max
        )

        for brand in pengaturanBengkelForm.selectedBrand {
            bengkelBaru.brands.insert(brand)
        }

        for mech in pengaturanBengkelForm.mechanics {
            var mekBaru = Mekanik(name: mech.name)
            guard let photo = mech.photo else { return bengkelBaru.mekaniks.append(mekBaru) }

            storageService.upload(image: photo, path: mekBaru.id) { url, _ in
                mekBaru.photo = url?.absoluteString
                bengkelBaru.mekaniks.append(mekBaru)
            }
        }

        for img in bengkelOwnerForm.pickerResult {
            let imgID = UUID().uuidString
            storageService.upload(image: img, path: imgID)
            bengkelBaru.photos.append(imgID)
        }

        bengkelViewModel.create(bengkelBaru)

        SessionService.shared.user = .bengkel(bengkelBaru)
    }
}
