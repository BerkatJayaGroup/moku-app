//
//  SuntingMechanic.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import SwiftUI

struct SuntingMechanic: View {
    @State var mechanicName: String?
    
    @State var image: [UIImage] = []
    @State var showImagePicker: Bool = false
    @State private var showActionSheet = false
    @State var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    var body: some View {
        VStack{
            Image("profile")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .clipShape(Circle())
                .padding(.bottom, 10)
            
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
            Button(action: {
                
            }, label: {
                Text("Simpan Perubahan")
                    .frame(width: 309, height: 44, alignment: .center)
                    .foregroundColor(.white)
                    .background(AppColor.primaryColor)
                    .cornerRadius(8)
            })
            Button(action: {
                
            }, label: {
                Text("Hapus Mekanik")
                    .frame(width: 309, height: 44, alignment: .center)
                    .foregroundColor(AppColor.primaryColor)
                    .background(Color(hex: "F8D8BF"))
                    .cornerRadius(8)
            })
        }
        .padding()
    }
    
    @ViewBuilder
    func uploadButton() -> some View {
        Button("Ubah Foto") {
            self.showActionSheet.toggle()
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: self.sourceType, pickerResult: $image)
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
}

struct SuntingMechanic_Previews: PreviewProvider {
    static var previews: some View {
        SuntingMechanic()
    }
}
