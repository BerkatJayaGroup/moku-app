//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI
import PhotosUI

struct BengkelOwnerOnboardingView: View {
    @StateObject var viewModel = ViewModel()
  
    var config: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images // videos, livePhotos...
        config.selectionLimit = 0 // 0 => any, set 1-2-3 for har limit
        return config
    }
  
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false

    init() {
        UITableView.appearance().backgroundColor = .clear
        UITableView.appearance().separatorColor = .clear
        UITableView.appearance().sectionFooterHeight = 0
    }

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing:24) {
                VStack(alignment: .leading ,spacing:8) {
                    textField(title: "NAMA PEMILIK", placeholder: "Tulis namamu disini", text: $viewModel.ownerName, alert: "Nama Wajib Diisi")
                    textField(title: "NAMA BENGKEL", placeholder: "Tulis nama bengkelmu disini", text: $viewModel.bengkelName, alert: "Nama Bengkel Wajib Diisi")

                    locationField()

                    textField(title: "NOMOR TELEPON BENGKEL", placeholder: "08xx-xxxx-xxxx", text: $viewModel.phoneNumber, alert: "Nomor Telepon Wajib Diisi", keyboardType: .numberPad)

                    Section(header: header(title: "FOTO BENGKEL")) {
                        if viewModel.images != [] {
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
                                    ForEach(viewModel.images, id: \.self) { image in
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
                    .sheet(isPresented: $shouldPresentImagePicker) {
                        if !self.shouldPresentCamera {
                            ImagePHPicker(configuration: self.config, pickerResult: $viewModel.images, isPresented: $shouldPresentImagePicker)
                        } else {
                            ImagePicker(sourceType: .camera, pickerResult: $viewModel.images)
                        }
                    }.actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                        ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = true
                        }), ActionSheet.Button.default(Text("Photo Library"), action: {
                            self.shouldPresentImagePicker = true
                            self.shouldPresentCamera = false
                        }), ActionSheet.Button.cancel()])
                    }
                }
                if viewModel.images.isEmpty, viewModel.isSubmitting {
                    Text("Minimal 1 foto").alertStyle()
                }
                Spacer()
                submitButton(proxy: proxy)
            }
            .sheet(isPresented: $viewModel.isSelectingLocation) {
                LocationSearchView(onSelect: viewModel.updateLocation).sheetStyle()
            }
            .navigationBarTitle("Profil Bengkel", displayMode: .inline)
        }
        .padding()
    }
}

struct BengkelOwnerOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BengkelOwnerOnboardingView()
    }
}

// MARK: - View Components
extension BengkelOwnerOnboardingView {
    func header(title: String) -> some View {
        Text(title).headerStyle()
    }

    @ViewBuilder
    private func submitButton(proxy: GeometryProxy) -> some View {
        NavigationLink(destination: PengaturanBengkel(bengkelOwnerForm: self), isActive: $viewModel.isSettingDetail) { EmptyView() }

        Button {
            viewModel.openBengkelSetting()
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
            .frame(width: (proxy.size.width * 0.9))
        }
    }

    private func locationField() -> some View {
        Section(header: header(title: "ALAMAT")) {
            VStack(alignment: .trailing) {
                HStack {
                    Button {
                        viewModel.selectLocation()
                    } label: {
                        if let address = viewModel.address {
                            Text(address).foregroundColor(.primary).lineLimit(1)
                        } else {
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text("Cari alamat bengkelmu disini")
                            }
                            .foregroundColor(.tertiaryLabel)
                        }
                    }
                    Spacer()
                }
                .padding(10)
                .background(AppColor.lightGray)
                .cornerRadius(8)
                // Alert
                locationAlert()
            }
        }
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        alert: String,
        keyboardType: UIKeyboardType = .default
    ) -> some View {
        Section(header: header(title: title)) {
            VStack(alignment: .trailing) {
                TextField(placeholder, text: text)
                    .font(.subheadline)
                    .keyboardType(keyboardType)
                    .padding(10)
                    .background(AppColor.lightGray)
                    .cornerRadius(8)
                emptyAlert(for: text, alert: alert)
            }
        }
    }

    @ViewBuilder
    private func locationAlert() -> some View {
        if viewModel.location == nil, viewModel.isSubmitting {
            Text("Alamat Wajib Diisi").alertStyle()
        }
    }

    @ViewBuilder
    private func emptyAlert(for text: Binding<String>, alert: String) -> some View {
        if text.wrappedValue.isEmpty, viewModel.isSubmitting {
            Text(alert).alertStyle()
        }
    }
}
