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
    @State var showImagePicker: Bool = false
    @State private var showActionSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
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
                                                action: {showSheetView = false}),
                                trailing: Button("Tambah", action: tambahMekanik))
        }
    }

    @ViewBuilder func uploadButton() -> some View {
        Button("Upload photo") {
            self.showActionSheet.toggle()
        }
        .sheet(isPresented: $showImagePicker) {            ImagePicker(sourceType: sourceType, pickerResult: $image)
        }
        .actionSheet(isPresented: $showActionSheet) {
            ActionSheet(
                title: Text("Choose mode"),
                message: Text("Please choose your preferred mode to set your profile image"),
                buttons: [
                    .default(Text("Camera")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .camera
                    },
                    .default(Text("Photo Library")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .photoLibrary
                    },
                    .cancel()
                ]
            )
        }
    }

    func tambahMekanik() {
        showSheetView = false
        if isUpload {
            guard let image = image.first, let id = Auth.auth().currentUser?.uid else { return }
            StorageService.shared.upload(image: image,
                                         path: "\(id)/mechanics/\(UUID().uuidString)") { url, _ in
                guard let url = url?.absoluteString else { return }
                let newMechanic = Mekanik(name: mechanicName ?? "", photo: url)
                BengkelRepository.shared.appendMechanic(mechanic: newMechanic, to: id)
            }
            presentationMode.wrappedValue.dismiss()
        } else {
            let calonMekanik: CalonMekanik
            if image.count > 0 {
                calonMekanik = CalonMekanik(name: mechanicName!, photo: image[0])
            } else {
                calonMekanik = CalonMekanik(name: mechanicName!)
            }
            mechanics.append(calonMekanik)
        }
    }
}

struct CalonMekanik: Hashable {
    var name: String
    var photo: UIImage?
}

extension CalonMekanik: Identifiable {
    var id: String { name }
}
