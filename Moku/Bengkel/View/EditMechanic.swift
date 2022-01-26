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
    @State var isEditing = false
    @State var saveAlert = false
    @State var isRemove = false
    init(mechanic: Mekanik) {
        let viewModel = ViewModel(mechanic: mechanic)
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
                            if shouldDismiss {
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
        } else {
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
                if isEditing {
                    uploadButton()
                }
                VStack(alignment: .leading) {
                    Text("NAMA MEKANIK")
                        .font(Font.system(size: 11, weight: .regular))
                    TextField("Tulis Nama Mekanik", text: $viewModel.mechanicName)
                        .disabled(!isEditing)
                        .font(.subheadline)
                        .padding(15)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.bottom)
                }
                Spacer()
                if isEditing {
                    Button {
                        saveAlert = true
                    }label: {
                        Text("Simpan Perubahan")
                            .frame(width: 309, height: 44, alignment: .center)
                            .font(.system(size: 17), weight: .bold)
                            .foregroundColor(.white)
                            .background(AppColor.primaryColor)
                            .cornerRadius(8)
                    }.alert(isPresented: $saveAlert) {
                        Alert(
                            title: Text("Simpan Perubahan?"),
                            message: Text("Perubahan yang dilakukan akan memengaruhi data mekanik di bengkel anda"),
                            primaryButton: .destructive(Text("Simpan")) {
                                viewModel.isLoading = true
                                viewModel.updateMechanic()
                                self.isEditing.toggle()
                            },
                            secondaryButton: .cancel(Text("Batal"))
                        )
                    }
                }
                Button {
                    self.isRemove.toggle()
                } label: {
                    Text("Hapus Mekanik")
                        .frame(width: 309, height: 44, alignment: .center)
                        .font(.system(size: 17), weight: .bold)
                        .foregroundColor(AppColor.primaryColor)
                        .background(Color(hex: "F8D8BF"))
                        .cornerRadius(8)
                }.alert(isPresented: $isRemove) {
                    Alert(
                        title: Text("Hapus Mekanik?"),
                        message: Text("Perubahan yang dilakukan akan memengaruhi data mekanik di bengkel anda"),
                        primaryButton: .destructive(Text("Hapus")) {
                            viewModel.removeMechanic()
                            presentationMode.wrappedValue.dismiss()
                        },
                        secondaryButton: .cancel(Text("Batal"))
                    )
                }
            }
            .toolbar {
                Button {
                    self.isEditing.toggle()
                    if isEditing == false {
                        viewModel.mechanicName = viewModel.nameFirst
                    }
                }label: {
                    Text(isEditing ? "Batal" : "Ubah")
                        .foregroundColor(.white)
                }
            }
            .padding()
            .onReceive(viewModel.viewDismissalModePublisher) { shouldDismiss in
                        if shouldDismiss {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }

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
                title: Text("Pilih Mode"),
                message: Text("Mohon pilih metode pengambilan gambar untuk foto profil mekanik"),
                buttons: [
                    .default(Text("Kamera")) {
                        viewModel.showImagePicker.toggle()
                        viewModel.sourceType = .camera
                    },
                    .default(Text("Ambil dari galeri")) {
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
