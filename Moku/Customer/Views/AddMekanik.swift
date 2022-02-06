//
//  addMekanik.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI
import FirebaseAuth

struct AddMekanik: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showSheetView: Bool
    @Binding var mechanics: [CalonMekanik]
    @State var mechanicName: String?
    @State var image: [UIImage] = []
    @State var isUpload: Bool = false
    @State var isLoading = false
    @State var showImagePicker: Bool = false
    @State private var showActionSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State var isManageMechanic: Bool = false

    var body: some View {
        if isLoading {
            ProgressView()
        } else {
            NavigationView {
                VStack {
                    if image == [] {
                        Image("profile")
                            .resizable()
                            .frame(width: 100, height: 100, alignment: .center)
                            .clipShape(Circle())
                            .padding(.bottom, 10.0)
                    } else {
                        if let image = image {
                            Image(uiImage: image[0])
                                .resizable()
                                .frame(width: 100, height: 100, alignment: .center)
                                .clipShape(Circle())
                                .padding(.bottom, 10.0)
                        }
                    }
                    uploadButton()
                    VStack(alignment: .leading) {
                        Text("NAMA MEKANIK")
                            .font(Font.system(size: 11, weight: .regular))
                        TextField("Tulis Nama Mekanik", text: $mechanicName)
                            .font(.subheadline)
                            .padding(15)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                            .padding(.bottom)
                    }
                    Spacer()
                }
                .padding()
                .edgesIgnoringSafeArea(.leading)
                .navigationBarTitle("Tambah Mekanik", displayMode: .inline)
                .navigationBarItems(leading: Button("Kembali",
                                                    action: {
                    showSheetView = false
                }),
                                    trailing: Button {
                    isLoading = true
                    tambahMekanik()
                }label: {
                    Text("Tambah")
                })
            }.accentColor(isManageMechanic ? .white : AppColor.primaryColor)
        }
    }

    @ViewBuilder func uploadButton() -> some View {
        Button {
            self.showActionSheet.toggle()
        } label: {
            Text("Unggah foto")
                .foregroundColor(AppColor.primaryColor)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: sourceType, pickerResult: $image)
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Pilih Metode"),
                message: Text("Mohon pilih metode pengambilan gambar untuk foto profil mekanik"),
                buttons: [
                    .default(Text("Kamera")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .camera
                    },
                    .default(Text("Ambil dari galeri")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .photoLibrary
                    },
                    .cancel(Text("Batal"))
                ]
            )
        }
    }

    func tambahMekanik() {
        let mechanicNew = CalonMekanik(name: mechanicName ?? "", photo: image.first)
        guard let id = Auth.auth().currentUser?.uid else { return }
        if let image = image.first {
            StorageService.shared.upload(image: image,
                                         path: "mechanics/\(UUID().uuidString)") { url, _ in
                guard let url = url?.absoluteString else { return }
                let newMechanic = Mekanik(name: mechanicName ?? "", photo: url)
                BengkelRepository.shared.appendMechanic(mechanic: newMechanic, to: id) {_ in
                    isLoading = false
                    showSheetView = false
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            let newMechanic = Mekanik(name: mechanicName ?? "", photo: "")
            BengkelRepository.shared.appendMechanic(mechanic: newMechanic, to: id) {_ in
                isLoading = false
                showSheetView = false
                presentationMode.wrappedValue.dismiss()
            }
        }
        mechanics.append(mechanicNew)
    }
}

struct CalonMekanik: Hashable {
    var name: String
    var photo: UIImage?
}

extension CalonMekanik: Identifiable {
    var id: String { name }
}
