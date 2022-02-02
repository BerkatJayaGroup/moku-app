//
//  BengkelProfileView.swift
//  Moku
//
//  Created by Christianto Budisaputra on 22/11/21.
//

import SwiftUI
import PhotosUI
import SDWebImageSwiftUI

struct BengkelProfileView: View {
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    @StateObject private var viewModel: BengkelProfileViewModel

    init(bengkel: Bengkel) {
        let viewModel = BengkelProfileViewModel(bengkel: bengkel)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        if viewModel.isLoading {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        } else if let selectedPhoto = viewModel.selectedPhoto {
            ZStack {
                Image(uiImage: selectedPhoto)
                    .resizable()
                    .scaledToFit()

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.selectedPhoto = nil
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }.background(Color.black.ignoresSafeArea())
        } else if let selectedPhotoUrl = viewModel.selectedPhotoUrl,
                  let url = URL(string: selectedPhotoUrl) {
            ZStack {
                WebImage(url: url)
                    .resizable()
                    .scaledToFit()

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            viewModel.selectedPhotoUrl = nil
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding()
                        }
                    }
                    Spacer()
                }
            }.background(Color.black.ignoresSafeArea())
        } else {
            contentView
                .padding()
                .toolbar { toolbar() }
                .navigationBarTitle("Profile", displayMode: .inline)
                .onAppear {
                    viewModel.fetch()
                }
        }
    }

    private var contentView: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 24) {
                textField(title: "Nama Bengkel", text: $viewModel.bengkelName)
                locationField()
                textField(title: "Nomor Telepon", text: $viewModel.bengkelPhoneNumber)
                bengkelPhotos()
                Spacer()
                if viewModel.isEditing {
                    saveButton()
                }
            }
            .padding()
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .bengkelLocation:
                LocationSearchView(onSelect: viewModel.updateLocation).sheetStyle()
            case .mediaSource(let source):
                switch source {
                case .camera:
                    ImagePicker(sourceType: .camera, pickerResult: $viewModel.photosToUpload)
                case .library:
                    ImagePHPicker(pickerResult: $viewModel.photosToUpload, isPresented: $viewModel.isPresentingLibrary)
                }
            }
        }
        .alert(item: $viewModel.activeAlert) { alert in
            switch alert {
            case .delete:
                return Alert(
                    title: Text("Hapus Foto?"),
                    message: Text("Perubahan yang dilakukan akan memengaruhi pencarian bengkel Anda"),
                    primaryButton: .destructive(Text("Hapus")) {
                        viewModel.removePhoto()
                    },
                    secondaryButton: .cancel(Text("Batal")) {
                        viewModel.activeAlert = .none
                        viewModel.photoToRemove = nil
                    }
                )
            case .save:
                return Alert(
                    title: Text("Simpan Perubahan?"),
                    message: Text("Perubahan yang dilakukan akan memengaruhi pencarian bengkel Anda"),
                    primaryButton: .destructive(Text("Simpan")) {
                        viewModel.saveChanges {
                            viewModel.isEditing = false
                            viewModel.photosToRemove = []
                            viewModel.photosToUpload = []
                            viewModel.fetch()
                        }
                    },
                    secondaryButton: .cancel(Text("Batal")) {
                        viewModel.activeAlert = .none
                    }
                )
            }
        }
        .actionSheet(isPresented: $viewModel.isPresentingActionScheet) {
            ActionSheet(
                title: Text("Choose mode"),
                message: Text("Please choose your preferred mode to set your profile image"),
                buttons: [
                    .default(Text("Camera")) {
                        viewModel.activeSheet = .mediaSource(source: .camera)
                    },
                    .default(Text("Photo Library")) {
                        viewModel.activeSheet = .mediaSource(source: .library)
                    },
                    .cancel()
                ]
            )
        }
    }
}

