//
//  PengaturanHargaBengkelView.swift
//  Moku
//
//  Created by Dicky Buwono on 27/10/21.
//

import SwiftUI

struct PengaturanHargaBengkelView: View {
    var bengkelOwnerFormViewModel: BengkelOwnerOnboardingView.ViewModel
    var pengaturanBengkelForm: PengaturanBengkel

    @StateObject private var viewModel = PengaturanHargaBengkelViewModel()

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .navigationBarBackButtonHidden(true)
        } else {
            contentView
        }
    }

    var contentView: some View {
        GeometryReader { proxy in
            NavigationView {
                VStack(alignment: .center) {
                    Text("Masukkan harga jasa service rutin, umumnya service rutin mencakup jasa pengecekan mesin, busa filter, pengecekan komponen ban, lampu, rantai, dan lainnya.")
                        .font(.system(size: 13))
                        .padding(.bottom)
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                    HStack {
                        VStack {
                            TextField("Rp minimum", text: $viewModel.minPrice)
                                .font(.system(size: 15))
                                .padding(10)
                                .background(Color(.systemGray5))
                                .cornerRadius(9)
                                .keyboardType(.numberPad)
                            emptyAlert(for: $viewModel.minPrice, alert: "Harga minimal harus diisi")
                        }
                        Text("-")
                        VStack {
                            TextField("Rp maksimum", text: $viewModel.maxPrice)
                                .font(.system(size: 15))
                                .padding(10)
                                .background(Color(.systemGray5))
                                .cornerRadius(9)
                                .keyboardType(.numberPad)
                            emptyAlert(for: $viewModel.maxPrice, alert: "Harga maksimal harus diisi")
                        }
                    }.padding()
                    Spacer()
                    Text("Harga yang Anda masukkan dapat diubah sesuai dengan kerusakan komponen dan kesepakatan dengan pelanggan")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                    submitButton(proxy: proxy)
                }
                .onTapGesture {
                    dismissKeyboard()
                }
                .padding()
                .navigationBarTitle("Pengaturan Harga", displayMode: .inline)
            }
        }
    }

    @ViewBuilder
    private func submitButton(proxy: GeometryProxy) -> some View {
        Button {
            viewModel.validateForm()
            if viewModel.isFormValid {
                viewModel.createBengkel(bengkelOwnerFormViewModel: bengkelOwnerFormViewModel, pengaturanBengkelForm: pengaturanBengkelForm)
            }
        } label: {
            HStack {
                Spacer()
                Text("Selesai").bold()
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
        if text.wrappedValue.isEmpty, viewModel.isSubmitting {
            Text(alert).alertStyle()
        }
    }
}

struct PengaturanHargaBengkel_Previews: PreviewProvider {
    static var previews: some View {
        PengaturanHargaBengkelView(bengkelOwnerFormViewModel: BengkelOwnerOnboardingView().viewModel, pengaturanBengkelForm: PengaturanBengkel(bengkelOwnerForm: BengkelOwnerOnboardingView()))
    }
}
