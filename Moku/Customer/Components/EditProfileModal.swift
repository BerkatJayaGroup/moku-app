//
//  EditProfileModal.swift
//  Moku
//
//  Created by Naufaldi Athallah Rifqi on 11/11/21.
//

import SwiftUI
import FirebaseAuth

struct EditProfileModal: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var phoneNumber = ""
    @State private var email = ""

    @ObservedObject var garageTabViewModel: GarageTabViewModel = .shared

    var customer: Customer

    init(customer: Customer) {
        self.customer = customer
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
    }

    private var backButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            HStack {
                Image(systemName: "chevron.left").aspectRatio(contentMode: .fit)
                Text("Back")
            }
        }
    }

    private var editButton: some View {
        Button("Sunting") {
            let updatedCustomer = Customer(
                id: customer.id,
                name: !name.isEmpty ? self.name : customer.name,
                phoneNumber: !phoneNumber.isEmpty ? self.phoneNumber : customer.phoneNumber
            )
            garageTabViewModel.update(updatedCustomer)
            presentationMode.wrappedValue.dismiss()
        }
    }

    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                textField(title: "NAMA", placeholder: customer.name, text: $name)
                textField(
                    title: "NOMOR TELEPON",
                    placeholder: customer.phoneNumber,
                    text: $phoneNumber,
                    keyboardType: .numberPad
                )
            }

            Spacer()

            Button {
                try? Auth.auth().signOut()
                AppState.shared.viewID = UUID()
            } label: {
                HStack {
                    Spacer()
                    Text("Keluar").fontWeight(.semibold)
                    Spacer()
                }
            }
            .padding(12)
            .background(Color(hex: "FFF4E9"))
            .cornerRadius(9)
            .padding(.horizontal, 24)
        }
        .padding(24)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitle("Profil", displayMode: .inline)
        .navigationBarItems(
            leading: backButton,
            trailing: (!name.isEmpty || !phoneNumber.isEmpty) ? AnyView(editButton) : AnyView(EmptyView())
        )
    }

    private func header(title: String) -> some View {
        Text(title).headerStyle()
    }

    private func textField(
        title: String,
        placeholder: String,
        text: Binding<String>,
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
                    .padding(.bottom)
            }
        }
    }
}

struct EditProfileModal_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileModal(customer: .preview)
    }
}
