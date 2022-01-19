//
//  SuntingMechanic.swift
//  Moku
//
//  Created by Mac-albert on 23/11/21.
//

import SwiftUI
import SDWebImageSwiftUI
import FirebaseAuth

struct EditMechanic: View {
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel: ViewModel
    @State private var showingAlert = false
    init(mechanic: Mekanik) {
        let viewModel = ViewModel(mechanic: mechanic)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack {
            if viewModel.image.isEmpty {
                if let image = viewModel.mechanic.photo {
                    WebImage(url: URL(string: image))
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                } else {
                    Image("profile")
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                }
            } else {
                if let image = viewModel.image.last {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 100, height: 100, alignment: .center)
                        .clipShape(Circle())
                        .padding(.bottom, 10)
                }
            }

            VStack(alignment: .leading) {
                Text("NAMA MEKANIK")
                    .font(Font.system(size: 11, weight: .regular))
                TextField("Tulis Nama Mekanik", text: $viewModel.mechanicName)
                    .disabled(true)
                    .font(.subheadline)
                    .padding(15)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom)
            }
            Spacer()
            Button(action: {
                showingAlert = true
            }, label: {
                Text("Hapus Mekanik")
                    .frame(width: 309, height: 44, alignment: .center)
                    .font(.system(size: 17), weight: .bold)
                    .foregroundColor(AppColor.primaryColor)
                    .background(Color(hex: "F8D8BF"))
                    .cornerRadius(8)
            })
        }
        .padding()
        .alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text("Apa kamu yakin ingin menghapus mekanik ini?"),
                        message: Text("Setelah kamu menekan tombol hapus, mekanik akan terhapus secara permanen"),
                        primaryButton: .destructive(Text("Hapus")) {
                            viewModel.removeMechanic()
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel(Text("Batal"))
                    )
                }
    }

    @ViewBuilder
    func uploadButton() -> some View {
        Button("Ubah Foto") {
            viewModel.showActionSheet.toggle()
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(sourceType: viewModel.sourceType, pickerResult: $viewModel.image)
        }
        .actionSheet(isPresented: $viewModel.showActionSheet) {
            ActionSheet(
                title: Text("Choose mode"),
                message: Text("Please choose your preferred mode to set your profile image"),
                buttons: [
                    .default(Text("Camera")) {
                        viewModel.showImagePicker.toggle()
                        viewModel.sourceType = .camera
                    },
                    .default(Text("Photo Library")) {
                        viewModel.showImagePicker.toggle()
                        viewModel.sourceType = .photoLibrary
                    },
                    .cancel()
                ]
            )
        }
    }
}

struct EditMechanic_Previews: PreviewProvider {
    static var previews: some View {
        EditMechanic(mechanic: Mekanik.init(id: "1", name: "Albert"))
    }
}