extension BengkelProfileView {
    @ViewBuilder
    private func locationField() -> some View {
        if viewModel.isEditing {
            VStack(alignment: .leading) {
                Text("ALAMAT").font(.caption2)
                HStack {
                    Button {
                        viewModel.activeSheet = .bengkelLocation
                    } label: {
                        if let address = viewModel.bengkelAddress {
                            Text(address)
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.leading)
                        } else {
                            HStack {
                                Image(systemName: "mappin.circle")
                                Text("Cari Alamat Bengkelmu Disini").font(.system(size: 16))
                            }.foregroundColor(.tertiaryLabel)
                        }
                    }
                    Spacer()
                }
                .padding(10)
                .background(Color.secondarySystemBackground)
                .cornerRadius(8)
            }
        } else {
            VStack(alignment: .leading) {
                Text("ALAMAT").font(.caption2)
                HStack {
                    Text(viewModel.bengkelAddress)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding(10)
                .background(Color.secondarySystemBackground)
                .cornerRadius(8)
            }
        }
    }

    private func saveButton() -> some View {
        Button {
            viewModel.activeAlert = .save
        } label: {
            Text("Simpan")
                .semibold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(AppColor.primaryColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
    }

    private func bengkelPhotos() -> some View {
        VStack(alignment: .leading) {
            Text("Foto Bengkel").font(.headline)
            LazyVGrid(columns: columns, spacing: 16) {
                if viewModel.isEditing {
                    Button {
                        viewModel.isPresentingActionScheet = true
                    } label: {
                        VStack(spacing: 16) {
                            Image(systemName: "plus").font(.title2)
                            Text("Tambah Foto").font(.subheadline)
                        }
                        .frame(width: 150, height: 120, alignment: .center)
                        .background(AppColor.lightGray)
                        .cornerRadius(8)
                    }
                }
                ForEach(viewModel.bengkelPhotos, id: \.self) { photoUrl in
                    if let url = URL(string: photoUrl) {
                        ZStack {
                            WebImage(url: url)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 120, alignment: .center)
                                .cornerRadius(8)
                                .onTapGesture {
                                    viewModel.selectedPhotoUrl = photoUrl
                                }

                            if viewModel.isEditing {
                                VStack {
                                    HStack {
                                        Spacer()
                                        Button {
                                            viewModel.photoToRemove = photoUrl
                                            viewModel.activeAlert = .delete
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.caption.bold())
                                                .padding(.small)
                                                .foregroundColor(AppColor.primaryColor)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                                .shadow(color: .black.opacity(0.3), radius: 4, x: -2, y: 2)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.small)
                                .padding(.trailing, 2)
                            }
                        }
                    } else {
                        EmptyView()
                    }
                }
                ForEach(viewModel.photosToUpload, id: \.self) { uiImage in
                    ZStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 120, alignment: .center)
                            .cornerRadius(8)
                            .onTapGesture {
                                viewModel.selectedPhoto = uiImage
                            }

                        if viewModel.isEditing {
                            VStack {
                                HStack {
                                    Spacer()
                                    Button {
                                        viewModel.activeAlert = .delete
                                    } label: {
                                        Image(systemName: "xmark")
                                            .font(.caption.bold())
                                            .padding(.small)
                                            .foregroundColor(AppColor.primaryColor)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                            .shadow(color: .black.opacity(0.3), radius: 4, x: -2, y: 2)
                                    }
                                }
                                Spacer()
                            }
                            .padding(.small)
                            .padding(.trailing, 2)
                        }
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func textField(title: String, text: Binding<String>) -> some View {
        if viewModel.isEditing {
            VStack(alignment: .leading) {
                Text(title.uppercased()).font(.caption2)
                TextField("Berkat Jaya Motor", text: text).roundedStyle()
            }
        } else {
            VStack(alignment: .leading) {
                Text(title.uppercased()).font(.caption2)
                HStack {
                    Text(text.wrappedValue).font(.system(size: 15))
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .foregroundColor(.primary)
                .padding(.vertical, 11)
                .padding(.horizontal, 10)
                .background(Color.secondarySystemBackground)
                .cornerRadius(8)
            }
        }
    }

    private func toolbar() -> some View {
        Button(!viewModel.isEditing ? "Sunting" : "Batal") {
            viewModel.toggleEditing()
        }
    }
}

struct BengkelProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BengkelProfileView(bengkel: .preview)
        }
    }
}
