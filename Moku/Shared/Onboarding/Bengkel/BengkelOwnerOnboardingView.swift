//
//  BengkelOwnerOnboardingView.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 28/10/21.
//

import SwiftUI
import Contacts
import PhotosUI

struct BengkelOwnerOnboardingView: View {
    @State var ownerName: String = ""
    @State var bengkelName: String = ""
    @State var bengkelAddress: String = ""
    @State var bengkelPhoneNumber: String = ""
    @State var isNavigateActive = false
    @State private var image = UIImage()
    @State var pickerResult: [UIImage] = []
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false

    var config: PHPickerConfiguration {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.filter = .images // videos, livePhotos...
        config.selectionLimit = 0 // 0 => any, set 1-2-3 for har limit
        return config
    }

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
                                $bengkelAddress)
                }
                Section(header: Text("NOMOR TELEPON BENGKEL")) {
                    TextField("08xx-xxxx-xxxx", text: $bengkelPhoneNumber).keyboardType(.numberPad)
                }
                Section(header: Text("FOTO BENGKEL")) {
                    if pickerResult != [] {
                        ScrollView(.horizontal) {
                            HStack {
                                VStack {
                                    Text("+").font(.system(size: 30)).padding()
                                    Text("Tambah Foto")
                                }
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    self.shouldPresentActionScheet = true
                                }
                                ForEach(pickerResult, id: \.self) { image in
                                    Image.init(uiImage: image)
                                        .resizable()
                                        .frame(width: 100, height: 100, alignment: .center)
                                        .aspectRatio(contentMode: .fit)
                                }
                            }
                        }
                    } else {
                        VStack {
                            Text("+").font(.system(size: 30)).padding()
                            Text("Tambah Foto")
                        }
                        .frame(maxWidth: .infinity).padding(.horizontal, 20)
                        .onTapGesture {
                            self.shouldPresentActionScheet = true
                        }
                    }
                }
                .sheet(isPresented: $shouldPresentImagePicker) {
                    if !self.shouldPresentCamera {
                        ImagePHPicker(configuration: self.config, pickerResult: $pickerResult, isPresented: $shouldPresentImagePicker)
                    } else {
                        ImagePicker(sourceType: .camera, pickerResult: $pickerResult)
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
            NavigationLink(destination: PengaturanBengkel(), isActive: $isNavigateActive) {
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

struct BengkelOwnerOnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        BengkelOwnerOnboardingView()
    }
}
