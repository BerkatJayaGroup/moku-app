//
//  ServiceInformationView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 25/11/21.
//

import SwiftUI
import PhotosUI

struct FinishBookingView: View {

    @StateObject var viewModel: FinishBookingViewModel
    @State private var spareParts = ""
    @State private var notes = ""
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    @State private var shouldPresentSparepartsSheet = false
    @State private var bills: [UIImage] = []

    init(order: Order) {
        let viewModel = FinishBookingViewModel(order: order)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var config: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images // videos, livePhotos...
        config.selectionLimit = 0 // 0 => any, set 1-2-3 for har limit
        return config
    }

    var body: some View {
        NavigationView {
            Form {
                textField(title: "Suku Cadang yang diganti", placeholder: "Tekan tambah suku cadang untuk menambah suku cadang yang diganti", text: $spareParts, alert: "Harus diisi", isSparePart: true)
                textField(title: "Keterangan Pengerjaan", placeholder: "Deskripsikan kerjaan yang kamu kerjakan pada motor pelanggan", text: $notes, alert: "Harus diisi", isSparePart: false)
                Section(header: header(title: "Foto Nota")) {
                    if bills != [] {
                        ScrollView(.horizontal) {
                            HStack {
                                VStack {
                                    Text("+").font(.system(size: 30))
                                        .foregroundColor(AppColor.primaryColor)
                                    Text("Tambah Foto")
                                        .font(.system(size: 15))
                                        .foregroundColor(AppColor.primaryColor)
                                        .padding(.bottom, 20)
                                }
                                .frame(width: 100, height: 100)
                                .background(AppColor.lightGray)
                                .cornerRadius(10)
                                .onTapGesture {
                                    self.shouldPresentActionScheet = true
                                }
                                ForEach(bills, id: \.self) { image in
                                    Image.init(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Text("+").font(.system(size: 40))
                                .foregroundColor(AppColor.primaryColor)
                            Text("Tambah Foto")
                                .foregroundColor(AppColor.primaryColor)
                                .padding(.bottom, 20)
                        }
                        .frame(width: 150, height: 100)
                        .background(AppColor.lightGray)
                        .cornerRadius(10)
                        .onTapGesture {
                            self.shouldPresentActionScheet = true
                        }
                    }
                }
                .textCase(nil)
                .listRowInsets(EdgeInsets())
                .sheet(isPresented: $shouldPresentImagePicker) {
                    if !self.shouldPresentCamera {
                        ImagePHPicker(configuration: self.config, pickerResult: $bills, isPresented: $shouldPresentImagePicker)
                    } else {
                        ImagePicker(sourceType: .camera, pickerResult: $bills)
                    }
                }.actionSheet(isPresented: $shouldPresentActionScheet) {
                    ActionSheet(
                        title: Text("Choose mode"),
                        message: Text("Please choose your preferred mode to set your profile image"),
                        buttons: [
                            .default(Text("Camera")) {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = true
                            },
                            .default(Text("Photo Library")) {
                                self.shouldPresentImagePicker = true
                                self.shouldPresentCamera = false
                            },
                            .cancel()
                        ]
                    )
                }
            }
            .sheet(isPresented: $shouldPresentSparepartsSheet) {
               SparepartsListView()
            }
            .navigationTitle("Pesanan Selesai")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        alert: String,
        keyboardType: UIKeyboardType = .default,
        isSparePart: Bool
    ) -> some View {
        Section(header: header(title: title)) {
            if isSparePart {
                Text("+ Tambah Suku Cadang")
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.darkOrange)
                    .onTapGesture {
                        self.shouldPresentSparepartsSheet.toggle()
                    }
            }
            VStack(alignment: .trailing) {
                TextEditor(text: text)
                    .background(AppColor.lightGray)
                    .frame(minHeight: 100)
                    .cornerRadius(5)
                emptyAlert(for: text, alert: alert)
            }
        }
        .textCase(nil)
        .listRowInsets(EdgeInsets())
        .padding(.top)
    }

    func header(title: String) -> some View {
        Text(title).fontWeight(.bold).font(.subheadline)
    }

    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty {
            Text(alert).alertStyle()
        }
    }
}

// struct FinishBookingView_Previews: PreviewProvider {
//    static var previews: some View {
//        ServiceInformationView()
//    }
// }