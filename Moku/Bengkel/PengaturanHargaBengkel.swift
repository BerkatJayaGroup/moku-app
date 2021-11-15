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
    var pengaturanBengkelForm: PengaturanBengkel
    @ObservedObject var bengkelViewModel: BengkelViewModel = .shared
    @State private var min: String = ""
    @State private var max: String = ""
    @ObservedObject var storageService: StorageService = .shared
    
    @State var canSubmit = false
    @State var isSubmitting: Bool = false
    
    var isFormValid: Bool {
        !min.isEmpty && !max.isEmpty
    }

    var body: some View {
        GeometryReader { proxy in
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
                    emptyAlert(for: $min, alert: "Harga minimal harus diisi")
                    emptyAlert(for: $max, alert: "Harga maksimal harus diisi")
                    Spacer()
                    Text("Harga yang Anda masukkan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    submitButton(proxy: proxy)
                }
                .padding()
                .navigationBarTitle("Pengaturan Harga", displayMode: .inline)
            }
        }
    }
    @ViewBuilder
    private func submitButton(proxy: GeometryProxy) -> some View {
        NavigationLink(destination: BengkelView(), isActive: $canSubmit) {EmptyView()}

        Button {
            validateForm()
            createBengkel(bengkelOwnerFormViewModel: bengkelOwnerFormViewModel, pengaturanBengkelForm: pengaturanBengkelForm)
        } label: {
            HStack {
                Spacer()
                Text("Lanjutkan")
                Spacer()
            }
            .padding()
            .foregroundColor(.white)
            .background(AppColor.primaryColor)
            .cornerRadius(8)
            .frame(width: (proxy.size.width * 0.8))
        }
    }
    
    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, isSubmitting {
            Text(alert).alertStyle()
        }
    }
    
    func validateForm(){
        isSubmitting = true
        if isFormValid {
            canSubmit = true
        }
    }
    
    func createBengkel(bengkelOwnerFormViewModel: BengkelOwnerOnboardingView.ViewModel, pengaturanBengkelForm: PengaturanBengkel){
//        Titip di command dulu barangkali besok butuh

//        var days: [Day] = [.senin, .selasa, .rabu, .kamis, .jumat, .sabtu, .minggu]
//        for day in days {
//            if let index = days.firstIndex(of: day){
//                if (pengaturanBengkelForm.daySelected[index] == false){
//                    days.remove(at: index)
//                }
//            }
//        }

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
        
        for img in bengkelOwnerFormViewModel.images {
            let imgID = UUID().uuidString
            storageService.upload(image: img, path: imgID)
            bengkelBaru.photos.append(imgID)
        }

        bengkelViewModel.create(bengkelBaru)

        SessionService.shared.user = .bengkel(bengkelBaru)
    }
}

struct PengaturanHargaBengkel_Previews: PreviewProvider {
    static var previews: some View {
        PengaturanHargaBengkel(bengkelOwnerFormViewModel: BengkelOwnerOnboardingView().viewModel, pengaturanBengkelForm: PengaturanBengkel(bengkelOwnerForm: BengkelOwnerOnboardingView()))
    }
}
