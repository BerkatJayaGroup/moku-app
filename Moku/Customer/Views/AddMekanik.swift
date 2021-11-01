//
//  addMekanik.swift
//  Moku
//
//  Created by Mac-albert on 26/10/21.
//

import SwiftUI

struct AddMekanik: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var showSheetView: Bool
    @Binding var mechanics : [calonMekanik]
    @State var mechanicName: String?
    @State var image: [UIImage] = []
    
    @State var showImagePicker: Bool = false
    @State private var showActionSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary

    var body: some View {
        NavigationView{
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
                UploadButton()
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
    
    @ViewBuilder func UploadButton() -> some View {
        Button("Upload photo") {
            self.showActionSheet.toggle()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, pickerResult: $image)
        }
        .actionSheet(isPresented: $showActionSheet) { () -> ActionSheet in
            ActionSheet(
                title: Text("Choose mode"),
                message: Text("Please choose your preferred mode to set your profile image"),
                buttons: [
                    ActionSheet.Button.default(Text("Camera")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .camera
                    },
                    ActionSheet.Button.default(Text("Photo Library")) {
                        self.showImagePicker.toggle()
                        self.sourceType = .photoLibrary
                    },
                    ActionSheet.Button.cancel()
                ]
            )
        }
    }
    
    func tambahMekanik(){
        showSheetView = false
        let calonMekanik = calonMekanik(name: mechanicName!, photo: image[0])
        mechanics.append(calonMekanik)
    }
}

struct calonMekanik : Hashable{
    var name: String
    var photo: UIImage?
}
